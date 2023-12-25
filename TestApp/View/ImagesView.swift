//
//  ImagesView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import SwiftUI

struct ImagesView: View {
    var body: some View {
        TabView {
            GetImageView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Get Image")
                }
            ImageDetailsView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Details")
                }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    ImagesView()
        .environmentObject(GetImageViewModel())
}
