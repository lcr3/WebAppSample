//
//  DebugApp.swift
//  Debug
//
//  Created by lcr on 2021/12/20.
//

import Firebase
import FirebaseMessaging
import ScreenCoordinator
import SwiftUI
import TopPageFeature
import UserNotifications

@main
struct WebAppSample: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            TopPageView(
                defaultUrl: "https://www.google.co.jp/",
                deepLinkIdentifier: "lcrdev://"
            )
        }
    }
}

// MARK: - AppDelegate Main

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
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

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // トークンの登録に失敗
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // トークンの登録に成功
        var readableToken = ""
        for i in 0 ..< deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("Received an APNs device token: \(readableToken)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
    }
}

// MARK: - AppDelegate Push Notification

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo["gcm.message_id"] {
            print("MessageID: \(messageID)")
        }
        print(userInfo)
        completionHandler(.newData)
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // アプリがForeground時にPush通知を受信したとき
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.banner, .list, .sound]])
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let reciveContent = ReceiveContent(userInfo: userInfo)
        guard let urlString = reciveContent.url, let url = URL(string: urlString) else {
            print("えらーーーーーー")
            completionHandler()
            return
        }
        UIApplication.shared.open(url)
        completionHandler()
    }
}
