//
//  AuctionBidsCollectionCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 06/08/2023.
//

import UIKit

class AuctionBidsCollectionCell: UICollectionViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func set(image: String?, name: String?, date: String?) {
        self.imageView.setWith(string: image)
        self.nameLabel.text = name
        self.dateLabel.text = date
    }
    
}
