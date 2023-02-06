//
//  Language.swift
//
//  Created by MGAbouarab®

import UIKit

struct Language {
    
    enum Languages {
        static let en = "en"
        static let ar = "ar"
    }
    
    static func currentLanguage() -> String {
        let languages = UserDefaults.standard.object(forKey: "AppleLanguages") as! NSArray
        let firstLanguage = languages.firstObject as! String
        return firstLanguage
    }
    static func setAppLanguage(lang: String) {
        UserDefaults.standard.set([lang, currentLanguage()], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Language.handleViewDirection()
    }
    
    static func apiLanguage() -> String {
        return self.currentLanguage().contains(Languages.ar) ? Languages.ar : Languages.en
    }
    static func isRTL() -> Bool {
        return self.currentLanguage().contains(Languages.ar) ? true : false
    }
    
    static func handleViewDirection() {
        UIPageControl.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
        UIStackView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
        UISwitch.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
        UICollectionView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().textAlignment = isRTL() ? .right : .left
        UILabel.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
        UITextView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
        UITextField.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    }
    
}
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var payLocalized: String {
        return NSLocalizedString(self, tableName: "PayLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
    var validationLocalized: String {
        return NSLocalizedString(self, tableName: "ValidationLocalized", bundle: Bundle.main, value: "", comment: "")
    }
    var helperLocalizable: String {
        return NSLocalizedString(self, tableName: "HelperLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
    var coreLocalizable: String {
        return NSLocalizedString(self, tableName: "CoreLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
}
