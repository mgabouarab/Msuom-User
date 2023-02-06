//
//  UnderLineButton.swift
//  Msuom
//
//  Created by MGAbouarab on 25/10/2022.
//

import UIKit

class UnderLinedButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        let title = (self.currentTitle ?? "").localized
        let attributedString = title.changeWithUnderLine(strings: [title], with: Theme.colors.mainColor)
        self.setAttributedTitle(attributedString, for: .normal)
        self.setAttributedTitle(attributedString, for: .selected)
    }
    
    
}

