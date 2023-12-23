//
//  TimeView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import SwiftUI

struct TimeView: View {
    @StateObject var viewModel = TimeViewModel()
    @State private var selectedTime = Date()
    
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var remainingTimeInSeconds = 0
    @State private var timer: Timer?
    @State private var showingAlert: Bool = false
    
    private var totalTimeSeconds: Int {
        return hours * 3600 + minutes * 60 + seconds
    }
    
    private var remainingTimeFormatted: String {
        let hours = remainingTimeInSeconds / 3600
        let minutes = (remainingTimeInSeconds % 3600) / 60
        let seconds = remainingTimeInSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        Text(viewModel.currentTime)
            .font(.largeTitle)
            .bold()
            .padding()
        
        Section("通知"){
            // カウントダウン表示
            Text("\(remainingTimeFormatted)")
                .font(.largeTitle)
            
            HStack {
                timePickerView(title: "時間", range: 0..<24, selection: $hours)
                timePickerView(title: "分", range: 0..<60, selection: $minutes)
                timePickerView(title: "秒", range: 0..<60, selection: $seconds)
            }
            .frame(height: 150)
        
            
            HStack {
                Button(action: {
                    self.clearTimer()
                }) {
                    Text("キャンセル")
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .background(totalTimeSeconds == 0 ? Color.gray : Color.red)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    startTimer(hours: hours, minutes: minutes, seconds: seconds)
                }) {
                    Text("開始")
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                        .brightness(0.7)
                        .background(totalTimeSeconds == 0 ? .green : .green)
                        .brightness(totalTimeSeconds == 0 ? -0.6 : 0)
                        .clipShape(Circle())
                }
                .disabled(totalTimeSeconds == 0)
            }
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("通知許可が必要"),
                message: Text("通知を有効にするためには、設定で許可してください。"),
                primaryButton: .default(Text("設定を開く"), action: openAppSettings),
                secondaryButton: .cancel()
            )
        }
    }
    
    private func timePickerView(title: String, range: Range<Int>, selection: Binding<Int>) -> some View {
        HStack {
            Picker(title, selection: selection) {
                ForEach(range, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .clipped()
            Text(title)
                .font(.headline)
            
        }
        .padding()
    }
    
    private func startTimer(hours: Int, minutes: Int, seconds: Int) {
        // 既存タイマー無効
        self.timer?.invalidate()
        self.remainingTimeInSeconds = self.totalTimeSeconds
        // カウントダウンタイマーセット
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTimeInSeconds > 0 {
                self.remainingTimeInSeconds -= 1
            } else {
                self.timer?.invalidate()
            }
        }
        
        // 通知処理部
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // まだユーザーに許可を求めていない場合
                requestNotificationPermission()
            case .authorized:
                // 通知が許可されている場合
                scheduleNotification(hours: hours, minutes: minutes, seconds: seconds)
            case .denied:
                // 通知が拒否されている場合
                showingAlert = true
            default:
                break
            }
        }
    }
    
    private func clearTimer() {
        self.timer?.invalidate()
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
        self.remainingTimeInSeconds = 0
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("通知の許可が得られました。")
                showingAlert = false
            } else if let error = error {
                print("通知の許可が得られませんでした: \(error)")
                showingAlert = true
            }
        }
    }
    
    func scheduleNotification(hours: Int, minutes: Int, seconds: Int) {
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

#Preview {
    TimeView()
}
