//
//  ScrollView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/13.
//

import Foundation
import SwiftUI



struct CustomScrollView: View {
    
    /// 表示データ
    @State var dataList: [Int] = [Int](1...20)

    var body: some View {
         ScrollView {
             LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                 
                 Section(footer: ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 150)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dataList.append(contentsOf: [Int](dataList.count + 1...dataList.count + 20))
                        }
                    }
                 ) {
                     ForEach(dataList, id: \.self) { data in
                         Text(data.description)
                             .frame(width: 150, height: 150)
                             .background(Color.green)
                     }
                 }
             }
         }
    }
}

