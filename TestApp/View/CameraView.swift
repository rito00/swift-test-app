//
//  CameraView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/14.
//

import SwiftUI
import UIKit

struct CameraMainView: View {
    @State private var isCameraPresented = false
    @State private var image: UIImage?
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    Text("Right Swipe to Open Camera")
                }
                
                if isCameraPresented {
                    CameraView(isPresented: $isCameraPresented, image: $image)
                        .transition(.move(edge: .trailing))
                        .zIndex(1)
                }
            }
        }
        .gesture(DragGesture(minimumDistance: 50)
            .onEnded { value in
                if value.translation.width < 0 {
                    withAnimation {
                        self.isCameraPresented = true
                    }
                }
            })
        .onChange(of: image) { newImage, _ in
            print("新しい画像が選択されました: \(String(describing: newImage))")
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // 更新は特に必要ないため、空にします
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async {
                withAnimation {
                    self.parent.isPresented = false
                }
            }
        }
    }
}

#Preview {
    CameraMainView()
}
