//
//  DatePickerTextFieldView.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 23/01/2023.
//

import UIKit


class DatePickerTextFieldView: TextFieldView {
    
    enum Mode {
        case date(minimum: Date? = nil, maximum: Date? = nil)
        case time(minimum: Date? = nil, maximum: Date? = nil)
        case dateAndTime(minimum: Date? = nil, maximum: Date? = nil)
        
        var formateStyle: String {
            switch self {
            case .date:
                return "EEEE, d MMMM yyyy"
            case .time:
                return "h:mm a"
            case .dateAndTime:
                return "EEEE, d MMMM yyyy '-' h:mm a"
            }
        }
        
    }
    
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
            self.requiredMark.isHidden = !self.isRequired
        }
    }
    
    lazy var mode: Mode = .date()
    
    private var selectedDate: Date?
    
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
        let nib = UINib(nibName: "DatePickerTextFieldView", bundle: bundle)
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
    func set(
        value: String?,
        formate: String = Mode.date().formateStyle
    ) {
        guard let value, !value.trimWhiteSpace().isEmpty, let dateValue = value.toDate(formate: formate) else {
            self.textField.text = nil
            self.setInactiveState()
            return
        }
        self.textField.text = dateValue.displayedText()
        self.selectedDate = dateValue
        self.setActiveState()
    }
    func set(value: Date?) {
        guard let value else {
            self.textField.text = nil
            self.selectedDate = nil
            self.setInactiveState()
            return
        }
        self.textField.text = value.displayedText()
        self.selectedDate = value
        self.setActiveState()
    }
    func value() -> Date? {
        self.selectedDate
    }
    
    //MARK: - Action -
    @objc private func viewTapped() {
        self.parentContainerViewController?.view.endEditing(true)
        let vc = DatePickerVC(delegate: self)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        self.parentContainerViewController?.present(vc, animated: true)
        vc.configure(mode: self.mode)
        vc.set(selectedDate: self.selectedDate)
        vc.set(title: self.titleLabel.text)
    }
    
}

extension DatePickerTextFieldView: DatePickerDelegate {
    func didSelect(date: Date) {
        switch self.mode {
        case .date:
            self.selectedDate = date
            self.textField.text = date.displayedText(dateFormat: mode.formateStyle)
        case .time:
            self.selectedDate = date
            self.textField.text = date.displayedText(dateFormat: mode.formateStyle)
        case .dateAndTime:
            self.selectedDate = date
            self.textField.text = date.displayedText(dateFormat: mode.formateStyle)
        }
        self.setActiveState()
    }
}

private extension Date {
    func displayedText(dateFormat: String = "dd-MM-yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: Language.isRTL() ? "ar" : "en")
        let date = dateFormatter.string(from: self)
        return date
    }
}
