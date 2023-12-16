import SwiftUI
import PhotosUI

struct GetImageView: View {
    //    @StateObject private var viewModel = GetImageViewModel()
    @EnvironmentObject var viewModel: GetImageViewModel
    @State var selectedImageData: ImageData?
    
    var body: some View {
        
        VStack {
            // Load Image from URL
            ImageUrlInputView(imageUrlString: $viewModel.imageUrlString, onImageUrlSubmit: viewModel.getImageFromUrl)
            // Take Photo with Camera
            CameraView(onPhotoTaken: viewModel.handleImagesSelection)
            
            // Load Image form Library
            ImageLibraryView(imagesData: viewModel.imagesData, showImagePicker: $viewModel.showImagePicker, onImageSelected: viewModel.handleImagesSelection, selectedImageData: $selectedImageData)
        }
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .overlay(
            selectedImageData != nil ?
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    selectedImageData = nil
                }
                .overlay(
                    VStack {
                        Image(uiImage: selectedImageData!.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        
                        Button(action: {
                            // ここで削除の処理を行う
//                            if let index = viewModel.albumImages.firstIndex(of: selectedImage!) {
//                                viewModel.albumImages.remove(at: index)
//                            }
                            viewModel.removeImage(imageData: selectedImageData!)
                            selectedImageData = nil
                        }) {
                            Text("Delete Image")
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    }
                )
            : nil
        )
    }
}

struct ImageUrlInputView: View {
    @Binding var imageUrlString: String
    var onImageUrlSubmit: () -> Void
    
    var body: some View {
        VStack {
            TextField("Enter Image URL", text: $imageUrlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)
            
            Button("Load Image", action: onImageUrlSubmit)
                .padding()
        }
    }
}

struct CameraView: View {
    @State private var isCameraPresented = false
    var onPhotoTaken: ([UIImage]) -> ()
    
    var body: some View {
        
        Button("Take Photo") {
            isCameraPresented = true
        }
        .sheet(isPresented: $isCameraPresented) {
            Camera(isCameraPresented: $isCameraPresented, onPhotoTaken: onPhotoTaken)
        }
    }
}

struct Camera: UIViewControllerRepresentable {
    @Binding var isCameraPresented: Bool
    var onPhotoTaken: ([UIImage]) -> ()
    
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
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: Camera
        
        init(_ parent: Camera) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                print("新しい画像が選択されました: \(String(describing: uiImage))")
                parent.onPhotoTaken([uiImage])
            }
            parent.isCameraPresented = false
        }
    }
}

struct ImageLibraryView: View {
    var imagesData: [ImageData]
    @Binding var showImagePicker: Bool
    var onImageSelected: ([UIImage]) -> ()
    @Binding var selectedImageData: ImageData?
    
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
                        ForEach(imagesData) { data in
                            Image(uiImage: data.image)
                                .resizable()
                                .aspectRatio(contentMode: isImageLandscape(image: data.image) ? .fit : .fill)
                                .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                                .clipped()
                                .border(Color.black, width: 0.5)
                                .onTapGesture {
                                    selectedImageData = data
                                }
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
        .environmentObject(GetImageViewModel())
}
