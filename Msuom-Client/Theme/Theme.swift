//
//  Theme.swift
//
//  Created by MGAbouarab®
//

import UIKit

final class Theme {
    
    //MARK: - Enum -
    enum Style: String, Codable, CaseIterable {
        case light
        case dark
        case systemStyle
    }
    
    
    //MARK: - Initializer -
    private init() {}
    
    //MARK: - Static Properties -
    static let current: Theme = Theme()
    static let colors: AppColors = AppColors.shared
    static let constants: ViewConstants = ViewConstants.shared
    
    //MARK: - Properties -
    private let fontName = FontFamilyName.cairo.rawValue
    var style: Theme.Style {
        get {
            return UserDefaults.themeStyle
        }
        set {
            self.setTheme(style: newValue)
        }
    }
    
    //MARK: - Private Methods -
    private func setTheme(style: Theme.Style) {
        
        UserDefaults.themeStyle = style
        
        switch style {
        case .light:
            self.animateToStyle(.light)
        case .dark:
            self.animateToStyle(.dark)
        case .systemStyle:
            self.animateToStyle(.unspecified)
        }
        
    }
    private func animateToStyle(_ style: UIUserInterfaceStyle) {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        UIView.animate(withDuration: Theme.constants.smallAnimationTime, delay: 0) {
            window.overrideUserInterfaceStyle = style
        }
    }
    
    //MARK: -
    func setupFont() {
        UILabel.appearance().substituteFontName = fontName
        UITextView.appearance().substituteFontName = fontName
        UITextField.appearance().substituteFontName = fontName
    }
    
}
