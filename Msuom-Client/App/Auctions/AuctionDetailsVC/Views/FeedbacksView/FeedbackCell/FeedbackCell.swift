//
//  FeedbackCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/05/2023.
//

import UIKit

class FeedbackCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var userImageView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var ratingView: StarRatingView!
    @IBOutlet weak private var commentLabel: UILabel!
    @IBOutlet weak private var actionView: UIView!
    @IBOutlet weak private var dateLabel: UILabel!
    
    //MARK: - Properties -
    var deleteAction: (()->())?
    var editAction: (()->())?
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
    }

    //MARK: - Design -
    private func setupInitialDesign() {
        self.selectionStyle = .none
    }
    
    func configureWith(data: FeedbackModel) {
        self.userImageView.setWith(string: data.avatar)
        self.userNameLabel.text = data.userName
        self.ratingView.rating = Float(data.rating?.doubleValue ?? 0)
        self.commentLabel.text = data.comment
        self.dateLabel.text = data.createAt
        self.actionView.isHidden = data.owner != true
    }
    
    //MARK: - Actions -
    @IBAction private func deleteButtonPressed() {
        self.deleteAction?()
    }
    @IBAction private func editButtonPressed() {
        self.editAction?()
    }
    
}
