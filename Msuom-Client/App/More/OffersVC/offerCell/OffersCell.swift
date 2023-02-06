//
//  OffersCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 30/01/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class OffersCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var companyNameLabel: UILabel!
    @IBOutlet weak private var companyImageView: UIImageView!
    @IBOutlet weak private var dateLabel: UILabel!
    
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
        self.containerView.layer.borderColor = Theme.colors.borderColor
        self.containerView.layer.borderWidth = 1
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 12
    }
    private func resetCellData() {
        
    }
    
    //MARK: - Configure Data -
    func configureWith(data: OfferModel) {
        self.cellImageView.setWith(string: data.offer.image)
        self.nameLabel.text = data.offer.title
        self.companyNameLabel.text = data.provider.name
        self.companyImageView.setWith(string: data.provider.image)
        self.dateLabel.text = data.offer.available?.htmlToAttributedString?.string
    }
    
    
    //MARK: - Actions -
    
    
}
