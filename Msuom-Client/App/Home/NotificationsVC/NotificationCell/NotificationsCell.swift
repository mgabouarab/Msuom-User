//
//  NotificationsCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/11/2022.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class NotificationsCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    
    
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
        self.titleLabel.text = nil
    }
    
    //MARK: - Configure Data -
    func configureWith(data: String?) {
        self.titleLabel.text = data
    }
    
    
    //MARK: - Actions -
    
    
}
