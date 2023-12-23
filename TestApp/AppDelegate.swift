//
//  AppDelegate.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/23.
//

import Foundation
import UIKit

class AppDelegate:NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("許可されました！")
            }else{
                print("拒否されました...")
            }
        }
        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([[.banner, .list, .sound]])
    }
}
