//
//  EvaluationOrderCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 07/02/2023.
//

import UIKit

class EvaluationOrderCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var brandLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var walkwayLabel: UILabel!
    @IBOutlet weak private var orderNumberLabel: UILabel!
    @IBOutlet weak private var yearLabel: UILabel!
    @IBOutlet weak private var currentStatusLabel: UILabel!
    
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
    func configureWith(data: EvaluationOrderDetails) {
        self.brandLabel.text = data.brandName
        self.typeLabel.text = data.typeName
        self.categoryLabel.text = data.categoryName
        self.statusLabel.text = data.statusName
        self.walkwayLabel.text = data.walkway
        self.orderNumberLabel.text = "Order Number:".localized + " " + "\(data.orderNo ?? 0)"
        self.yearLabel.text = data.year
        self.currentStatusLabel.text = data.orderStatusTxt
    }
    
    //MARK: - Actions -
    
}
