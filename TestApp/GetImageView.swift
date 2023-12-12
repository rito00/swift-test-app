import SwiftUI

struct GetImageView: View {
    @StateObject private var viewModel = GetImageViewModel()
    
    var body: some View {
        
        VStack {
            SelectedImageDisplayView(selectedImage: viewModel.selectedImage)
            ImageUrlInputView(imageUrlString: $viewModel.imageUrlString, onImageUrlSubmit: viewModel.getImageFromUrl)
            ImageLibraryView(albumImages: viewModel.albumImages, selectedImage: $viewModel.selectedImage, showImagePicker: $viewModel.showImagePicker, onImagePicked: viewModel.handleImageSelection)
        }
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
    }
}


struct SelectedImageDisplayView: View {
    var selectedImage: UIImage?
    
    var body: some View {
        if let selectedImage = selectedImage {
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200, maxHeight: 200)
            Text("Loaded Image")
        }
    }
}

struct ImageUrlInputView: View {
    @Binding var imageUrlString: String
    var onImageUrlSubmit: () -> Void
    
    var body: some View {
        VStack {
            TextField("Enter Image URL", text: $imageUrlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Load Image", action: onImageUrlSubmit)
                .padding()
        }
    }
}

struct ImageLibraryView: View {
    var albumImages: [UIImage]
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    var onImagePicked: (UIImage) -> ()

    var body: some View {
        VStack {
            Button("Load Image from Library") {
                showImagePicker = true
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage, onImagePicked: onImagePicked)
            }
            GeometryReader { geometry in
                let w = (geometry.size.width / 3)
                let columns: [GridItem] = Array(repeating: GridItem(.fixed(w), spacing: 0), count: 3) // 3列のグリッド
                
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(albumImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                                .clipped()
                                .border(Color.black, width: 1)
                        }
                    }
                }
                .border(Color.orange)
            }
        }
        .padding()
    }
    
    // 縦横比をチェックし、画像がランドスケープ（横長）かどうかを判断
    func isImageLandscape(image: UIImage) -> Bool {
        return image.size.width > image.size.height
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var onImagePicked: (UIImage) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            parent.onImagePicked(image)
        }
        
        parent.presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    GetImageView()
}
