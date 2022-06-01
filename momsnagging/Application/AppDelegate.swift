//
//  AppDelegate.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit
import Firebase
import RxKakaoSDKCommon
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        registerRemoteNotification()
        Messaging.messaging().delegate = self
        
        // Use Kakao SDK
        RxKakaoSDK.initSDK(appKey: ApiList.getKakaoNativeAppKey())
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        return false
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - FCM Setting
    
    private func registerRemoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { granted, _ in
            // 1. APNs에 device token 등록 요청
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
    }
    
    /// APNs에서 `device token 등록 요청`에 관한 응답이 온 경우, Provider Server인 Firebase에 등록
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        // FCM 토큰 정보
        if let fcmToken = Messaging.messaging().fcmToken {
            Log.debug("FCM device token: \(fcmToken)")
        }
    }

}
// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
    }
}

// MARK: - UNUserNotificationCenterDelegate
@available(iOS 14.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        // Process notification content
        print("\(content.userInfo)")
        completionHandler([.banner, .list, .sound]) // Display notification Banner
    }
}
 
// MARK: - 220530 추가
//extension AppDelegate {
//
//    // [START receive_message]
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        if let messageID = userInfo[gcmMessageIDKey] {
//            Log.debug("FCM Message ID: \(messageID)")
//        }
//    }
//    // 앱 켜진상태에서 푸시 알림을 받았을 때.
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // 구글 message ID 정보
//        if let messageID = userInfo[gcmMessageIDKey] {
//            Log.debug("FCM Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        Log.debug("FCM userInfo : \(userInfo)")
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//}
