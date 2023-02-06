//
//  CountryCodeCell.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import UIKit

final class CountryCodeCell: UITableViewCell {
    
    //MARK: - Proprites -
    private var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var flagLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.textColor = Theme.colors.mainDarkFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var codeLabel: UILabel = {
        let label = UILabel()
        label.text = nil
        label.textColor = Theme.colors.secondryDarkFontColor
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
        let stack = UIStackView(arrangedSubviews: [flagImageView, flagLabel, nameLabel, UIImageView(), codeLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        self.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    private func resetData() {
        self.flagImageView.isHidden = true
        self.flagLabel.isHidden = true
        self.flagLabel.text = nil
        self.nameLabel.text = nil
        self.codeLabel.text = nil
    }
    
    func setup(country: CountryCodeItem) {
        if let flagImage = country.flag {
            self.flagImageView.setWith(string: flagImage)
            self.flagImageView.isHidden = false
        } else if let flagEmoji = country.emoji {
            self.flagLabel.text = flagEmoji
            self.flagLabel.isHidden = false
        }
        self.nameLabel.text = country.name
        self.codeLabel.text = country.countryCode
    }
    
    
}
