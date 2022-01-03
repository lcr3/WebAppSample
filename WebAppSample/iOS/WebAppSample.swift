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
            TopPageView(defaultUrl:"https://www.google.co.jp/")
        }
    }
}

// MARK: - AppDelegate Main
class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      FirebaseApp.configure()
      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().delegate = self

      // Push通知許可のポップアップを表示
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
         guard granted else {
             return
         }
         DispatchQueue.main.async {
            application.registerForRemoteNotifications()
         }
      }
      return true
   }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var readableToken: String = ""
        for i in 0..<deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("Received an APNs device token: \(readableToken)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
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
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.banner, .list, .sound]])
   }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // 以下の用にしてnotification centerを使って通知し、
        // view側では以下のメソッドを使って、処理を続行します。
        // onReceive(NotificationCenter.default.publisher(for: Notification.Name("didReceiveRemoteNotification")))
//        NotificationCenter.default.post(
//            name: Notification.Name("didReceiveRemoteNotification"),
//            object: nil,
//            userInfo: userInfo
//        )
        print(userInfo)
        completionHandler()
    }
}
