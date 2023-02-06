//
//  FQACell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/01/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit

//MARK: - UITableViewCell -
class FQACell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var plusMinusImageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var answerLabel: UILabel!
    
    //MARK: - properties -
    
    
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
        self.questionLabel.text = nil
        self.answerLabel.text = nil
        self.answerLabel.isHidden = true
    }
    
    //MARK: - Configure Data -
    func configureWith(data: FQAModel) {
        self.questionLabel.text = data.question
        self.answerLabel.text = data.answer
        if data.isOpen == true {
            self.answerLabel.isHidden = false
            self.plusMinusImageView.image = UIImage(named: "minus")
        } else {
            self.answerLabel.isHidden = true
            self.plusMinusImageView.image = UIImage(named: "plus")
        }
    }
    
    //MARK: - Actions -
    
    
}
