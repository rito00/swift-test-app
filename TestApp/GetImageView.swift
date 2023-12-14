import SwiftUI
import PhotosUI

struct GetImageView: View {
    @StateObject private var viewModel = GetImageViewModel()
    //    @State var selectedImages: [UIImage]
    
    var body: some View {
        
        VStack {
            ImageUrlInputView(imageUrlString: $viewModel.imageUrlString, onImageUrlSubmit: viewModel.getImageFromUrl)
            ImageLibraryView(albumImages: viewModel.albumImages, showImagePicker: $viewModel.showImagePicker, onImageSelected: viewModel.handleImagesSelection)
        }
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
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
    @Binding var showImagePicker: Bool
    var onImageSelected: ([UIImage]) -> ()
    
    var body: some View {
        VStack {
            Button("Load Image from Library") {
                showImagePicker = true
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                CustomImagePicker(onImageSelected: onImageSelected)
            }
            GeometryReader { geometry in
                let columns: [GridItem] = Array(repeating: GridItem(spacing: 0), count: 3) // 3列のグリッド
                
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(albumImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: isImageLandscape(image: image) ? .fit : .fill)
                                .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                                .clipped()
                                .border(Color.black, width: 0.5)
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
        print("image width : \(image.size.width), height : \(image.size.height)")
        return image.size.width > image.size.height
    }
}


struct CustomImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var onImageSelected: ([UIImage]) -> ()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // 0は無制限を意味します
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: CustomImagePicker
        
        init(_ parent: CustomImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            let dispatchGroup = DispatchGroup()
            var imageDict = [Int: UIImage]()
            
            for (index, result) in results.enumerated() {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    defer { dispatchGroup.leave() }
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            imageDict[index] = image
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // インデックスに従って画像をソート
                let sortedImages = results.indices.compactMap { imageDict[$0] }
                self.parent.onImageSelected(sortedImages)
            }
        }
    }
}

#Preview {
    GetImageView()
}
