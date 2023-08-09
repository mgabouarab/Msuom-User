//
//  AuctionAdvantagesCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class AuctionAdvantagesCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var expandableDetailsView: ExpandableDetailsView!

    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    //MARK: - Design -
    func setup(advantages: Advantages) {
        self.expandableDetailsView.set(title: advantages.title, description: advantages.description, image: advantages.image, isSelected: advantages.isSelected)
    }
    
}
