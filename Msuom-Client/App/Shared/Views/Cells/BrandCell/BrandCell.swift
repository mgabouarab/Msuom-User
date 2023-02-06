//
//  BrandCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 30/01/2023.
//

import UIKit

class BrandCell: UICollectionViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    //MARK: - Properties -
    
    
    //MARK: - LifeCycle -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.containerView.layer.cornerRadius = 12
        self.containerView.clipsToBounds = true
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = Theme.colors.borderColor
    }
    func setup(image: String?, name: String?, isSelected: Bool?) {
        self.imageView.setWith(string: image)
        self.nameLabel.text = name
        if isSelected == true {
            self.containerView.addBorder(with: Theme.colors.mainColor.cgColor)
        } else {
            self.containerView.addBorder(with: Theme.colors.borderColor)
        }
    }
    func hideName(_ isDisable: Bool) {
        self.nameLabel.isHidden = isDisable
    }

}
