//
//  ImagesView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import SwiftUI

struct ImagesView: View {
    @State var isDetailPagePresented = false
    @State var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                SelectImageView()
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("Get Image")
                    }
                    .tag(0)
                ImageDetailsView()
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("Details")
                    }
                    .tag(1)
            }
            // タブのスワイプで画面遷移
            .gesture(
                DragGesture().onEnded{ value in
                    if value.translation.width < 0 && selectedTab < 1 {
                        // 右から左にスワイプ
                        selectedTab += 1
                    }
                    else if value.translation.width > 0 && selectedTab > 0 {
                        // 左から右にスワイプ
                        selectedTab -= 1
                    }
                }
            )
        }
        // Navigation Bar
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
                    isDetailPagePresented = true
                })
            }
            )
        }
        .toolbarTitleDisplayMode(.automatic)
        .sheet(isPresented: $isDetailPagePresented) {
            ImageDetailsView()
        }
    }
}

#Preview {
    ImagesView()
        .environmentObject(GetImageViewModel())
}
