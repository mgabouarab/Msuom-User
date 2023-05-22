//
//  SelectFileView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 13/05/2023.
//

import UIKit

class SelectFileView: TextFieldView {
    
    //MARK: - IBOutlet -
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
    
    private var selectedFileData: Data?
    
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
        let nib = UINib(nibName: "SelectFileView", bundle: bundle)
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
        self.textField.text = "Attached".localized
        UIView.animate(withDuration: 0.2) {
            self.containerView.addBorder(with: self.activeBorderColor)
            self.tintColor = self.activeTintColor
        }
    }
    private func setInactiveState() {
        self.textField.text = nil
        UIView.animate(withDuration: 0.2) {
            self.containerView.addBorder(with: self.inActiveBorderColor)
            self.tintColor = self.inActiveTintColor
        }
    }
    
    //MARK: - Encapsulation -
    func set(file: Data?) {
        guard let file else {
            self.setInactiveState()
            return
        }
        self.selectedFileData = file
        self.setActiveState()
    }
    func value() -> Data? {
        self.selectedFileData
    }
    
}

extension SelectFileView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.endEditing(true)
        self.pickDocument()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.trimWhiteSpace().isEmpty else {
            self.setInactiveState()
            return
        }
        self.setActiveState()
    }
}

extension SelectFileView: UIDocumentPickerDelegate {

    func pickDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.parentContainerViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedFileURL = urls.first {
            do {
                let fileData = try readFile(at: selectedFileURL)
                self.selectedFileData = fileData
                self.setActiveState()
            } catch {
                print("Error reading file: \(error.localizedDescription)")
            }
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func readFile(at url: URL) throws -> Data {
        var data = Data()
        let bufferSize = 1024 * 1024 // 1 MB buffer size
        let inputStream = InputStream(url: url)
        inputStream?.open()
        defer { inputStream?.close() }
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        while inputStream!.hasBytesAvailable {
            let bytesRead = inputStream!.read(&buffer, maxLength: bufferSize)
            if bytesRead > 0 {
                data.append(&buffer, count: bytesRead)
            }
        }
        return data
    }
    
}
