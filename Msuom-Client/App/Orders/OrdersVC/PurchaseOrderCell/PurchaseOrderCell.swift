//
//  PurchaseOrderCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 07/02/2023.
//

import UIKit

class PurchaseOrderCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var isFinancingLabel: UILabel!
    
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
    func configureWith(data: PurchaseOrderDetails) {
        let items = [data.typeName, data.brandName, data.year].compactMap({$0})
        cellImageView.setWith(string: data.image)
        nameLabel.text = items.joined(separator: " ")
        priceLabel.text = "Cash price:".localized + " \(data.price ?? 0) \(data.currency ?? appCurrency)"
        isFinancingLabel.text = data.isFinancing
    }
    
    //MARK: - Actions -
    
}
