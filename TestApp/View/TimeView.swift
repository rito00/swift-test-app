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
    @State private var timer: Timer?
    
    @State private var showingAlert: Bool = false
    
    var body: some View {
        Text(viewModel.currentTime)
            .font(.largeTitle)
            .padding()
        Section("通知"){
            Text("Select Time")
                .font(.headline)
            
            HStack {
                timePickerView(title: "時間", range: 0..<24, selection: $hours)
                timePickerView(title: "分", range: 0..<60, selection: $minutes)
                timePickerView(title: "秒", range: 0..<60, selection: $seconds)
            }
            
            HStack {
                Button(action: {
                    
                }) {
                    Text("キャンセル")
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    print("\(selectedTime)")
                    startTimer(hours: hours, minutes: minutes, seconds: seconds)
                }) {
                    Text("開始")
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .clipShape(Circle())
                }
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
        
        func scheduleNotification(hours: Int, minutes: Int, seconds: Int) {
            requestNotificationPermission()
            let content = UNMutableNotificationContent()
            content.title = "Scheduled Alert"
            content.body = "Your timer is up!"
            content.sound = UNNotificationSound.default
            
            // 総秒数を計算
            let totalSeconds = hours * 3600 + minutes * 60 + seconds
            print("total seconds \(totalSeconds)")
            
            // トリガーの設定
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalSeconds), repeats: false)
            
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
    
    // アプリ起動時に呼び出す
    private func requestNotificationPermission() {
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
    
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    TimeView()
}
