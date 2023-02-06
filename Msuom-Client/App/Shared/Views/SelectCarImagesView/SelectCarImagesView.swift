//
//  SelectCarImagesView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 19/11/2022.
//

import UIKit

class SelectCarImagesView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var frontImageView: BorderedImageView!
    @IBOutlet weak private var backImageView: BorderedImageView!
    @IBOutlet weak private var leftImageView: BorderedImageView!
    @IBOutlet weak private var rightImageView: BorderedImageView!
    @IBOutlet weak private var insideImageView: BorderedImageView!
    
    //MARK: - Proprieties -
    private var frontImageData: Data?
    private var backImageData: Data?
    private var leftImageData: Data?
    private var rightImageData: Data?
    private var insideImageData: Data?
    
    
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
        let nib = UINib(nibName: "SelectCarImagesView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        
    }
    
    //MARK: - Logic Methods -
    /// for getting images in add case
    func validateFrontImage() throws -> Data {
        guard let frontImageData else {
            throw CarImagesError.front
        }
        return frontImageData
    }
    func validateBackImage() throws -> Data {
        guard let backImageData else {
            throw CarImagesError.back
        }
        return backImageData
    }
    func validateLeftImage() throws -> Data {
        guard let leftImageData else {
            throw CarImagesError.left
        }
        return leftImageData
    }
    func validateRightImage() throws -> Data {
        guard let rightImageData else {
            throw CarImagesError.right
        }
        return rightImageData
    }
    func validateInsideImage() throws -> Data {
        guard let insideImageData else {
            throw CarImagesError.inside
        }
        return insideImageData
    }
    
    /// for getting just changed images in edit case
    func frontImage() -> Data? {
        guard let frontImageData else {
            return nil
        }
        return frontImageData
    }
    func backImage() -> Data? {
        guard let backImageData else {
            return nil
        }
        return backImageData
    }
    func leftImage() -> Data? {
        guard let leftImageData else {
            return nil
        }
        return leftImageData
    }
    func rightImage() -> Data? {
        guard let rightImageData else {
            return nil
        }
        return rightImageData
    }
    func insideImage() -> Data? {
        guard let insideImageData else {
            return nil
        }
        return insideImageData
    }
    
    /// for set previous images
    func setFrontImage(with url: String?) {
        self.frontImageView.setWith(string: url)
    }
    func setBackImage(with url: String?) {
        self.backImageView.setWith(string: url)
    }
    func setLeftImage(with url: String?) {
        self.leftImageView.setWith(string: url)
    }
    func setRightImage(with url: String?) {
        self.rightImageView.setWith(string: url)
    }
    func setInsideImage(with url: String?) {
        self.insideImageView.setWith(string: url)
    }
    
    //MARK: - Actions -
    @IBAction private func frontImageViewDidTapped() {
        ImagePicker().pickImage { image, imageData in
            self.frontImageData = imageData
            self.frontImageView.image = image
        }
    }
    @IBAction private func backImageViewDidTapped() {
        ImagePicker().pickImage { image, imageData in
            self.backImageData = imageData
            self.backImageView.image = image
        }
    }
    @IBAction private func leftImageViewDidTapped() {
        ImagePicker().pickImage { image, imageData in
            self.leftImageData = imageData
            self.leftImageView.image = image
        }
    }
    @IBAction private func rightImageViewDidTapped() {
        ImagePicker().pickImage { image, imageData in
            self.rightImageData = imageData
            self.rightImageView.image = image
        }
    }
    @IBAction private func insideImageViewDidTapped() {
        ImagePicker().pickImage { image, imageData in
            self.insideImageData = imageData
            self.insideImageView.image = image
        }
    }
    
    
}


enum CarImagesError: Error {
    case front
    case back
    case left
    case right
    case inside
}
extension CarImagesError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .front:
            return "Please select front image".localized
        case .back:
            return "Please select back image".localized
        case .left:
            return "Please select left image".localized
        case .right:
            return "Please select right image".localized
        case .inside:
            return "Please select inside image".localized
        }
    }
}
