//
//  AppDelegate.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import Foundation
import UIKit


class AppDelegate:NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // NotificationDelegateクラスのインスタンス生成
    let notificationDelegate = NotificationDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //UNUserNotificationCenterのデリゲートにnotificationDelegateを設定
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
        let center = UNUserNotificationCenter.current()
        
        // 通知処理部
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // まだユーザーに許可を求めていない場合
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("通知の許可が得られました。")
                    } else if let error = error {
                        print("通知の許可が得られませんでした: \(error)")
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    openAppSettings()
                }
            default:
                print("通知の許可が存在するようです。")
                break
            }
        }
        return true
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // フォアグラウンドでの通知表示オプション
        completionHandler([.banner, .sound])
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
