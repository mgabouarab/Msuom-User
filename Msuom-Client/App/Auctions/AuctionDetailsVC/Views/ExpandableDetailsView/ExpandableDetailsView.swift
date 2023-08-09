//
//  ExpandableDetailsView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class ExpandableDetailsView: UIView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    //MARK: - Properties -
    
    //MARK: - Initializer -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    
    private func xibSetUp() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ExpandableDetailsView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        
    }
    func set(title: String?, description: String?) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.addGestureRecognizer(tap)
    }
    func set(title: String?, description: String?, image: String?, isSelected: Bool?) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.imageView.setWith(string: image)
        self.descriptionLabel.isHidden = isSelected != true
        self.imageView.isHidden = isSelected != true
    }
    
    
    //MARK: - Encapsulation -
    
    
    
    //MARK: - Action -
    @objc private func viewTapped() {
        self.descriptionLabel.isHidden.toggle()
    }
    
    
}
