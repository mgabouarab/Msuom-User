//
//  AdvantageAndDisadvantageCell.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 13/05/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class AdvantageAndDisadvantageCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var arabicNameTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var englishNameTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var arabicDescriptionTextView: AppTextView!
    @IBOutlet weak private var englishDescriptionTextView: AppTextView!
    @IBOutlet weak private var deleteView: UIView!
    
    //MARK: - properties -
    var onArabicNameTextChanged: ((String?)->())?
    var onEnglishNameTextChanged: ((String?)->())?
    var onArabicDescriptionChanged: ((String?)->())?
    var onEnglishDescriptionChanged: ((String?)->())?
    var deleteAction: (()->())?
    
    //MARK: - Overriden Methods-
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDesign()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCellData()
    }
    
    //MARK: - Design Methods -
    private func setupDesign() {
        self.selectionStyle = .none
    }
    private func resetCellData() {
        self.onArabicNameTextChanged = nil
        self.onEnglishNameTextChanged = nil
        self.onArabicDescriptionChanged = nil
        self.onEnglishDescriptionChanged = nil
    }
    
    //MARK: - Configure Data -
    func configureWith(data: AdvantageAndDisadvantageModel, hideDeleteAction: Bool) {
        
        self.arabicNameTextFieldView.set(text: data.arabicName)
        self.englishNameTextFieldView.set(text: data.englishName)
        self.arabicDescriptionTextView.set(text: data.arabicDescription)
        self.englishDescriptionTextView.set(text: data.englishDescription)
        self.deleteView.isHidden = hideDeleteAction
        
        self.arabicNameTextFieldView.onChangeTextValue = { [weak self] text in
            guard let self = self else {return}
            self.onArabicNameTextChanged?(text)
        }
        self.englishNameTextFieldView.onChangeTextValue = { [weak self] text in
            guard let self = self else {return}
            self.onEnglishNameTextChanged?(text)
        }
        self.arabicDescriptionTextView.onChangeTextValue = { [weak self] text in
            guard let self = self else {return}
            self.onArabicDescriptionChanged?(text)
        }
        self.englishDescriptionTextView.onChangeTextValue = { [weak self] text in
            guard let self = self else {return}
            self.onEnglishDescriptionChanged?(text)
        }
        
    }
    
    //MARK: - Actions -
    @IBAction private func deleteButtonPressed() {
        self.deleteAction?()
    }
    
}
