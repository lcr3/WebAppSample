//
//  DebugApp.swift
//  Debug
//
//  Created by lcr on 2021/12/20.
//

import SwiftUI
import TopPageFeature
import UserNotifications
import Firebase
import FirebaseMessaging

@main
struct WebAppSample: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            TopPageView(url: "https://apple.com")
        }
    }
}

// MARK: - AppDelegate Main
class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      FirebaseApp.configure()
      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().delegate = self

      // Push通知許可のポップアップを表示
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
         guard granted else { return }
         DispatchQueue.main.async {
            application.registerForRemoteNotifications()
         }
      }
      return true
   }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmtoken:\(fcmToken)")
    }
}

// MARK: - AppDelegate Push Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       if let messageID = userInfo["gcm.message_id"] {
          print("MessageID: \(messageID)")
       }
       print(userInfo)
       completionHandler(.newData)
   }

   // アプリがForeground時にPush通知を受信する処理
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       print("recive push on forground")
      completionHandler([.banner, .sound])
   }
}
