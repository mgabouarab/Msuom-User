//
//  OrdersCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/02/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class OrdersCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    
    
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
    func configureWith(data: String) {
        
    }
    
    
    //MARK: - Actions -
    
    
}
