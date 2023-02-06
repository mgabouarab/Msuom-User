//
//  UITextField.swift
//  Msuom
//
//  Created by MGAbouarab on 19/10/2022.
//

import UIKit

extension UITextField {
    var textValue: String? {
        guard let word = text?.trimWhiteSpace(), !word.isEmpty else {
            return nil
        }
        return word
    }
}

extension UITextView {
    var textValue: String? {
        guard let word = text?.trimWhiteSpace(), !word.isEmpty else {
            return nil
        }
        return word
    }
}

