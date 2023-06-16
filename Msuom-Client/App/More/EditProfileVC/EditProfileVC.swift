//
//  EditProfileVC.swift
//  Msuom
//
//  Created by MGAbouarab on 02/11/2022.
//
//  Template by MGAbouarab®


import UIKit

class EditProfileVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var phoneTextFieldView: PhoneTextFieldView!
    @IBOutlet weak private var emailTextFieldView: EmailTextFieldView!
    @IBOutlet weak private var nameTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var cityTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var birthdayTextFieldView: DatePickerTextFieldView!
    @IBOutlet weak private var imageView: UIImageView!
    
    //MARK: - Properties -
    private var selectedImageData: Data?
    private var cityArray: [DropDownItem] = []
    
    //MARK: - Creation -
    static func create() -> EditProfileVC {
        let vc = AppStoryboards.more.instantiate(EditProfileVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.addDelegates()
        self.configureInitialData()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Profile".localized)
        let user = UserDefaults.user
        self.nameTextFieldView.set(text: user?.name)
        self.phoneTextFieldView.set(text: user?.phoneNo)
//        self.phoneTextFieldView.set(code: user?.countryKey)
        self.emailTextFieldView.set(text: user?.email)
        self.imageView.setWith(string: user?.avatar)
        
        
        if let id = user?.cityId, let name = user?.cityName {
            struct Item: DropDownItem {
                let id: String
                let name: String
            }
            self.cityTextFieldView.set(value: Item(id: id, name: name))
        }
        
        self.birthdayTextFieldView.set(value: user?.birthday, formate: appDateFormate)
        
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
    @IBAction private func selectImageButtonPressed() {
        ImagePicker().pickImage { image, imageData in
            self.imageView.image = image
            self.selectedImageData = imageData
        }
    }
    @IBAction private func saveButtonPressed() {
        let email = self.emailTextFieldView.emailTextValue() == UserDefaults.user?.email ? nil : self.emailTextFieldView.emailTextValue()
        let name = self.nameTextFieldView.textValue()
        let phone = self.phoneTextFieldView.phoneTextValue() == UserDefaults.user?.phoneNo ? nil : self.phoneTextFieldView.phoneTextValue()
        
        var profileImage: [UploadData]?
        
        if let imageData = self.selectedImageData {
            profileImage = [UploadData(data: imageData, fileName: Date().toString(), mimeType: .jpeg, name: "avatar")]
        }
        
        do {
            let cityId = try CarValidationService.validate(cityId: self.cityTextFieldView.value()?.id)
            let birthday = self.birthdayTextFieldView.value()
            self.editProfile(name: name, phone: phone, countryCode: nil, email: email, image: profileImage, cityId: cityId, birthday: birthday?.apiDateString())
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
        
        
        
    }
    @IBAction private func changePasswordButtonPressed() {
        let vc = ChangePasswordVC.create()
        self.push(vc)
    }
    
}

//MARK: - Networking -
extension EditProfileVC {
    private func editProfile(name: String?, phone: String?, countryCode: String?, email: String?, image: [UploadData]?, cityId: String?, birthday: String?) {
        self.showIndicator()
        AuthRouter.updateProfile(name: name, phone: phone, email: email, countryCode: countryCode, cityId: cityId, birthday: birthday).send(data: image) { [weak self] (response: APIGenericResponse<User>) in
            guard let self = self else {return}
            switch response.key {
                
            case .success:
                self.showSuccessAlert(message: response.message)
                UserDefaults.user = response.data
                if let token = response.data?.token, !token.trimWhiteSpace().isEmpty {
                    UserDefaults.accessToken = token
                }
                self.pop()
            case .fail:
                self.showErrorAlert(error: response.message)
            case .unauthenticated, .needActive, .exception, .blocked:
                return
            }
            
        }
    }
    private func getAttributes() {
        self.showIndicator()
        CarRouter.addCarData.send { [weak self] (response: APIGenericResponse<AddCarData>) in
            guard let self = self else {return}
            self.hideIndicator()
            UserDefaults.addCarData = response.data
            self.configureInitialData()
        }
    }
}

//MARK: - Routes -
extension EditProfileVC {
    
}

//MARK: - Delegate -
extension EditProfileVC: DropDownTextFieldViewDelegate {
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
        case cityTextFieldView: return self.cityArray
        default: return []
        }
    }
    func didSelect(item: DropDownItem, for textFieldView: DropDownTextFieldView) {
        
    }
}
