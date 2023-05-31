//
//  CarCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 14/11/2022.
//

import UIKit

protocol CarCellViewData {
    var image: String? {get}
    var name: String? {get}
    var price: String {get}
    var sellType: String {get}
    var isFinancing: String? {get}
}

class CarCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var cellImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Design -
    func setupInitialDesign() {
        self.selectionStyle = .none
        self.containerView.layer.borderColor = Theme.colors.borderColor
        self.containerView.layer.borderWidth = 1
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 12
        self.cellImageView.contentMode = .scaleAspectFill
    }
    func configureWith(data: CarCellViewData) {
        cellImageView.setWith(string: data.image)
        nameLabel.text = data.name
        priceLabel.text = data.price
        typeLabel.text = data.sellType
    }
    func setupDataWith(data: CarCellViewData) {
        cellImageView.setWith(string: data.image)
        nameLabel.text = data.name
        priceLabel.text = data.price
        typeLabel.text = data.isFinancing
    }
    
}
