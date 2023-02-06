//
//  FloatingTextField.swift
//
//  Created by MGAbouarab®.
//

import UIKit


class MGFloatingTextField: UITextField {
    
    enum Direction {
        case rtl
        case ltr
    }

    
    //MARK: - Properties -
    var isPassword = true
    var selectedBorderColor: UIColor = Theme.colors.mainColor
    var normalBorderColor = Theme.colors.borderColor
    lazy var padding = (self.direction == .ltr) ? UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) : UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    var placeholderView: UIView?
    private var tempPlaceholder: String?
    private weak var timer: Timer?
    private lazy var direction: Direction = {
        return Language.isRTL() ? .rtl : .ltr
    }()
    @IBInspectable var leadingImage : UIImage? = nil {
            didSet{
                guard let image = self.leadingImage else {return}
                self.sideImage(image, imageWidth: 25, padding: 15)
            }
        }
    @IBInspectable var trailingNormalImage : UIImage? = nil {
        didSet{
            self.setTrailing(trailingNormalImage, imageWidth: 25, padding: 15, notSecureImage: trailingSelectedImage)
        }
    }
    @IBInspectable var trailingSelectedImage : UIImage? = nil {
        didSet{
            self.setTrailing(trailingNormalImage, imageWidth: 25, padding: 15, notSecureImage: trailingSelectedImage)
        }
    }
    let secureButton = UIButton()
    var errorMessageLabel: UILabel?
    
    
    //MARK:- Overriden Properities -
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //MARK:- Overriden Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialConfiguration()
    }
    
    //MARK:- Design Methods -
    private func initialConfiguration() {
        self.delegate = self
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = normalBorderColor
        self.backgroundColor = .clear
        self.borderStyle = .none
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
    func handelPlaceholderView() {
        guard let pHolder = self.placeholder else {return}
        let width = pHolder.width(withConstrainedHeight: 16, font: UIFont(name: "Cairo-Regular", size: 15)!) + 30
        let xPoint = self.direction == .ltr ? self.frame.minX + 15 : self.frame.maxX - 15 - width
        let yPoint = self.frame.minY - 8
        self.placeholderView = UIView(frame: CGRect(x: xPoint, y: yPoint, width: width, height: 20))
        self.placeholderView?.backgroundColor = .clear
    }
    func createLabelView() {
        handelPlaceholderView()
        guard let pHolder = self.placeholder else {return}
        let width = pHolder.width(withConstrainedHeight: 16, font: UIFont(name: "Cairo-Regular", size: 15)!)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: width, height: 16))
        label.text = self.placeholder
        label.textColor = self.selectedBorderColor
        label.font = UIFont(name: "Cairo-Regular", size: 15)
        self.placeholderView?.addSubview(label)
        guard let _ = self.placeholderView else { return }
        
        UIView.transition(with: self.superview!, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.superview!.addSubview(self.placeholderView!)
            self.placeholderView?.backgroundColor = Theme.colors.mainBackgroundColor
                self.superview!.bringSubviewToFront(self.placeholderView!)
            }, completion: nil)
    }
    func addDesign() {
        self.layer.borderColor = self.selectedBorderColor.cgColor
        self.createLabelView()
        self.tempPlaceholder = self.placeholder
        self.placeholder = nil
    }
    func addDesignForCell() {
        self.layer.borderColor = self.selectedBorderColor.cgColor
        self.createLabelView()
        self.tempPlaceholder = self.placeholder
    }
    
    //MARK:- Alert -
    func showVisualAlert(_ message: String?) {
        timer?.invalidate()
        self.errorMessageLabel?.removeFromSuperview()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer?.fire()
        let width = self.frame.width - 30
        let xPoint = self.direction == .ltr ? self.frame.minX + 15 : self.frame.maxX - 15 - width
        let yPoint = self.frame.maxY + 5
        
        self.errorMessageLabel = UILabel(frame: CGRect(x: xPoint, y: yPoint, width: width, height: 20))
        self.errorMessageLabel?.font = UIFont(name: "Cairo-Bold", size: 10)
        self.errorMessageLabel?.textColor = self.selectedBorderColor
        self.errorMessageLabel?.text = message
        
        UIView.transition(with: self.superview!, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.superview!.addSubview(self.errorMessageLabel!)
                self.superview!.bringSubviewToFront(self.errorMessageLabel!)
            }, completion: nil)
        
    }
    @objc func fireTimer() {
        self.layer.borderColor = (self.layer.borderColor! == self.normalBorderColor) ? self.selectedBorderColor.cgColor : self.normalBorderColor
    }
}
extension MGFloatingTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard textField.text?.isEmpty == true else {return}
        self.timer?.invalidate()
        self.layer.borderColor = self.selectedBorderColor.cgColor
        self.createLabelView()
        self.tempPlaceholder = self.placeholder
        self.placeholder = nil
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty == true else {
            self.placeholder = self.tempPlaceholder
            return
        }
        self.layer.borderColor = self.normalBorderColor
        UIView.transition(with: self.superview!, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.placeholderView?.removeFromSuperview()
            self.errorMessageLabel?.removeFromSuperview()
            }, completion: nil)
        self.placeholder = self.tempPlaceholder
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            self.placeholder = nil
        }
    }
}
extension MGFloatingTextField {
    func setTrailing(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat, notSecureImage: UIImage?) {
        secureButton.setTitle(nil, for: .normal)
        secureButton.setImage(image, for: .normal)
        if isPassword {
            secureButton.setImage(notSecureImage, for: .selected)
            secureButton.addTarget(self, action: #selector(self.toggleSecure), for: .touchUpInside)
        }
        secureButton.imageView?.contentMode = .scaleAspectFit
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(secureButton)
        secureButton.frame = containerView.frame
        
//        if self.direction == .rtl {
//            leftView = containerView
//            leftViewMode = .always
//        }else {
            rightView = containerView
            rightViewMode = .always
//        }
        
        
        self.padding = (self.direction == .ltr) ? UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 50) : UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 15)
    }
    func sideImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        imageView.frame = containerView.frame
        
//        if self.direction == .rtl {
            rightView = containerView
            rightViewMode = .always
//        }else {
//            leftView = containerView
//            leftViewMode = .always
//        }
        
        
        
    }
    @objc func toggleSecure() {
        self.secureButton.isSelected.toggle()
        self.isSecureTextEntry = !self.secureButton.isSelected
    }
}

/*
 How To use?
 
 The viewController should be the confirm "DropDownTextFieldDelegate" protocol
 */
protocol DropDownItem {
    var id: String { get }
    var name: String { get }
}

protocol DropDownTextFieldDelegate {
    func dropDownList(for textField: UITextField) -> [DropDownItem]
    func didSelect(item: DropDownItem, for textField: UITextField)
    
}

class DropDownTextField: MGFloatingTextField {
    
    //MARK: - Properties -
    private lazy var picker = UIPickerView()
    private var items: [DropDownItem] = []
    private var selectedItem: DropDownItem?
    var dropDownDelegate: DropDownTextFieldDelegate?
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.delete(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDesign()
    }
    
    private func setupDesign() {
        self.picker.delegate = self
        self.inputView = picker
        self.inputView?.clipsToBounds = true
        tintColor = Theme.colors.whiteColor
        self.addDoneButtonOnKeyboard()
    }
    
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.tintColor = Theme.colors.whiteColor
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        guard let selectedItem = self.selectedItem else {
            if let item = self.items.first {
                self.text = item.name
                self.dropDownDelegate?.didSelect(item: item, for: self)
            }
            self.resignFirstResponder()
            return
        }
        self.text = selectedItem.name
        self.dropDownDelegate?.didSelect(item: selectedItem, for: self)
        self.resignFirstResponder()
    }
    
}
extension DropDownTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.items = self.dropDownDelegate?.dropDownList(for: self) ?? []
        return self.items.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.items[row].name, attributes: [NSAttributedString.Key.foregroundColor: Theme.colors.whiteColor])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < self.items.count else {return}
        self.selectedItem = self.items[row]
//        self.doneButtonAction()
    }
}
