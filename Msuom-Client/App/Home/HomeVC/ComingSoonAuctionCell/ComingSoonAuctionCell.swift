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
    @IBOutlet weak private var liveView: UIStackView!
    @IBOutlet weak private var numberView: UIView!
    @IBOutlet weak private var numberLabel: UILabel!
    
    //MARK: - Properties -
    private var timer: Timer?
    private var fullDate: String?
    private var isStart: Bool = false
    var didEndWaitingTime: (()->())?
    
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
        self.liveView.isHidden = !data.isLive
        cellImageView.setWith(string: data.image)
        isStart = data.isStart
        nameLabel.text = data.name
        priceLabel.text = data.startPrice + " " + appCurrency
        self.fullDate = data.fullStartDate
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
    }
    func configureWith(details data: BidDetails.HomeSoonAuction, index: Int? = nil) {
        cellImageView.setWith(string: data.image)
        self.liveView.isHidden = !data.isLive
        isStart = data.isStart
        nameLabel.text = data.name
        priceLabel.text = data.startPrice + " " + appCurrency
        self.fullDate = data.isStart ? data.fullEndDate : data.fullStartDate
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
        if let index = index {
            self.numberView.isHidden = false
            self.numberLabel.text = "\(index)"
        } else {
            self.numberView.isHidden = true
        }
    }
    func configureWith(model data: MyCarsModel) {
        cellImageView.setWith(string: data.image)
        self.liveView.isHidden = !data.isLive
        isStart = data.isStart
        nameLabel.text = data.name
        priceLabel.text = (data.startPrice ?? "0") + " " + appCurrency
        self.fullDate = data.isStart ? data.fullEndDate : data.fullStartDate
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
    }
    func configureWith(auction data: SearchModel) {
        cellImageView.setWith(string: data.image)
        self.liveView.isHidden = !data.isLive
        isStart = data.isStart
        nameLabel.text = data.name
        priceLabel.text = (data.startPrice ?? "0") + " " + appCurrency
        self.fullDate = data.isStart ? data.fullEndDate : data.fullStartDate
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
    }
    
    @objc private func updateDate() {
        guard let fullDate = self.fullDate else {return}
        if let time = fullDate.toTimeRemain() {
            self.timeLabel.text = "Remain".localized + " " + time
            self.timeLabel.textColor = isStart ? Theme.colors.mainDarkFontColor : Theme.colors.errorColor
        } else {
            self.didEndWaitingTime?()
            self.timeLabel.text = "Finished".localized
            self.timeLabel.textColor = Theme.colors.errorColor
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
