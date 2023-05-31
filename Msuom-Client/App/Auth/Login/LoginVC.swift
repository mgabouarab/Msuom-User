//
//  LoginVC.swift
//
//  Created by MGAbouarab®.
//


import UIKit

class LoginVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet private weak var credentialTextField: PhoneTextFieldView!
    @IBOutlet private weak var passwordTextField: PasswordTextFieldView!
    
    //MARK: - Properties -
    
    
    //MARK: - Creation -
    static func create() -> LoginVC {
        let vc = AppStoryboards.auth.instantiate(LoginVC.self)
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
        self.title = "Login".localized
        self.navigationController?.hideHairline()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func forgetPassword() {
        self.goToForgetPassword()
    }
    @IBAction private func loginButtonPressed() {
        do {
            let credential = try credentialTextField.phoneText()
            let countryKey = try credentialTextField.countryCodeText()
            let password = try passwordTextField.passwordText(for: .password)
            self.loginWith(countryKey, credential, password)
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    @IBAction private func registerButtonPressed() {
        let vc = RegisterVC.create()
        self.push(vc)
    }
    @IBAction private func visitorButtonPressed() {
        self.dismiss(animated: true)
    }
    
}


//MARK: - Networking -
extension LoginVC {
    private func loginWith(_ countryKey: String?, _ credential: String, _ password: String) {
        
        self.showIndicator()

        AuthRouter.login(credential: credential, password: password, countryKey: countryKey).send { [weak self] (response: APIGenericResponse<User>) in

            guard let self = self, let user = response.data else {return}

            UserDefaults.user = user
            UserDefaults.accessToken = user.token
            UserDefaults.isLogin = true
            self.goToHome()
            
        }
        
    }
}

//MARK: - Routes -
extension LoginVC {
    private func goToForgetPassword() {
        let vc = ForgetPasswordVC.create(credential: self.credentialTextField.phoneTextValue())
        self.push(vc)
    }
    private func goToHome() {
        self.dismiss(animated: true)
    }
}
