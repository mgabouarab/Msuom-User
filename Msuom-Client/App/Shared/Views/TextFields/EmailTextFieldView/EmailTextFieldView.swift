//
//  EmailTextFieldView.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import UIKit

class EmailTextFieldView: TextFieldView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var imageView: UIImageView!
    
    //MARK: - Properties -
    @IBInspectable var image: UIImage? {
        didSet {
            self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            self.imageView.isHidden = self.image == nil
        }
    }
    
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
        let nib = UINib(nibName: "EmailTextFieldView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupTextField()
        self.setupLocalization()
        self.setupContainerView()
        self.imageView.isHidden = true
    }
    private func setupContainerView() {
        self.containerView.layer.cornerRadius = containerViewCornerRadius
        self.containerView.clipsToBounds = true
        self.setInactiveState()
    }
    private func setupTextField() {
        self.textField.delegate = self
    }
    private func setupLocalization() {
        self.titleLabel.text = "E-mail Address".emailLocalizable
        self.textField.placeholder = "Please enter your e-mail address".emailLocalizable
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
    func set(text: String?) {
        guard let text, !text.trimWhiteSpace().isEmpty else {
            self.textField.text = nil
            self.setInactiveState()
            return
        }
        self.textField.text = text
        self.setActiveState()
    }
    func emailText() throws -> String {
        try EmailValidationService.validate(email: self.textField.text)
    }
    func emailTextValue() -> String? {
        self.textField.textValue
    }
    
}

extension EmailTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setActiveState()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.trimWhiteSpace().isEmpty else {
            self.setInactiveState()
            return
        }
        self.setActiveState()
    }
}
