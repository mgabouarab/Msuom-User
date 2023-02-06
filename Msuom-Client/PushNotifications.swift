//
//  PushNotifications.swift
//
//  Created by MGAbouarab®
//

import UIKit
import Firebase

enum NotificationType: String, Codable {
    case userDeleted = "user_deleted"
    case block
    case adminNotify = "admin_notify"
}
enum FCMValueKeys: String {
    case type
}


extension AppDelegate : MessagingDelegate{
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "No Device token found")")
        UserDefaults.pushNotificationToken = fcmToken ?? "No Token Found"
    }
}
extension AppDelegate : UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
    
    //MARK: - Handel the arrived Notifications
    
    //Use this method to process incoming remote notifications for your app
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //when the notification arrives and the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("Notification info is: \n\(userInfo)")
        
        
        guard let targetValue = userInfo[AnyHashable(FCMValueKeys.type.rawValue)] as? String else {return}
        
        switch targetValue {
            
        case NotificationType.userDeleted.rawValue, NotificationType.block.rawValue:
            self.blockUser()
            
        default:
            let rootVC = (UIApplication.shared.windows.first?.rootViewController as? UITabBarController)
            rootVC?.viewControllers?[1/*Index Of Notification Tab in tabbar*/].tabBarItem.badgeValue = String((rootVC?.viewControllers?[1/*Index Of Notification Tab in tabbar*/].tabBarItem.badgeValue?.toInt() ?? 0) + 1)
        }
        
        completionHandler([.list, .banner,.sound])
    }
    
    // when the user tap on the notification banar
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let targetValue = userInfo[AnyHashable(FCMValueKeys.type.rawValue)] as? String
        
        
        switch targetValue {
            
        case NotificationType.userDeleted.rawValue, NotificationType.block.rawValue:
            self.blockUser()
            
        default:
            guard UserDefaults.isLogin else {return}
            self.setNotificationTab()
        }
        
    }
    
    private func blockUser() {
        UserDefaults.isLogin = false
        UserDefaults.accessToken = nil
        UserDefaults.user = nil
        let vc = SplashVC.create()
        AppHelper.changeWindowRoot(vc: vc, options: .transitionCurlDown)
    }
    
    private func setNotificationTab() {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let window = window, let _ = window.rootViewController as? AppTabBarController  {
            (window.rootViewController as? AppTabBarController)?.selectedIndex = 1/*Index Of Notification Tab in tab-bar*/
        }
    }
    
}

