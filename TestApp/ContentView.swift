//
//  ContentView.swift
//  Test App
//
//  Created by 伊藤陸斗 on 2023/12/09.
//

import SwiftUI

import Combine

class AppState: ObservableObject {
    @Published var count: Int = 0
    @Published var selectedOption: Int = 0
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView()) {
                    Text("Counter")
                        .padding()
                }
                NavigationLink(destination: GetImageView()) {
                    Text("Get Image")
                        .padding()
                }
                NavigationLink(destination: OptionsView()) {
                    Text("Option")
                        .padding()
                }
                NavigationLink(destination: CustomScrollView()){
                    Text("Custom Scroll")
                        .padding()
                }
                NavigationLink(destination: CameraMainView()){
                    Text("Camera")
                        .padding()
                }
                
                
                
            }
            Text("count \(appState.count)")
                .padding()
            
        }
        .navigationBarTitle("メイン")
    }
    
}


#Preview {
    ContentView()
        .environmentObject(AppState())
}
