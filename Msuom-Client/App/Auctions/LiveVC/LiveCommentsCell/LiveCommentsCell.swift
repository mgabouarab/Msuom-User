//
//  LiveCommentsCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 17/05/2023.
//

import UIKit

class LiveCommentsCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var userImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var commentLabel: UILabel!
    
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.selectionStyle = .none
    }
    
    func set(title: String?, comment: String?, image: String?) {
        self.titleLabel.text = ""
        self.userImageView.setWith(string: image)
        self.titleLabel.text = title
        self.commentLabel.text = comment
    }
    
    
}
