//
//  OfferDetailsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 31/01/2023.
//
//  Template by MGAbouarab®


import UIKit

class OfferDetailsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var offerImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var companyImageView: UIImageView!
    @IBOutlet weak private var companyNameLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet weak private var callView: UIView!
    @IBOutlet weak private var faceView: UIView!
    @IBOutlet weak private var twitterView: UIView!
    @IBOutlet weak private var whatsAppView: UIView!
    
    //MARK: - Properties -
    private var offer: OfferModel!
    
    //MARK: - Creation -
    static func create(offer: OfferModel) -> OfferDetailsVC {
        let vc = AppStoryboards.more.instantiate(OfferDetailsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.offer = offer
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.addTaps()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Offer Details".localized)
        
        self.offerImageView.setWith(string: self.offer.offer.image)
        self.titleLabel.text = self.offer.offer.title
        self.companyImageView.setWith(string: self.offer.provider.image)
        self.companyNameLabel.text = self.offer.provider.name
        self.dateLabel.text = self.offer.offer.available?.htmlToAttributedString?.string
        self.textView.text = self.offer.offer.description
        
    }
    private func addTaps() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.callViewTapped))
        self.callView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.faceViewTapped))
        self.faceView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.twitterViewTapped))
        self.twitterView.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.whatsAppViewTapped))
        self.whatsAppView.addGestureRecognizer(tap4)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc private func callViewTapped() {
        PhoneAction.call(number: self.offer.provider.phoneNo)
    }
    @objc private func faceViewTapped() {
        AppHelper.openUrl(self.offer.offer.faceBook)
    }
    @objc private func twitterViewTapped() {
        AppHelper.openUrl(self.offer.offer.twitter)
    }
    @objc private func whatsAppViewTapped() {
        guard let whatsApp = self.offer.offer.whats else {return}
        PhoneAction.open(whatsApp: whatsApp)
    }
    
}


//MARK: - Networking -
extension OfferDetailsVC {
    
}

//MARK: - Routes -
extension OfferDetailsVC {
    
}
