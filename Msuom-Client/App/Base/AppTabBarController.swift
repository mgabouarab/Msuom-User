//
//  AppTabBarController.swift
//
//  Created by MGAbouarab®
//

import UIKit

class AppTabBarController: UITabBarController {
    
    
    //MARK: - Properties -
    
    
    //MARK: - LifeCycle -
    override func loadView() {
        super.loadView()
        let customTabBar = CurvedTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
        self.tabBar.isTranslucent = true
        
        self.tabBar.backgroundColor = .clear
    }
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
        self.addMiddleButton()
        self.addMiddleImage()
        self.addObservers()
    }
    private func addChilds() {
        self.viewControllers = UserDefaults.isLogin ? [
            home(),
            auctions(),
            BaseVC(),
            orders(),
            more()
        ] : [
            home(),
            BaseVC(),
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
        let actionButton = TabBarButton()
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
        let length: CGFloat = 60
        let imageView = TabBarImageView()
        imageView.image = UIImage(named: "tab2")
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.shadowColor = Theme.colors.shadowColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 10
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.tabBar.addSubview(imageView)
        self.tabBar.bringSubviewToFront(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: length).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: length).isActive = true
        imageView.layer.cornerRadius = length / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.middleButtonAction))
        imageView.addGestureRecognizer(tap)
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
    
    
    
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateChildrenDependingOnUserLoginStatus), name: .isLoginChanged, object: nil)
    }
    @objc private func updateChildrenDependingOnUserLoginStatus() {
        if UserDefaults.isLogin {
            self.viewControllers?.insert(auctions(), at: 1)
            self.viewControllers?.insert(orders(), at: 3)
        } else {
            guard viewControllers?.count ?? 0 > 3 else {return}
            self.viewControllers?.remove(at: 3)
            self.viewControllers?.remove(at: 1)
        }
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


class CurvedTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.lightGray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 1.5), y: 0)) // the beginning of the trough
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 30, y: height))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height * 1.5), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 30, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            if let _ = member as? TabBarImageView, member.frame.contains(point) {
                return member
            }
            
            
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return super.hitTest(point, with: event)
    }

}

class TabBarButton: UIButton {
    
}
class TabBarImageView: UIImageView {
    
}
