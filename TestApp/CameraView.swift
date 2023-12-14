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
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Right Swipe to Open Camera")
                    .gesture(DragGesture(minimumDistance: 100)
                        .onEnded { _ in
                            self.isCameraPresented = true
                        })
                
                NavigationLink(destination: CameraView(), isActive: $isCameraPresented) {
                    EmptyView()
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // 更新は特に必要ないため、空にします
    }
}

#Preview {
    CameraView()
}
