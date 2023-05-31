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
    case adminNotify = "admin"
    case car
    case order
    case bid
    case dispute
}
enum FCMValueKeys: String {
    case type = "key"
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
            completionHandler([.list, .banner,.sound])
        }
        
        
    }
    
    //when the user tap on the notification banner
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        guard let targetValue = userInfo[AnyHashable(FCMValueKeys.type.rawValue)] as? String else {return}
        guard let notificationType = NotificationType(rawValue: targetValue) else {return}
        
        
        switch notificationType {
        case .userDeleted:
            self.blockUser()
        case .block:
            self.blockUser()
        case .adminNotify:
            self.goToNotificationVC()
        case .car:
            guard let id = userInfo[AnyHashable("carId")] as? String else {
                self.goToNotificationVC()
                return
            }
            let vc = CarDetailsVC.create(id: id)
            self.goTo(vc: vc)
        case .order:
            guard let id = userInfo[AnyHashable("orderId")] as? String else {
                self.goToNotificationVC()
                return
            }
            guard let type = userInfo[AnyHashable("type")] as? String else {
                let vc = NotificationsVC.create()
                self.goTo(vc: vc)
                return
            }
            switch type {
                
                case "purchaseOrder":
                let vc = PurchaseOrderVC.create(data: nil, id: id)
                self.goTo(vc: vc)
                case "evaluation":
                let vc = EvaluationOrderVC.create(data: nil, id: id)
                self.goTo(vc: vc)
                case "shipping":
                let vc = ShippingOrderVC.create(data: nil, id: id)
                self.goTo(vc: vc)
                case "summaryReport":
                let vc = SummaryReportOrderVC.create(data: nil, id: id)
                self.goTo(vc: vc)
                case "afterSaleService":
                let vc = SummaryReportOrderVC.create(data: nil, id: id)
                self.goTo(vc: vc)
                
            default:
                let vc = NotificationsVC.create()
                self.goTo(vc: vc)
            }
        case .bid:
            guard let id = userInfo[AnyHashable("bidId")] as? String else {
                self.goToNotificationVC()
                return
            }
            let vc = AuctionDetailsVC.create(id: id)
            self.goTo(vc: vc)
        case .dispute:
            guard let id = userInfo[AnyHashable("disputeId")] as? String else {
                self.goToNotificationVC()
                return
            }
            let vc = ReportDetailsVC.create(id: id)
            self.goTo(vc: vc)
        }
        
        
    }
    
    private func blockUser() {
        UserDefaults.isLogin = false
        UserDefaults.accessToken = nil
        UserDefaults.user = nil
        let vc = SplashVC.create()
        AppHelper.changeWindowRoot(vc: vc, options: .transitionCurlDown)
    }
    
    private func goToNotificationVC() {
        guard UserDefaults.isLogin else {return}
        let vc = NotificationsVC.create()
        self.goTo(vc: vc)
    }
    
    private func goTo(vc: UIViewController) {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        var rootVC = window?.rootViewController as? UITabBarController
        
        if rootVC == nil {
            SplashVC.hasNotification = true
            AppHelper.changeWindowRoot(vc: AppTabBarController.create())
            rootVC = (UIApplication.shared.windows.first?.rootViewController as? UITabBarController)
        }
        
        if let selectedIndex = rootVC?.selectedIndex {
            rootVC?.viewControllers?[selectedIndex].show(vc, sender: self)
        }
        
    }
    
}

