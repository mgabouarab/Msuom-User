//
//  AuctionCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/11/2022.
//

import UIKit

class AuctionCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var startLabel: UILabel!
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Design -
    func setupInitialDesign() {
        self.selectionStyle = .none
        self.containerView.layer.borderColor = Theme.colors.borderColor
        self.containerView.layer.borderWidth = 1
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 12
    }
    func configureWith(data: Auction.CellData) {
        self.titleLabel.text = data.title
        self.startLabel.text = data.startDate
    }
    
}
