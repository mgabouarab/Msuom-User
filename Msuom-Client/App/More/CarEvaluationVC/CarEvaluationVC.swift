//
//  CarEvaluationVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/01/2023.
//
//  Template by MGAbouarab®


import UIKit

final class CarEvaluationVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var brandTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var typeTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var classTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var statusTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var walkwayTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var evaluateLabel: UILabel!
    @IBOutlet weak private var chargeLabel: UILabel!
    @IBOutlet weak private var whatsAppLabel: UILabel!
    @IBOutlet weak private var phoneLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var addressTextFieldView: NormalTextFieldView!
    
    //MARK: - Properties -
    private var brandArray: [DropDownItem] = []
    private var typeArray: [DropDownItem] = []
    private var classArray: [DropDownItem] = []
    private var statusArray: [DropDownItem] = []
    
    //MARK: - Creation -
    static func create() -> CarEvaluationVC {
        let vc = AppStoryboards.cars.instantiate(CarEvaluationVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.configureInitialData()
        self.addDelegates()
        self.addGestures()
        self.getDataUsedForEvaluation()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.scrollView.alpha = 0
        self.addBackButtonWith(title: "Car Evaluation".localized)
    }
    
    //MARK: - Logic Methods -
    private func configureInitialData() {
        
        if let data = UserDefaults.addCarData {
            self.brandArray = data.carBrands
            self.typeArray = []
            self.classArray = data.carCategories
            self.statusArray = data.carStatus
        } else {
            self.getAttributes()
        }
        
    }
    private func addDelegates() {
        
        self.brandTextFieldView.delegate = self
        self.typeTextFieldView.delegate = self
        self.classTextFieldView.delegate = self
        self.statusTextFieldView.delegate = self
        
    }
    private func addGestures() {
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.whatsAppLabelTapped))
        self.whatsAppLabel.isUserInteractionEnabled = true
        self.whatsAppLabel.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.phoneLabelTapped))
        self.phoneLabel.isUserInteractionEnabled = true
        self.phoneLabel.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.emailLabelTapped))
        self.emailLabel.isUserInteractionEnabled = true
        self.emailLabel.addGestureRecognizer(tap3)
        
    }
    
    //MARK: - Actions -
    @objc private func whatsAppLabelTapped() {
        PhoneAction.open(whatsApp: self.whatsAppLabel.text ?? "")
    }
    @objc private func phoneLabelTapped() {
        PhoneAction.call(number: self.phoneLabel.text)
    }
    @objc private func emailLabelTapped() {
        guard let email = self.emailLabel.text, email.isValidEmail() else {return}
        Emailer().sendMail(body: "", recipients: [email])
    }
    
    @IBAction private func generalButtonPressed() {
        do {
            let brandId = try CarValidationService.validate(brandId: self.brandTextFieldView.value()?.id)
            let typeId = try CarValidationService.validate(typeId: self.typeTextFieldView.value()?.id)
            let classId = try CarValidationService.validate(classId: self.classTextFieldView.value()?.id)
            let statusId = try CarValidationService.validate(statusId: self.statusTextFieldView.value()?.id)
            let walkway = try CarValidationService.validate(walkway: self.walkwayTextFieldView.textValue())
            let address = try ValidationService.validate(addressDetails: self.addressTextFieldView.textValue())
            
            
            self.carEvaluation(
                brandId: brandId,
                typeId: typeId,
                categoryId: classId,
                statusId: statusId,
                walkway: walkway,
                type: "general",
                address: address
            )
            
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    @IBAction private func certificateButtonPressed() {
        do {
            let brandId = try CarValidationService.validate(brandId: self.brandTextFieldView.value()?.id)
            let typeId = try CarValidationService.validate(typeId: self.typeTextFieldView.value()?.id)
            let classId = try CarValidationService.validate(classId: self.classTextFieldView.value()?.id)
            let statusId = try CarValidationService.validate(statusId: self.statusTextFieldView.value()?.id)
            let walkway = try CarValidationService.validate(walkway: self.walkwayTextFieldView.textValue())
            let address = try ValidationService.validate(addressDetails: self.addressTextFieldView.textValue())
            
            self.carEvaluation(
                brandId: brandId,
                typeId: typeId,
                categoryId: classId,
                statusId: statusId,
                walkway: walkway,
                type: "certified",
                address: address
            )
            
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    
    
}


//MARK: - Networking -
extension CarEvaluationVC {
    private func carEvaluation(brandId: String, typeId: String, categoryId: String, statusId: String, walkway: String, type: String, address: String) {
        self.showIndicator()
        MoreRouter.carEvaluation(brandId: brandId, typeId: typeId, categoryId: categoryId, statusId: statusId, walkway: walkway, type: type, address: address).send { [weak self] (response: APIGenericResponse<CarEvaluationResultModel>) in
            guard let self = self else {return}
            if let data = response.data, type == "general", data.result != nil {
                let vc = CarEvaluationResultVC.create(result: data, evaluateDescription: self.evaluateLabel.text)
                self.push(vc)
            } else if type == "certified" {
                let vc = SuccessEvaluationVC.create(delegate: self)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            self.showSuccessAlert(message: response.message)
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
    private func getDataUsedForEvaluation() {
        self.showIndicator()
        MoreRouter.dataUsedForEvaluation.send { [weak self] (response: APIGenericResponse<CarEvaluationModel>) in
            guard let self = self else {return}
            self.evaluateLabel.text = response.data?.carPreview
            self.chargeLabel.text = response.data?.shippingServices
            self.whatsAppLabel.text = response.data?.phoneNoWhats
            self.phoneLabel.text = response.data?.phoneNo
            self.emailLabel.text = response.data?.email
            UIView.animate(withDuration: 0.2, delay: 0) {
                self.scrollView.alpha = 1
            }
        }
    }
}

//MARK: - Routes -
extension CarEvaluationVC: SuccessEvaluationDelegate {
    func goToHome() {
        self.tabBarController?.selectedIndex = 0
        self.popToRoot()
    }
    func goToOrders() {
        self.tabBarController?.selectedIndex = 3
        self.popToRoot()
    }
}

//MARK: - Delegate -
extension CarEvaluationVC: DropDownTextFieldViewDelegate {
    
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
        case brandTextFieldView: return self.brandArray
        case typeTextFieldView: return self.typeArray
        case classTextFieldView: return self.classArray
        case statusTextFieldView: return self.statusArray
        default: return []
        }
    }
    
    func didSelect(item: DropDownItem, for textFieldView: DropDownTextFieldView) {
        switch textFieldView {
        case brandTextFieldView:
            self.typeTextFieldView.set(value: nil)
            if let brand = item as? CarBrandModel {
                self.typeArray = brand.carTypes
            }
            return
        default:
            return
        }
    }
    
}

