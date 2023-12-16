//
//  NewPageView.swift
//  Test App
//
//  Created by 伊藤陸斗 on 2023/12/09.
//

import SwiftUI

struct CounterView: View {
    @EnvironmentObject var appState: AppState
    @State private var isEven = true
    
    var body: some View {
        NavigationView {
            VStack{
                Text("カウンター値: \(appState.count)")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Button(action: {
                        print(appState.count)
                        appState.count -= 1
                        if appState.count % 2 == 0 {
                            self.isEven = true
                        }
                        else {
                            self.isEven = false
                        }
                    }) {
                        Text("-")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    
                    // カウンターを増やすボタン
                    Button(action: {
                        appState.count += 1
                        if appState.count % 2 == 0 {
                            self.isEven = true
                        }
                        else {
                            self.isEven = false
                        }
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                // その他のUIコンポーネント
                Section(header: Text("設定")) {
                    Slider(value: Binding(
                        get: {
                            Double(appState.count)
                        },
                        set: {
                            appState.count = Int($0)
                        }
                    ), in: 0...100)
                    .padding()
                    
                    Toggle(isOn: $isEven) {
                        Text(isEven ? "偶数" : "奇数")
                    }
                    .padding()
                    .onChange(of: isEven) { oldValue, newValue in
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarTitle("カウンターアプリ", displayMode: .inline)
    }
}

#Preview {
    CounterView()
        .environmentObject(AppState())
}
