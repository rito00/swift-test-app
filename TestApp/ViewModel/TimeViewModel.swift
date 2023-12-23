import SwiftUI
import Foundation
import Combine

class TimeViewModel: ObservableObject {
    @Published var currentTime = ""
    @Published var timeSelection = (hours: 0, minutes: 0, seconds: 0)
    @Published var remainingTimeInSeconds = 0
    var timer: Timer?
    
    var totalTimeSeconds: Int {
        return timeSelection.hours * 3600 + timeSelection.minutes * 60 + timeSelection.seconds
    }
    
    var remainingTimeFormatted: String {
        let hours = remainingTimeInSeconds / 3600
        let minutes = (remainingTimeInSeconds % 3600) / 60
        let seconds = remainingTimeInSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    init() {
        updateTime()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }

    func clearTimeSelection() {
        self.timeSelection = (0, 0, 0)
    }
    
    func clearTimer() {
        timer?.invalidate()
        clearTimeSelection()
        remainingTimeInSeconds = 0
    }
    
    func startTimer() {
        scheduleNotification()
        // 既存タイマー無効
        self.timer?.invalidate()
        self.remainingTimeInSeconds = self.totalTimeSeconds
        print("total time seconds \(totalTimeSeconds)")
        // カウントダウンタイマーセット
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTimeInSeconds > 0 {
                self.remainingTimeInSeconds -= 1
            } else {
                self.timer?.invalidate()
            }
        }
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        self.currentTime = formatter.string(from: Date())
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Scheduled Alert"
        content.body = "Your timer is up!"
        content.sound = UNNotificationSound.default
        
        // トリガーの設定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalTimeSeconds), repeats: false)
        
        // 通知リクエストの作成
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 通知センターにリクエストを追加
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュールに失敗しました: \(error)")
            }
        }
    }
}
