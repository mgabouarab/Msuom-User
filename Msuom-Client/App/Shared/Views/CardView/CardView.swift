//
//  CardView.swift
//  Msuom
//
//  Created by MGAbouarab on 02/11/2022.
//

import UIKit

class CardView: UIView {
    
    //MARK: - Proprites -
    private let cornerRadius: CGFloat = 12
    
    //MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInitialDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupInitialDesign()
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.layer.cornerRadius = cornerRadius
//        self.addShadow()
        self.clipsToBounds = true
    }
    
}
