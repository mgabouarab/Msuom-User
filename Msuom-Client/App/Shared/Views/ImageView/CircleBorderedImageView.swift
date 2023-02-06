//
//  CircleBorderedImageView.swift
//  Msuom
//
//  Created by MGAbouarab on 25/10/2022.
//

import UIKit

class BorderedImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var enableViewer: Bool = false
    @IBInspectable var isCircle: Bool = false
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.handleGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        self.handleGesture()
    }
    
    override func layoutSubviews() {
        if isCircle {
            layer.cornerRadius = bounds.height / 2
        }
    }
    
    private func setupView() {
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    private func handleGesture() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapped))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func didTapped() {
        guard enableViewer, let imageData = self.image?.pngData() else {return}
        let vc = ImageViewerVC.create(images: [ImageViewerItem(urlImage: nil, dataImage: imageData)])
        self.parentContainerViewController?.present(vc, animated: true)
    }
    
}

class CircleBorderedImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var enableViewer: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.handleGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        self.handleGesture()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupView() {
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    private func handleGesture() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapped))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func didTapped() {
        guard enableViewer, let imageData = self.image?.pngData() else {return}
        let vc = ImageViewerVC.create(images: [ImageViewerItem(urlImage: nil, dataImage: imageData)])
        self.parentContainerViewController?.present(vc, animated: true)
    }
    
}

