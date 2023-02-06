//
//  DropDownTextFieldView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 17/11/2022.
//

import UIKit


class DropDownTextFieldView: TextFieldView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var requiredMark: UIView!
    
    //MARK: - Properties -
    @IBInspectable var image: UIImage? {
        didSet {
            self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            self.imageView.isHidden = self.image == nil
        }
    }
    @IBInspectable var titleLocalizedKey: String? {
        didSet {
            self.titleLabel.xibLocKey = titleLocalizedKey
        }
    }
    @IBInspectable var placeholderLocalizedKey: String? {
        didSet {
            self.textField.xibPlaceholderLocKey = placeholderLocalizedKey
        }
    }
    @IBInspectable var isRequired: Bool = true {
        didSet {
            self.requiredMark.isHidden = self.isRequired
        }
    }
    var delegate: DropDownTextFieldViewDelegate?
    private var selectedItem: DropDownItem?
    
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
        let nib = UINib(nibName: "DropDownTextFieldView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupContainerView()
        self.imageView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.containerView.addGestureRecognizer(tap)
    }
    private func setupContainerView() {
        self.containerView.layer.cornerRadius = containerViewCornerRadius
        self.containerView.clipsToBounds = true
        self.setInactiveState()
    }
    private func setActiveState() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.addBorder(with: self.activeBorderColor)
            self.tintColor = self.activeTintColor
        }
    }
    private func setInactiveState() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.addBorder(with: self.inActiveBorderColor)
            self.tintColor = self.inActiveTintColor
        }
    }
    
    //MARK: - Encapsulation -
    func set(value: DropDownItem?) {
        guard let value, !value.name.trimWhiteSpace().isEmpty else {
            self.textField.text = nil
            self.setInactiveState()
            return
        }
        self.textField.text = value.name
        self.selectedItem = value
        self.setActiveState()
    }
    func value() -> DropDownItem? {
        self.selectedItem
    }
    
    
    //MARK: - Action -
    @objc private func viewTapped() {
        self.parentContainerViewController?.view.endEditing(true)
        guard let delegate = self.delegate else {
            print("This TextFieldView has no delegate")
            return
        }
        let vc = DropDownListVC(items: delegate.dropDownList(for: self), delegate: self, title: self.titleLocalizedKey?.localized)
        let nav = BaseNav(rootViewController: vc)
        self.parentContainerViewController?.present(nav, animated: true)
    }
    
}

extension DropDownTextFieldView: DropDownTextFieldViewListDelegate {
    func didSelect(item: DropDownItem) {
        self.delegate?.didSelect(item: item, for: self)
        self.set(value: item)
    }
}
    
