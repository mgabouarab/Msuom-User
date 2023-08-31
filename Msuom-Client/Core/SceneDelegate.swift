//
//  SceneDelegate.swift
//
//  Created by MGAbouarab®
//

import UIKit
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        Theme.current.style = .light
        NotificationCenter.default.post(name: .didEnterBackground, object: nil)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            print("Incoming url is: \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
                guard error == nil else {
                    print("Error occur when handle dynamic link \(incomingURL) and the error is \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink)
                }
            }
            if linkHandled {
                
            } else {
                print("Dynamic link can not be handled")
            }
        }
    }
    
    private func handleDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("Dynamic link dose not have any url")
            return
        }
        print("Your Incoming url is \(url.absoluteString)")
        
        let absoluteString = url.absoluteString.replacingOccurrences(of: "https://maseom.page.link/", with: "")
        let parameters = absoluteString.components(separatedBy: "/")
        
        guard let id = parameters.last else {return}
        
        var vc: UIViewController = UIViewController()
        
        if parameters.contains("auction") {
            vc = AuctionDetailsVC.create(id: id)
        } else if parameters.contains("advertise") {
            vc = CarDetailsVC.create(id: id)
        }
        
        var rootVC = (UIApplication.shared.windows.first?.rootViewController as? UITabBarController)
        if rootVC == nil {
            SplashVC.hasNotification = true
            AppHelper.changeWindowRoot(vc: AppTabBarController.create())
            rootVC = (UIApplication.shared.windows.first?.rootViewController as? UITabBarController)
        }
        rootVC!.viewControllers![rootVC!.selectedIndex].show(vc, sender: nil)
    }
    

}

