//
//  MainAppButton.swift
//
//  Created by MGAbouarab®.
//

import UIKit


class MainAppButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = Theme.colors.mainColor
        self.setTitleColor(Theme.colors.whiteColor, for: .normal)
    }
}
class SubMainAppButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = Theme.colors.secondaryColor
        self.setTitleColor(Theme.colors.whiteColor, for: .normal)
    }
}
class SecondaryAppButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = Theme.colors.mainDarkFontColor.withAlphaComponent(0.2)
        self.setTitleColor(Theme.colors.mainDarkFontColor, for: .normal)
    }
}
