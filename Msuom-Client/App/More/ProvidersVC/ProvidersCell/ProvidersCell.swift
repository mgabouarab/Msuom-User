//
//  ProvidersCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/02/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class ProvidersCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var placeLabel: UILabel!
    
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
    func configureWith(data: OfferProvider) {
        cellImageView.setWith(string: data.image)
        nameLabel.text = data.name
        countLabel.text = data.carCount?.htmlToAttributedString?.string
        placeLabel.text = data.cityName
    }
    
    
    //MARK: - Actions -
    
    
}
