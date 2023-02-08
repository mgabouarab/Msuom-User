//
//  SummaryReportOrderCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 07/02/2023.
//

import UIKit

class SummaryReportOrderCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    @IBOutlet weak private var orderNumberLabel: UILabel!
    
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
    func configureWith(data: SummaryReportDetails) {
        self.cellImageView.setWith(string: data.image)
        let items = [data.typeName, data.brandName, data.year].compactMap({$0})
        self.titleLabel.text = items.joined(separator: " ")
        self.bodyLabel.text = data.description
        self.orderNumberLabel.text = "Ad Number:".localized + " " + "\(data.orderNo ?? 0)"
    }
    
    //MARK: - Actions -
    
}
