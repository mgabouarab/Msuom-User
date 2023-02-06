//
//  SegmentedCollectionCell.swift
//  LocationClient
//
//  Created by MGAbouarab on 23/09/2022.
//

import UIKit

class SegmentedCollectionCell: UICollectionViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var lineView: UIView!
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.nameLabel.attributedText = nil
        self.contentView.clipsToBounds = true
    }
    
    //MARK: - Design -
    func setup(name: String, isSelected: Bool, with selectedColor: UIColor = Theme.colors.mainColor, and unselectedColor: UIColor = Theme.colors.mainDarkFontColor) {
        
        self.nameLabel.text = name
        self.contentView.backgroundColor =  isSelected ? selectedColor : .clear
        self.nameLabel.textColor = isSelected ? Theme.colors.whiteColor : Theme.colors.mainDarkFontColor
        self.lineView.isHidden = true//!isSelected
        self.contentView.layer.cornerRadius = 8
    }

}
