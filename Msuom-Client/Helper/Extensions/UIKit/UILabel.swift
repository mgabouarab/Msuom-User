//
//  UILabel.swift
//
//  Created by MGAbouarab®
//

import UIKit


extension UILabel {
    func setPrices(mainPrice: String?, offerPrice: String?) {
        guard let mainPrice = mainPrice, !mainPrice.isEmpty, mainPrice.toDouble() ?? 0 > 0 else {
            self.text = nil
            return
        }
        guard let offerPrice = offerPrice, !offerPrice.isEmpty, offerPrice.toDouble() ?? 0 > 0 else {
            self.text = mainPrice.toPrice()
            return
        }
        guard mainPrice != offerPrice else {
            self.text = mainPrice.toPrice()
            return
        }
        let oldPrice = mainPrice.toPrice()
        let newPrice = offerPrice.toPrice()
        
        self.attributedText = (oldPrice + " " + newPrice).addStrikethrough(string: oldPrice, fontColor: .red, lineColor: .black)
    }
}

