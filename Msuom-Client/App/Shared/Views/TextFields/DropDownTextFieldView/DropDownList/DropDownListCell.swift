//
//  DropDownListCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 17/11/2022.
//

import UIKit

final class DropDownListCell: UITableViewCell {
    
    //MARK: - Proprites -
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.textColor = Theme.colors.mainDarkFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupInitialView()
        self.resetData()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupInitialView()
        self.resetData()
    }
    
    //MARK: - Lifecycle -
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetData()
    }
    
    //MARK: - Design & Data -
    private func setupInitialView() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        let stack = UIStackView(arrangedSubviews: [nameLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        self.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    private func resetData() {
        self.nameLabel.text = nil
    }
    
    func setup(item: DropDownItem) {
        self.nameLabel.text = item.name
    }
    
    
}
