//
//  AuctionsStoreCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 28/05/2023.
//

import UIKit

class AuctionsStoreCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var storeImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var timerLabel: UILabel!
    
    //MARK: - Properties -
    private var timer: Timer?
    private var fullDate: String?
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialView()
    }
    
    //MARK: - Design -
    private func setupInitialView() {
        self.selectionStyle = .none
    }
    
    func set(image: String?, name: String?, count: String?, address: String?, time: String?) {
        self.storeImageView.setWith(string: image)
        self.nameLabel.text = name
        self.countLabel.text = count
        self.addressLabel.text = address
        self.fullDate = time
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDate), userInfo: nil, repeats: true)
    }
    
    //MARK: - Action -
    @objc private func updateDate() {
        guard let fullDate = self.fullDate else {return}
        if let time = fullDate.toTimeRemain() {
            self.timerLabel.text = "Remain".localized + " " + time
        } else {
            self.timerLabel.text = "Finished".localized
        }
    }
    
    
    
}
