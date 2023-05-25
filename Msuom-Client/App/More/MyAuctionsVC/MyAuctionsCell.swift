//
//  MyAuctionsCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/01/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class MyAuctionsCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var numberLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var cardView: UIView!
    @IBOutlet weak private var isAfterSaleServiceButton: UIButton!
    @IBOutlet weak private var isShippingButton: UIButton!
    @IBOutlet weak private var openButton: UIButton!
    
    //MARK: - properties -
    var requestChargeAction: (()->())?
    var saleAction: (()->())?
    var openAction: (()->())?
    var tapAction: (()->())?
    
    
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
//        let tap = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
//        self.cardView.addGestureRecognizer(tap)
    }
    private func resetCellData() {
        
    }
    
    //MARK: - Configure Data -
    func configureWith(details data: BidDetails.HomeSoonAuction) {
        cellImageView.setWith(string: data.image)
        nameLabel.text = data.name
        numberLabel.text = "Auction Number".localized + " " + (data.number ?? "0")
        descriptionLabel.text = data.description
        isAfterSaleServiceButton.isHidden = !data.isAfterSaleService
        isShippingButton.isHidden = !data.isShipping
        openButton.isHidden = !data.open
    }
    
    
    //MARK: - Actions -
    @IBAction private func requestOrderButtonPressed() {
        self.requestChargeAction?()
    }
    @IBAction private func afterSaleButtonPressed() {
        self.saleAction?()
    }
    @IBAction private func openTapped() {
        self.openAction?()
    }
    
    
}
