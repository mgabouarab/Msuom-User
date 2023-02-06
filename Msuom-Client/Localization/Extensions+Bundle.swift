//
//  Extensions+Bundle.swift
//
//  Created by MGAbouarab®
//

import UIKit

extension Bundle {
    
    static func swizzleLocalization() {
        let originalSelector = #selector(localizedString(forKey:value:table:))
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }

        let mySelector = #selector(myLocalizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }

        if class_addMethod(self, originalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, myMethod)
        }
    }
    @objc private func myLocalizedString(forKey key: String,value: String?, table: String?) -> String {
        DispatchQueue.main.async {
            guard let _ = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
        }
        guard let bundlePath = Bundle.main.path(forResource: Language.currentLanguage(), ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.myLocalizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocalizedString(forKey: key, value: value, table: table)
    }
    
}


