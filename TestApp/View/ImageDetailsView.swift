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
        List(viewModel.imagesData) { imageData in
            Text(imageData.fileName)
        }
    }
}

#Preview {
    ImageDetailsView()
        .environmentObject(GetImageViewModel())
}
