//
//  SelectImageCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 25/05/2023.
//

import UIKit

class SelectImageCell: UICollectionViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var deleteButton: UIButton!

    //MARK: - properties -
    var deleteAction: (()->())?
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.imageView.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    func setImage(_ imageModel: SelectImageView.ImageModel) {
        self.imageView.image = nil
        if let data = imageModel.data {
            self.imageView.image = UIImage(data: data)
        } else if let url = imageModel.url {
            self.imageView.setWith(string: url)
        }
    }
    
    //MARK: - IBAction -
    @IBAction private func deleteButtonPressed() {
        self.deleteAction?()
    }

}

extension SelectImageCell {
    func enableDelete(_ isEnabled: Bool) {
        self.deleteButton.isHidden = !isEnabled
    }
}
