//
//  RegisterVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 23/01/2023.
//

import UIKit

class RegisterVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var nameTextField: NormalTextFieldView!
    @IBOutlet weak private var phoneTextField: PhoneTextFieldView!
    @IBOutlet weak private var emailTextField: EmailTextFieldView!
    @IBOutlet weak private var passwordTextField: PasswordTextFieldView!
    @IBOutlet weak private var userImageView: UIImageView!
    @IBOutlet weak private var cityTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var birthdayTextFieldView: DatePickerTextFieldView!
    
    //MARK: - Properties -
    private var selectedImage: Data?
    private var cityArray: [DropDownItem] = []
    
    //MARK: - Creation -
    static func create() -> RegisterVC {
        let vc = AppStoryboards.auth.instantiate(RegisterVC.self)
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.configureInitialData()
        self.stackView.animateToTop()
        self.addDelegates()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "Register".localized
        self.birthdayTextFieldView.mode = .date(minimum: nil, maximum: Date())
    }
    private func configureInitialData() {
        
        if let data = UserDefaults.addCarData {
            self.cityArray = data.cities
        } else {
            self.getAttributes()
        }
        
    }
    
    //MARK: - Logic Methods -
    private func addDelegates() {
        self.cityTextFieldView.delegate = self
    }
    
    //MARK: - Actions -
    @IBAction private func changeImageButtonPressed() {
        
        ImagePicker().pickImage { [weak self] (image, imageData) in
            guard let self = self else {return}
            self.userImageView.image = image
            self.selectedImage = imageData
        }
    }
    @IBAction private func registerButtonPressed() {
        do {
            
            let name = try ValidationService.validate(name: self.nameTextField.textValue())
            let phone = try self.phoneTextField.phoneText()
            let countryKey = try self.phoneTextField.countryCodeText()
            let email = try self.emailTextField.emailText()
            let password = try passwordTextField.passwordText(for: .newPassword)
            let cityId = try CarValidationService.validate(cityId: self.cityTextFieldView.value()?.id)
            let birthday = try ValidationService.validate(birthday: self.birthdayTextFieldView.value())
            var uploads: [UploadData]?
            
            if let selectedImage {
                uploads = [
                    UploadData(data: selectedImage, fileName: Date().toString(), mimeType: .jpeg, name: "avatar")
                ]
            }
            
            self.registerWith(name, countryKey, phone, email, password, uploads, cityId, birthday.apiDateString())
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    @IBAction private func loginButtonPressed() {
        self.popToRoot()
    }
    
}


//MARK: - Networking -
extension RegisterVC {
    private func getAttributes() {
        self.showIndicator()
        CarRouter.addCarData.send { [weak self] (response: APIGenericResponse<AddCarData>) in
            guard let self = self else {return}
            self.hideIndicator()
            UserDefaults.addCarData = response.data
            self.configureInitialData()
        }
    }
    private func registerWith(_ name: String, _ countryKey: String, _ phone: String, _ email: String, _ password: String, _ data: [UploadData]?, _ cityId: String, _ birthday: String?) {
        self.showIndicator()
        
        AuthRouter.registerWith(name: name, phone: phone, email: email, password: password, countryKey: countryKey, cityId: cityId, birthday: birthday).send(data: data) { [weak self] (response: APIGenericResponse<User>) in
            
            guard let self = self else {return}
            
            UserDefaults.accessToken = response.data?.token
            UserDefaults.user = response.data
            
            self.goToVerificationCode(with: phone, countryKey: countryKey)
            
        }
    }
}

//MARK: - Routes -
extension RegisterVC {
    func goToVerificationCode(with credential: String, countryKey: String) {
        let vc = VerificationCodeVC.create(credential: credential, type: .activation, countryKey: countryKey)
        self.push(vc)
    }
}


//MARK: - Delegate -
extension RegisterVC: DropDownTextFieldViewDelegate {
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
        case cityTextFieldView: return self.cityArray
        default: return []
        }
    }
    func didSelect(item: DropDownItem, for textFieldView: DropDownTextFieldView) {
        
    }
}


//MARK: - Medical Station -> Done
//MARK: - JM -> Done
//MARK: - MASKAN -> DisplayName
//MARK: - LOH -> Done
