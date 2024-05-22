//
//  SellIndicatorDetailsTableViewCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 14/05/2024.
//

import UIKit

class SellIndicatorDetailsTableViewCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var coloredView: UIView!
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    //MARK: - Data -
    func set(data: AuctionRateInfo) {
        self.titleLabel.text = data.title
        self.nameLabel.text = data.description
        self.coloredView.backgroundColor = UIColor(hex: data.color)
    }
    
}
