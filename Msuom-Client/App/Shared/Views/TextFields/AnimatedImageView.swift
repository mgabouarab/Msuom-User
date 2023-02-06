//
//  AnimatedImageView.swift
//  Shop Zone
//
//  Created by MGAboarab on 06/06/2022.
//

import UIKit


class AnimatedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
            self.transform = .identity
        }

    }
}
