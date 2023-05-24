//
//  AfterSaleCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/05/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class AfterSaleCell: UITableViewCell {
    
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
    func configureWith(data: AfterSaleVC.Service) {
        
    }
    
    
    //MARK: - Actions -
    
    
}
