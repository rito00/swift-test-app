//
//  TestAppApp.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/12.
//

import UIKit
import SwiftUI
import Combine

@main
struct Main: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
//        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState())
                .environmentObject(GetImageViewModel())
        }
    }
}

class AppState: ObservableObject {
    @Published var count: Int = 0
    @Published var selectedOption: Int = 0
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var getImageViewModel: GetImageViewModel
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView()) {
                    Text("Counter")
                        .padding()
                }
                NavigationLink(destination: GetImageView()) {
                    Text("Images")
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
                NavigationLink(destination: TimeView()){
                    Text("Time")
                        .padding()
                }
            }
            Text("count \(appState.count)")
                .padding()
            
        }
        .navigationBarTitle("メイン")
    }
    
}

func openAppSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    
    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
}


#Preview {
    ContentView()
        .environmentObject(AppState())
}
