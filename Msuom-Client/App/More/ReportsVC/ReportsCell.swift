//
//  ReportsCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 25/05/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class ReportsCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var orderNumberLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    
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
    func configureWith(data: ReportsVC.Report) {
        self.cellImageView.setWith(string: data.carImage)
        self.nameLabel.text = data.carName
        self.descriptionLabel.text = data.descriptionBid
        self.orderNumberLabel.text = "Auction Number".localized + " " + "\(data.adNumber)"
        self.statusLabel.text = data.status
    }
    
    
    //MARK: - Actions -
    
    
}
