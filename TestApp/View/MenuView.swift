//
//  AudioView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/26.
//

import SwiftUI

struct MenuMainView: View {
    // offset変数でメニューを表示・非表示するためのオフセットを保持します
    @State private var offset = CGFloat.zero
    @State private var closeOffset = CGFloat.zero
    @State private var openOffset = CGFloat.zero
    
    var body: some View {
        // 画面サイズの取得にGeometoryReaderを利用します
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // メインコンテンツ
                VStack () {
                    Spacer()
                    Text("This is main contents")
                        .font(.largeTitle)
                    Spacer()
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                .border(.orange, width: 5)
                
                // スライドメニューがでてきたらメインコンテンツをグレイアウトします
                Color.gray.opacity(
                    Double((self.closeOffset - self.offset)/self.closeOffset) - 0.4
                )
                
                // スライドメニュー
                MenuView()
                    .background(.white)
                    .frame(width: geometry.size.width * 0.7)
                // 最初に画面のオフセットの値をスライドメニュー分マイナスします。
                    .onAppear(perform: {
                        self.offset = geometry.size.width * -1
                        self.closeOffset = self.offset
                        self.openOffset = .zero
                    })
                    .offset(x: self.offset)
                    .animation(.default, value: self.offset)
            }
            .gesture(DragGesture(minimumDistance: 5)
                .onEnded { value in
                    withAnimation {
                        if value.location.x > value.startLocation.x {
                            self.offset = self.openOffset
                        } else {
                            self.offset = self.closeOffset
                        }
                    }
                }
            )
        }
    }
    
    struct MenuView: View {
        
        var body: some View {
            VStack(alignment: .leading) {
                Image("dotty")
                    .resizable()
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                Text("SwiftUI")
                    .font(.largeTitle)
                Text("@swiftui")
                    .font(.caption)
                Divider()
                ScrollView (.vertical, showsIndicators: true) {
                    HStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    HStack {
                        Image(systemName: "list.dash")
                        Text("Lists")
                    }
                    HStack {
                        Image(systemName: "text.bubble")
                        Text("Topics")
                    }
                }
                Divider()
                Text("Settings and privacy")
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(GetImageViewModel())
}
