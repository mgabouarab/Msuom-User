//
//  EvaluationViewCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 13/05/2023.
//

import UIKit

class EvaluationViewCell: UICollectionViewCell {

    enum Location {
        case leading
        case middle
        case trailing
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var isSelectedView: UIView!
    @IBOutlet weak private var underlineView: UIView!
    
    //MARK: - Design Methods -
    func setup(data: EvaluationModel) {
        self.label.text = data.degree
        self.label.backgroundColor = data.color
        self.isSelectedView.alpha = data.isSelected ? 1 : 0
    }
    func set(corner location: Location) {
        self.clipsToBounds = true
        switch location {
        case .leading:
            self.label.layer.cornerRadius = 8
            self.label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            self.underlineView.layer.cornerRadius = 1.5
            self.underlineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .middle:
            self.label.layer.cornerRadius = 0
            self.underlineView.layer.cornerRadius = 0
        case .trailing:
            self.label.layer.cornerRadius = 8
            self.label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            self.underlineView.layer.cornerRadius = 1.5
            self.underlineView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }

}
