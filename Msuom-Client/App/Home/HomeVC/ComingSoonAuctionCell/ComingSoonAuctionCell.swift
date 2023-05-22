//
//  ComingSoonAuctionCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 14/02/2023.
//

import UIKit

class ComingSoonAuctionCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    
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
        self.selectionStyle = .none
        self.containerView.layer.borderColor = Theme.colors.borderColor
        self.containerView.layer.borderWidth = 1
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 12
    }
    
    func configureWith(data: Auction.HomeSoonAuction) {
        cellImageView.setWith(string: data.image)
        nameLabel.text = data.name
        priceLabel.text = data.startPrice
        self.fullDate = data.fullStartDate
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
    }
    func configureWith(details data: BidDetails.HomeSoonAuction) {
        cellImageView.setWith(string: data.image)
        nameLabel.text = data.name
        priceLabel.text = data.startPrice
        self.fullDate = data.fullStartDate
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
        }
    }
    
}

extension String {
    func toTimeRemain() -> String? {
        guard let date = self.toFullDate() else {return nil}
        let seconds = Int(date.timeIntervalSinceNow)
        
        let days = String((seconds / 86400)) + " D".localized
        let hours = String((seconds % 86400) / 3600) + " H".localized
        let minutes = String((seconds % 3600) / 60) + " M".localized
        let finalSeconds = String((seconds % 3600) % 60) + " S".localized
        
        if seconds > 0 {
            return "\(days) : \(hours) : \(minutes) : \(finalSeconds)"
        } else {
            return nil
        }
        
    }
}

extension String {
    func toFullDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = appFullDateFormate
        let date = dateFormatter.date(from: self)
        return date
    }
}
