//
//  TryToBuyCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/06/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class TryToBuyCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var selectionButton: UIButton!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var typeImageView: UIImageView!
    
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
    func configureWith(data: PaymentModel) {
        self.nameLabel.text = Language.isRTL() ? data.name.ar : data.name.en
        self.selectionButton.isSelected = data.isSelected ?? false
        self.typeImageView.setWith(string: data.uploads)
    }
    
    
    //MARK: - Actions -
    
    
}
