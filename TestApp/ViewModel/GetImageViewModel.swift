//
//  GetImageViewModel.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/12.
//
import SwiftUI
import Foundation

class GetImageViewModel: ObservableObject {
    @Published var imageUrlString: String = "https://i.imgur.com/UDbDHEI.jpeg"
    @Published var imageFileNames: [String] = []
    @Published var showImagePicker: Bool = false

    var albumImages: [UIImage] {
        imageFileNames.compactMap { loadImageFromLocal(fileName: $0) }
    }
    
    func handleImagesSelection(images: [UIImage]) {
        for image in images {
            if let fileName = saveImageLocally(image: image) {
                print("Handle Image Selection : \(fileName)")
                imageFileNames.append(fileName)
            }
        }
    }
    
    func getImageFromUrl() {
        guard let url = URL(string: imageUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    let image = UIImage(data:data)!
                    self.handleImagesSelection(images: [image])
                }
            }
        }.resume()
    }
    
    private func saveImageLocally(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return nil }
        let fileName = UUID().uuidString
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadImageFromLocal(fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}
