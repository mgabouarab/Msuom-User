//
//  CurrentAuctionCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 14/02/2023.
//

import UIKit

class CurrentAuctionCell: UICollectionViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var liveView: UIView!
    
    //MARK: - Properties -
    private var timer: Timer?
    private var fullDate: String?
    
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
        self.containerView.layer.borderColor = Theme.colors.borderColor
        self.containerView.layer.borderWidth = 1
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 12
    }
    func configureWith(data: Auction.HomeSoonAuction) {
        self.liveView.isHidden = !data.isLive
        nameLabel.text = data.name
        priceLabel.text = data.fullStartDate
        self.fullDate = data.fullEndDate
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
    }
    
    @objc private func updateDate() {
        guard let fullDate = self.fullDate else {return}
        if let time = fullDate.toTimeRemain() {
            self.timeLabel.text = "Remain".localized + " " + time
        } else {
            self.timeLabel.text = "Finished".localized
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
}
