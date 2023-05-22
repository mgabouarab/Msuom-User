//
//  LastBidsCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class LastBidsCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var providerImageView: UIImageView!
    @IBOutlet weak private var providerNameLabel: UILabel!
    @IBOutlet weak private var providerDateLabel: UILabel!
    @IBOutlet weak private var providerBidLabel: UILabel!
    
    //MARK: - Properties -
    
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.selectionStyle = .none
    }
    
    func set(image: String?, name: String?, date: String?, bid: String?) {
        self.providerImageView.setWith(string: image)
        self.providerNameLabel.text = name
        self.providerDateLabel.text = date
        self.providerBidLabel.text = bid
    }
    
    
}
