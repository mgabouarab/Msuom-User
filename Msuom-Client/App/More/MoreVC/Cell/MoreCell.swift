//
//  MoreCell.swift
//  Msuom
//
//  Created by MGAbouarab on 26/10/2022.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class MoreCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var arrowImageView: UIImageView!
    @IBOutlet weak private var iconImageView: UIImageView!
    
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
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    //MARK: - Design Methods -
    private func setupDesign() {
        self.selectionStyle = .none
        self.contentView.clipsToBounds = true
    }
    private func resetCellData() {
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
        self.iconImageView.image = nil
    }
    
    //MARK: - Configure Data -
    func configureWith(data: MoreItem) {
        self.contentView.backgroundColor = data.color
        self.titleLabel.text = data.title
        self.iconImageView.image = UIImage(named: data.iconName)
        self.arrowImageView.isHidden = !data.hasArrow
        if let description = data.description, !description.trimWhiteSpace().isEmpty {
            self.descriptionLabel.text = description
            self.descriptionLabel.isHidden = false
        } else {
            self.descriptionLabel.isHidden = true
        }
    }
    
    
    
    //MARK: - Actions -
    
    
}
