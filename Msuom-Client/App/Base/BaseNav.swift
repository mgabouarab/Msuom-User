//
//  BaseNav.swift
//
//  Created by MGAbouarab®
//

import UIKit

class BaseNav: UINavigationController {
    
    //MARK: - Properties -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    var appearanceBackgroundColor: UIColor { .white }
    var appearanceTintColor: UIColor { Theme.colors.mainDarkFontColor }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGesture()
        self.handleAppearance()
        
    }
    
    //MARK: - Design -
    private func handleAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: appearanceTintColor, .font: UIFont.boldSystemFont(ofSize: 17)]
        self.navigationBar.tintColor = appearanceTintColor
        appearance.backgroundColor = appearanceBackgroundColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    private func setupGesture() {
        interactivePopGestureRecognizer?.delegate = self
        self.view.semanticContentAttribute = Language.isRTL() ? .forceRightToLeft : .forceLeftToRight
    }
    
}
extension BaseNav: UIGestureRecognizerDelegate {}
extension UINavigationController {
    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}

class AuthNav: BaseNav {
    
}

class ColoredNav: BaseNav {
    
    //MARK: - Properties -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var appearanceBackgroundColor: UIColor { Theme.colors.mainColor }
    override var appearanceTintColor: UIColor { Theme.colors.whiteColor }
    
    
    
}
