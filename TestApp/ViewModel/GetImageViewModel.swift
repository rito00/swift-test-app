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
    @Published var showImagePicker: Bool = false
    @Published var imagesData: [ImageData] = []
    
    func handleImagesSelection(images: [UIImage]) {
        for image in images {
            if let fileName = saveImageLocally(image: image) {
                let imageData = ImageData(image: image, fileName: fileName, caption: "")
                imagesData.append(imageData)
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
    
    func removeImage(imageData: ImageData) {
        // ドキュメントディレクトリ内の該当ファイルを削除
        let fileURL = getDocumentsDirectory().appendingPathComponent(imageData.fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Image removed: \(imageData.fileName)")
        } catch {
            print("Error removing image: \(error)")
        }

        // imagesData 配列からも削除
        if let index = imagesData.firstIndex(where: { $0.fileName == imageData.fileName }) {
            imagesData.remove(at: index)
        }
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

struct ImageData: Identifiable {
    let id = UUID()
    var image : UIImage
    var fileName : String
    var caption : String
}
