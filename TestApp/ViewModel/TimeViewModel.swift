//
//  TimeViewModel.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import Foundation
import Combine

class TimeViewModel: ObservableObject {
    @Published var currentTime = ""
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        self.currentTime = formatter.string(from: Date())
    }
}
