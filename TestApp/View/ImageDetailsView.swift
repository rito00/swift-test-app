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
        List($viewModel.imagesData) { $imageData in
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
        .border(.black)
    }
}

#Preview {
    ImageDetailsView()
        .environmentObject(GetImageViewModel())
}
