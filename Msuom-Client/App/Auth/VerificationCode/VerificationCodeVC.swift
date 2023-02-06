//
//  VerificationCodeVC.swift
//
//  Created by MGAbouarab®.
//


import UIKit

class VerificationCodeVC: BaseVC {
    
    
    enum VerificationType {
        case activation
        case activationInsideApp(isAuth: Bool)
        case forgetPassword
    }
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var codeTextField: NormalTextFieldView!
    @IBOutlet weak private var resendView: UIView!
    @IBOutlet weak private var timerLabel: UILabel!
    @IBOutlet weak private var timerStack: UIStackView!
    
    //MARK: - Properties -
    weak private var timer: Timer?
    private var count = 59
    private var credential: String!
    private var countryKey: String!
    private var type: VerificationType = .activation
    
    //MARK: - Creation -
    static func create(credential: String, type: VerificationType, countryKey: String) -> VerificationCodeVC {
        let vc = AppStoryboards.auth.instantiate(VerificationCodeVC.self)
        vc.credential = credential
        vc.type = type
        vc.countryKey = countryKey
        return vc
    }
    
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.stackView.animateToTop()
        self.startTimer()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "Activation code".localized
    }
    
    //MARK: - Logic Methods -
    private func startTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else {return}
            if self.count == 0 {
                self.count = 59
                self.timer?.invalidate()
                self.timer = nil
                self.resendView.isHidden = false
                self.timerStack.isHidden = true
                return
            }
            self.count -= 1
            let time = "00:\(String(format: "%02d", self.count))"
            self.timerLabel.text = time
        })
    }
    
    //MARK: - Actions -
    @IBAction private func verifyButtonPressed() {
        do {
            
            let code = try ValidationService.validate(verificationCode: self.codeTextField.textValue())
            
            
            
            
            switch self.type {
            case .activation, .activationInsideApp:
                self.verify(code, for: credential, countryKey: countryKey)
            case .forgetPassword:
                self.forgetPassword(code, for: credential, countryKey: countryKey)
            }
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    @IBAction private func resendButtonPressed() {
        self.showIndicator()
//        AuthRouter.codeResend(credential: credential, countryKey: countryKey).send { [weak self] (response: APIGlobalResponse) in
//            guard let self = self else {return}
//            self.showSuccessAlert(message: response.message)
            self.startTimer()
            self.resendView.isHidden = true
            self.timerStack.isHidden = false
//        }
    }
    
}


//MARK: - Networking -
extension VerificationCodeVC {
    
    private func forgetPassword(_ code: String, for credential: String, countryKey: String) {
//        self.showIndicator()
//
//        AuthRouter.forgetPasswordCode(code, credential: credential, countryKey: countryKey).send { [weak self] (response: APIGlobalResponse) in
//
//            guard let self = self else {return}
            
            self.goToResetPassword(code: code, for: credential, countryKey: countryKey)
            
//        }
    }
    
    private func verify(_ code: String, for credential: String, countryKey: String) {
        self.showIndicator()
        AuthRouter.verify(code: code, credential: credential, countryKey: countryKey).send { [weak self] (response: APIGenericResponse<User>) in
            
            guard let self = self, let token = response.data?.token, let user = response.data else {return}
            
            
            switch self.type {
                
            case .activation:
                UserDefaults.isLogin = true
                UserDefaults.user = user
                UserDefaults.accessToken = token
                self.dismiss(animated: true)
            case .activationInsideApp(let isAuth):
                UserDefaults.user = user
                UserDefaults.accessToken = token
                if isAuth {
                    self.dismiss(animated: true)
                    UserDefaults.isLogin = true
                }
                self.pop()
            case .forgetPassword:
                return
            }
            
            
        }
        
    }
    
    
}

//MARK: - Routes -
extension VerificationCodeVC {
    func goToResetPassword(code: String, for credential: String, countryKey: String) {
        let vc = ResetPasswordVC.create(credential: credential, countryKey: countryKey)
        self.push(vc)
    }
}
