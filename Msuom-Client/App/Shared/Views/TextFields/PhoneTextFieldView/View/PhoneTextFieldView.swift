//
//  PhoneTextFieldView.swift
//  Msuom
//
//  Created by MGAbouarab on 22/10/2022.
//

import UIKit

final class PhoneTextFieldView: TextFieldView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var countryCodeView: UIView!
    @IBOutlet weak private var countryCodeLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    //MARK: - Properties -
    @IBInspectable var image: UIImage? {
        didSet {
            self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            self.imageView.isHidden = self.image == nil
        }
    }
    @IBInspectable var enableCode: Bool = true {
        didSet {
            self.countryCodeView.isHidden = !enableCode
        }
    }
    private let pickerView = UIPickerView()
    private var countryCodes: [CountryCodeItem] = []
    private var selectedCountryCode: CountryCodeItem? {
        didSet {
            if let flag = self.selectedCountryCode?.emoji, let code = self.selectedCountryCode?.countryCode {
                self.countryCodeLabel.text = flag + " " + code
            } else {
                self.countryCodeLabel.text = nil
            }
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
        let nib = UINib(nibName: "PhoneTextFieldView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupTextField()
        self.setupLocalization()
        self.setupContainerView()
        self.imageView.isHidden = true
        if let data = self.readLocalJsonFile(forName: Language.isRTL() ? "countriesAr" : "countriesEn") {
            if let countries: [Country] = self.parse(jsonData: data) {
                self.countryCodes = countries
                self.selectedCountryCode = self.countryCodes.first
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showCountryCode))
        self.countryCodeView.addGestureRecognizer(tap)
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
        self.titleLabel.text = "Phone Number".phoneNumberLocalizable
        self.textField.placeholder = "Please enter your phone number".phoneNumberLocalizable
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
    
    
    //MARK: - Load resources -
    private func readLocalJsonFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    private func parse<T: Decodable>(jsonData: Data) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            return nil
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
    func set(countryCodes: [CountryCodeItem]) {
        self.countryCodes = countryCodes
    }
    private func set(countryCode: CountryCodeItem) {
        self.selectedCountryCode = countryCode
    }
    func set(code: String?) {
        guard let countryCode = self.countryCodes.filter({$0.countryCode == code}).first else {
            self.selectedCountryCode = self.countryCodes.first
            return
        }
        self.selectedCountryCode = countryCode
    }
    func phoneText() throws -> String {
        do {
            return try PhoneValidationService.validate(phone: self.textField.text)
        } catch {
//            self.shake()
            throw error
        }
    }
    func phoneTextValue() -> String? {
        self.textField.textValue
    }
    func countryCodeText() throws -> String {
        do {
            return try PhoneValidationService.validate(countryCode: self.selectedCountryCode?.countryCode)
        } catch {
            self.countryCodeView.shake()
            throw error
        }
    }
    
    //MARK: - Actions -
    @objc private func showCountryCode() {
        
        let vc = CountriesVC(countries: self.countryCodes, delegate: self)
        let nav = BaseNav(rootViewController: vc)
        self.parentContainerViewController?.present(nav, animated: true)
        
    }
    
}
extension PhoneTextFieldView: CountryCodeDelegate {
    func didSelectCountry(_ item: CountryCodeItem) {
        self.selectedCountryCode = item
    }
}
extension PhoneTextFieldView: UITextFieldDelegate {
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
