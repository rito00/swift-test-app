//
//  ImageDetailsView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import SwiftUI

struct ImageDetailsView: View {
    @EnvironmentObject var viewModel: GetImageViewModel
    
    var body: some View {
//        Text("Image Details")
//            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//            .padding()
        List {
            ForEach($viewModel.imagesData) { $imageData in
                HStack {
                    Image(uiImage: imageData.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(imageData.fileName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        TextField("Caption", text: $imageData.caption)
                    }
                }
            }
 
        }
    }
}

#Preview {
    ImageDetailsView()
        .environmentObject(GetImageViewModel())
}
