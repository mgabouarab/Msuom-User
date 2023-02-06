//
//  Extensions+UITextView.swift
//
//  Created by MGAbouarab®
//

import UIKit

//MARK:- Localization
extension UITextView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if Language.isRTL() {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        } else {
            if textAlignment == .natural {
                self.textAlignment = .left
            }
        }
    }
}

