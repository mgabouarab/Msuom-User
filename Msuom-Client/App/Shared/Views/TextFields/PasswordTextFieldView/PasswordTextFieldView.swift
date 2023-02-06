//
//  PasswordTextFieldView.swift
//  Msuom
//
//  Created by MGAbouarab on 24/10/2022.
//

import UIKit

class PasswordTextFieldView: TextFieldView {
    
    enum PasswordType {
        case password
        case newPassword
        case oldPassword
        case confirmPassword(password: String)
        case confirmNewPassword(password: String)
    }
    
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var secureButton: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    
    //MARK: - Properties -
    @IBInspectable var image: UIImage? {
        didSet {
            self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            self.imageView.isHidden = self.image == nil
        }
    }
    @IBInspectable var secureImage: UIImage? {
        didSet {
            self.secureButton.setImage(secureImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    @IBInspectable var unSecureImage: UIImage? {
        didSet {
            self.secureButton.setImage(unSecureImage?.withRenderingMode(.alwaysTemplate), for: .selected)
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
        let nib = UINib(nibName: "PasswordTextFieldView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupTextField()
        self.setupContainerView()
        self.tintColor = inActiveTintColor
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
    func passwordText(for type: PasswordType) throws -> String {
        switch type {
        case .password:
            return try PasswordValidationService.validate(password: self.textField.text)
        case .newPassword:
            return try PasswordValidationService.validate(newPassword: self.textField.text)
        case .oldPassword:
            return try PasswordValidationService.validate(oldPassword: self.textField.text)
        case .confirmPassword(let password):
            return try PasswordValidationService.validate(newPassword: password, confirmPassword: self.textField.text)
        case .confirmNewPassword(let password):
            return try PasswordValidationService.validate(newPassword: password, confirmNewPassword: self.textField.text)
        }
    }
    
    //MARK: - IBActions -
    @IBAction private func toggleSecureButtonPressed() {
        self.secureButton.isSelected.toggle()
        self.textField.isSecureTextEntry = !secureButton.isSelected
    }
}

extension PasswordTextFieldView: UITextFieldDelegate {
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
