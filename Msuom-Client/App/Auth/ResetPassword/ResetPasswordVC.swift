//
//  ResetPasswordVC.swift
//
//  Created by MGAbouarab®.
//


import UIKit

class ResetPasswordVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var newPasswordTextField: PasswordTextFieldView!
    @IBOutlet weak private var confirmNewPasswordTextField: PasswordTextFieldView!
    @IBOutlet weak private var verificationCodeTextFieldView: NormalTextFieldView!
    
    //MARK: - Properties -
    var credential: String!
    var countryKey: String!
    
    //MARK: - Creation -
    static func create(credential: String, countryKey: String) -> ResetPasswordVC {
        let vc = AppStoryboards.auth.instantiate(ResetPasswordVC.self)
        vc.credential = credential
        vc.countryKey = countryKey
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
        self.title = "".localized
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func resetButtonPressed() {
        do {
            let code = try ValidationService.validate(verificationCode: self.verificationCodeTextFieldView.textValue())
            let newPassword = try self.newPasswordTextField.passwordText(for: .newPassword)
            let _ = try self.confirmNewPasswordTextField.passwordText(for: .confirmNewPassword(password: newPassword))
            
            self.resetPassword(code: code, credential: self.credential, password: newPassword, countryKey: self.countryKey)
            
            
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
}


//MARK: - Networking -
extension ResetPasswordVC {
    private func resetPassword(code: String, credential: String, password: String, countryKey: String) {
        self.showIndicator()

        AuthRouter.resetPassword(code: code, credential: credential, password: password, countryKey: countryKey).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.goToLogin()
        }
    }
}

//MARK: - Routes -
extension ResetPasswordVC {
    private func goToLogin() {
        self.popToRoot()
    }
}
