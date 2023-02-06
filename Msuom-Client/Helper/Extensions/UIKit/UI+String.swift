//
//  UI+String.swift
//
//  Created by MGAbouarab®
//

import UIKit

extension String {
    // Change specific words color in whole text
    func change(strings: [String], with color: UIColor, characterSpacing: UInt? = nil) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        guard let characterSpacing = characterSpacing else {return attributedString}
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    // Change specific words color in whole text
    func changeWithUnderLine(strings: [String], with color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            attributedString.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: range)
        }
        guard let characterSpacing = characterSpacing else {return attributedString}
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    // Add line over the world
    func addStrikethrough(string: String, fontColor: UIColor, lineColor: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: lineColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
        guard let characterSpacing = characterSpacing else {return attributedString}
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    func addUnderLine(string: String, fontColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        return attributedString
    }
    
    func openMail() {
        guard let mailtoString = "mailto:\(self)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let mailtoUrl = URL(string: mailtoString) else { return }
        if UIApplication.shared.canOpenURL(mailtoUrl) {
            UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }
    
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}



