//
//  AppTabBarController.swift
//
//  Created by MGAbouarab®
//

import UIKit

class AppTabBarController: UITabBarController {
    
    
    //MARK: - Properties -
    
    
    //MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.initialView()
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        /// To Animate tabBar item
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }

        let timeInterval: TimeInterval = 0.4
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
    open override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    //MARK: - Initial -
    static func create() -> AppTabBarController {
        let vc = AppTabBarController()
        return vc
    }
    
    //MARK: - Design -
    private func initialView(){
        self.setupDesign()
        self.addChilds()
        self.addMiddleImage()
        self.addMiddleButton()
    }
    private func addChilds() {
        self.viewControllers = [
            home(),
            auctions(),
            BaseVC(),
            orders(),
            more()
        ]
    }
    private func setupDesign() {
        
        
        let tabBarAppearance = UITabBarItem.appearance()
        UITabBar.appearance().tintColor = Theme.colors.mainColor
        self.tabBar.backgroundColor = .clear
        let attribute = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)]
        tabBarAppearance.setBadgeTextAttributes(attribute as [NSAttributedString.Key : Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attribute as [NSAttributedString.Key : Any], for: .normal)
        
        
        if #available(iOS 15.0, *) {
            
            let tabFont =  UIFont.systemFont(ofSize: 12)
            
            let appearance = UITabBarAppearance()
            
            
            let selectedAttributes: [NSAttributedString.Key: Any]
            = [NSAttributedString.Key.font: tabFont]
            
            let normalAttributes: [NSAttributedString.Key: Any]
            = [NSAttributedString.Key.font: tabFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
            
        }
        
        
        
        
    }
    

    //MARK: - Tabbar VCs -
    func home() -> UINavigationController {
        let vc = HomeVC.create()
        vc.tabBarItem = UITabBarItem(title: "Home".localized, image: UIImage(named: "home"), tag: 0)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        return ColoredNav(rootViewController: vc)
    }
    func auctions() -> UINavigationController {
        let vc = AuctionsVC.create()
        vc.tabBarItem = UITabBarItem(title: "Auctions".localized, image: UIImage(named: "hammer"), tag: 1)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        return ColoredNav(rootViewController: vc)
    }
    func orders() -> UINavigationController {
        let vc = OrdersVC.create()
        vc.tabBarItem = UITabBarItem(title: "My Orders".localized, image: UIImage(named: "myOrders"), tag: 2)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        return ColoredNav(rootViewController: vc)
    }
    func more() -> UINavigationController {
        let vc = MoreVC.create()
        vc.tabBarItem = UITabBarItem(title: "More".localized, image: UIImage(named: "more"), tag: 3)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        return ColoredNav(rootViewController: vc)
    }
    
    ///This is used if you need to implement Middle button to the tabBar
    func middelVC() -> UIViewController {
        let vc = AddCarVC.create()
        let nav = BaseNav(rootViewController: vc)
        return nav
    }
    
    
    //MARK: - Middle Button -
    func addMiddleButton(){
        let actionButton = UIButton()
        let unSelectedImage = UIImage()
        let selectedImage = UIImage()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(unSelectedImage, for: .normal)
        actionButton.setImage(selectedImage, for: .selected)

        self.tabBar.addSubview(actionButton)
        self.tabBar.bringSubviewToFront(actionButton)
        
        actionButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: self.tabBar.centerYAnchor).isActive = true
        actionButton.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: self.tabBar.bounds.width / CGFloat(self.viewControllers?.count ?? 1)).isActive = true

        actionButton.isEnabled = true
        actionButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
    }
    func addMiddleImage(){
        let length: CGFloat = 64
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tab2")
        imageView.contentMode = .scaleAspectFill
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.tabBar.addSubview(imageView)
        self.tabBar.bringSubviewToFront(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: length).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: length).isActive = true
        imageView.layer.cornerRadius = length / 2
        
        
    }
    @objc private func middleButtonAction() {
        guard UserDefaults.isLogin else {
            AppAlert.showLogoutAlert {
                let vc = LoginVC.create()
                let nav = AuthNav(rootViewController: vc)
                self.present(nav, animated: true)
            }
            return
        }
        self.present(self.middelVC(), animated: true, completion: nil)
    }
    
}
extension AppTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let _ = viewControllers else { return false }
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        guard fromView != toView else {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        return true
    }
}
