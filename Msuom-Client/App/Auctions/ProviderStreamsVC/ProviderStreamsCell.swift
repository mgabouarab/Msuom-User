//
//  ProviderStreamsCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 28/05/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class ProviderStreamsCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var selectionButton: UIButton!
    @IBOutlet weak private var liveView: UIView!
    
    //MARK: - properties -
    
    
    //MARK: - Overriden Methods-
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDesign()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCellData()
    }
    
    //MARK: - Design Methods -
    private func setupDesign() {
        self.selectionStyle = .none
    }
    private func resetCellData() {
        
    }
    
    //MARK: - Configure Data -
    func configureWith(data: BidStream) {
        
        self.nameLabel.text = data.name
        self.addressLabel.text = data.cityName
        
        let startTime = "Start Auction Time: ".localized + (data.startTime ?? "")
        let endTime = "End Auction Time: ".localized + (data.endTime ?? "")
        
        
        self.dateLabel.text = (data.isRunning ?? false) ?  startTime : endTime
        self.countLabel.text = data.bidsCount?.stringValue
        self.selectionButton.isSelected = data.isSelected ?? false
        self.liveView.isHidden = !(data.type == "live")
    }
    
    
    //MARK: - Actions -
    
    
}
