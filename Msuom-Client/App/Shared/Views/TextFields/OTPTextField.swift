//
//  OTPTextField.swift
//
//  Created by MGAbouarab®.
//

import UIKit


class OTPTextField: UITextField, UITextFieldDelegate {
    var didEnterLastDigit: ((String) -> Void)?
    var defaultText = ""
    
    @IBInspectable var activeBackground: UIColor = Theme.colors.whiteColor
    @IBInspectable var inActiveBackground: UIColor = Theme.colors.whiteColor
    
    @IBInspectable var borderActive: UIColor = Theme.colors.mainColor
    @IBInspectable var borderInActive: UIColor = UIColor(cgColor: Theme.colors.borderColor)
    
    @IBInspectable var slotTextColor: UIColor = Theme.colors.mainDarkFontColor
    
    
    private var isConfigure = false
    private var digitalLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        return tap
    }()
    
    func configure(with slotsCount: Int = 6) {
        guard !isConfigure else {return}
        isConfigure.toggle()
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotsCount)
        addSubview(labelsStackView)
        addGestureRecognizer(tapRecognizer)
        NSLayoutConstraint.activate(
            [
                labelsStackView.topAnchor.constraint(equalTo: topAnchor),
                labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                labelsStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        )
        
    }
    
    private func configureTextField () {
        tintColor = .clear
        textColor = .clear
        backgroundColor = .clear
        borderStyle = .none
        keyboardType = .asciiCapableNumberPad
        textContentType = .oneTimeCode
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = . fillEqually
        stackView.spacing = 8
        stackView.semanticContentAttribute = .forceLeftToRight
        
        for _ in 1 ... count {
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 30)
            label.isUserInteractionEnabled = true
            label.text = defaultText
            label.layer.cornerRadius = 10
            label.backgroundColor = inActiveBackground
            label.layer.borderWidth = 1
            label.layer.borderColor = borderInActive.cgColor
            label.clipsToBounds = true
            label.textColor = slotTextColor
            
            stackView.addArrangedSubview(label)
            let width = (bounds.width - stackView.spacing * CGFloat(count - 1)) / CGFloat(count)
            label.widthAnchor.constraint(equalToConstant: width).isActive = true
            
            digitalLabels.append(label)
        }
        
        return stackView
    }
    @objc private func textDidChange() {
        guard let text = self.text, text.count <= digitalLabels.count else {return}
        for i in 0 ..< digitalLabels.count {
            let currentLabel = digitalLabels[i]
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
                currentLabel.layer.borderColor = borderActive.cgColor
                currentLabel.backgroundColor = activeBackground
            } else {
                currentLabel.text = defaultText
                currentLabel.layer.borderColor = borderInActive.cgColor
                currentLabel.backgroundColor = inActiveBackground
            }
        }
        if text.count == digitalLabels.count {
            didEnterLastDigit?(text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else {
            return false
        }
        
        return characterCount < digitalLabels.count || string == ""
    }
    
}
