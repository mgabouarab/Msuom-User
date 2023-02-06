//
//  ForgetPasswordVC.swift
//
//  Created by MGAbouarab®.
//


import UIKit

class ForgetPasswordVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet private weak var credentialTextField: PhoneTextFieldView!
    
    //MARK: - Properties -
    private var credential: String?
    
    //MARK: - Creation -
    static func create(credential: String?) -> ForgetPasswordVC {
        let vc = AppStoryboards.auth.instantiate(ForgetPasswordVC.self)
        vc.credential = credential
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.stackView.animateToTop()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "Forget Password".localized
        self.credentialTextField.set(text: self.credential)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func continueButtonPressed() {
        do {
            let credential = try self.credentialTextField.phoneText()
            let countryKey = try self.credentialTextField.countryCodeText()
            self.forgetPassword(for: credential, countryKey: countryKey)
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
}


//MARK: - Networking -
extension ForgetPasswordVC {
    private func forgetPassword(for credential: String, countryKey: String) {
        self.showIndicator()

        AuthRouter.forgetPassword(credential: credential, countryKey: countryKey).send { [weak self] (response: APIGlobalResponse) in

            guard let self = self else {return}

            self.goToVerificationCode(with: credential, countryKey: countryKey)
            
        }
    }
}

//MARK: - Routes -
extension ForgetPasswordVC {
    func goToVerificationCode(with credential: String, countryKey: String) {
        let vc = ResetPasswordVC.create(credential: credential, countryKey: countryKey)
        self.push(vc)
    }
}
