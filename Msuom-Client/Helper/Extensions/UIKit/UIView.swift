//
//  UIView.swift
//  Msuom
//
//  Created by MGAbouarab on 19/10/2022.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
extension UIView {
    func addShadow() {
        layer.shadowColor = Theme.colors.shadowColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

    }
    func addBorder(with color: CGColor = Theme.colors.borderColor) {
        layer.borderColor = color
        layer.borderWidth = 1
    }
}

