//
//  SelectLocationView.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/05/2023.
//

import UIKit
import CoreLocation

class SelectLocationView: TextFieldView {
    
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var requiredMark: UIView!
    
    //MARK: - Properties -
    @IBInspectable
    var image: UIImage? {
        didSet {
            self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            self.imageView.isHidden = self.image == nil
        }
    }
    @IBInspectable
    var titleLocalizedKey: String? {
        didSet {
            self.titleLabel.xibLocKey = titleLocalizedKey
        }
    }
    @IBInspectable
    var placeholderLocalizedKey: String? {
        didSet {
            self.textField.xibPlaceholderLocKey = placeholderLocalizedKey
        }
    }
    @IBInspectable
    var isRequired: Bool = true {
        didSet {
            self.requiredMark.isHidden = !self.isRequired
        }
    }
    
    private var selectedLocation: CLLocationCoordinate2D?
    
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
        let nib = UINib(nibName: "SelectLocationView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupTextField()
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
    
    private func pickAddress() {
        let vc = SelectAddressOnMapVC.create(delegate: self)
        (self.parentContainerViewController as? BaseVC)?.push(vc)
    }
    
    //MARK: - Encapsulation -
    func set(file: CLLocationCoordinate2D?) {
        guard let file else {
            self.setInactiveState()
            return
        }
        self.selectedLocation = file
        self.setActiveState()
    }
    func value() -> CLLocationCoordinate2D? {
        self.selectedLocation
    }
    func address() -> String? {
        self.textField.text
    }
    
}

extension SelectLocationView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.endEditing(true)
        self.pickAddress()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.trimWhiteSpace().isEmpty else {
            self.setInactiveState()
            return
        }
        self.setActiveState()
    }
}

extension SelectLocationView: AddAddressDelegate {
    func update(with locationCoordinate: CLLocationCoordinate2D) {
        self.selectedLocation = locationCoordinate
        AppHelper.getAddressFrom(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude) { [weak self] address in
            self?.textField.text = address
            self?.setActiveState()
        }
    }
}
