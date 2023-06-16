//
//  ContactUsVC.swift
//  Msuom
//
//  Created by MGAbouarab on 02/11/2022.
//
//  Template by MGAbouarab®


import UIKit

class ContactUsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var nameTextFieldView: NormalTextFieldView!
    @IBOutlet weak var phoneTextFieldView: PhoneTextFieldView!
    @IBOutlet weak var messageTextView: AppTextView!
    
    //MARK: - Properties -
    var bidId: String?
    var disputeId: String?
    
    //MARK: - Creation -
    static func create(bidId: String? = nil, disputeId: String? = nil) -> ContactUsVC {
        let vc = AppStoryboards.more.instantiate(ContactUsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.bidId = bidId
        vc.disputeId = disputeId
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Contact us".localized)
        self.phoneTextFieldView.set(text: UserDefaults.user?.phoneNo)
//        self.phoneTextFieldView.set(code: UserDefaults.user?.countryKey)
        self.nameTextFieldView.set(text: UserDefaults.user?.name)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func sendButtonPressed() {
        do {
            let phone = try self.phoneTextFieldView.phoneText()
            let countryCode = try self.phoneTextFieldView.countryCodeText()
            let name = try ValidationService.validate(name: self.nameTextFieldView.textValue())
            let message = try ValidationService.validate(message: self.messageTextView.textValue())
            self.contactWith(phone: phone, countryCode: countryCode, name: name, message: message)
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    
}


//MARK: - Networking -
extension ContactUsVC {
    private func contactWith(phone: String, countryCode: String, name: String, message: String) {
        self.showIndicator()
        AuthRouter.contactUs(name: name, phone: phone, message: message, countryKey: countryCode, bidId: self.bidId, disputeId: self.disputeId).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.pop()
        }
    }
}

//MARK: - Routes -
extension ContactUsVC {
    
}
