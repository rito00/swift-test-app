//
//  ImagesView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import SwiftUI

struct ImagesView: View {
    @State var isP = false
    var body: some View {
        NavigationView {
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                HStack(alignment: .center){
                    Image("dotty")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                    Text("Image Library")
                }
                .onTapGesture(perform: {
                    isP = true
                })
            }
            )
        }
        .navigationTitle("タイトル")
        .toolbarTitleDisplayMode(.automatic)
        .sheet(isPresented: $isP) {
            ImageDetailsView()
        }
        
        
    }
}

#Preview {
    ImagesView()
        .environmentObject(GetImageViewModel())
}
