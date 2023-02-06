//
//  AppButton.swift
//  Msuom
//
//  Created by MGAbouarab on 22/10/2022.
//

import UIKit

class AppButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = Theme.colors.mainColor
        self.setTitleColor(Theme.colors.whiteColor, for: .normal)
    }
    
    
}
