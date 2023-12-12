//
//  TestAppApp.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/12.
//

import SwiftUI

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState())
        }
    }
}
