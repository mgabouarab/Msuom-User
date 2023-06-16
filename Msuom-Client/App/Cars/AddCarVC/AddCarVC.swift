//
//  AddCarVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 18/11/2022.
//
//  Template by MGAbouarab®


import UIKit

class AddCarVC: BaseVC {
    
    enum OperationType {
        case add
        case edit(car: Car)
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var imagesView: SelectCarImagesView!
    @IBOutlet weak private var priceTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var brandTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var typeTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var classTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var yearTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var specificationsTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var incomingTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var colorTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var driveTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var fuelTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var asphaltTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var statusTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var cylindersTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var engineTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var howToSellTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var walkwayTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var cityTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var descriptionTextView: AppTextView!
    @IBOutlet weak private var descriptionArTextView: AppTextView!
    @IBOutlet weak private var notRefundableButton: UIButton!
    @IBOutlet weak private var refundableButton: UIButton!
    @IBOutlet weak private var notRefundableView: UIView!
    @IBOutlet weak private var refundableView: UIView!
    @IBOutlet weak private var actionButton: UIButton!
    
    //MARK: - Properties -
    private var operationType: OperationType = .add
    private var isRefundable: Bool = false
    private var brandArray: [DropDownItem] = []
    private var typeArray: [DropDownItem] = []
    private var classArray: [DropDownItem] = []
    private var specificationsArray: [DropDownItem] = []
    private var incomingArray: [DropDownItem] = []
    private var colorArray: [DropDownItem] = []
    private var driveArray: [DropDownItem] = []
    private var fuelArray: [DropDownItem] = []
    private var asphaltArray: [DropDownItem] = []
    private var statusArray: [DropDownItem] = []
    private var howToSellArray: [DropDownItem] = []
    private var cityArray: [DropDownItem] = []
    private var years: [DropDownItem] = []
    
    //MARK: - Creation -
    static func create(operationType: OperationType = .add) -> AddCarVC {
        let vc = AppStoryboards.cars.instantiate(AddCarVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.operationType = operationType
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.configureInitialData()
        self.addDelegates()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        
        switch self.operationType {
        case .add:
            self.addDismissibleBackButtonWith(title: "Add Car".localized)
        case .edit:
            self.addBackButtonWith(title: "Edit Car".localized)
            self.actionButton.setTitle("Edit".localized, for: .normal)
        }
        
        let notRefundableTap = UITapGestureRecognizer(target: self, action: #selector(self.notRefundableTapped))
        self.notRefundableView.addGestureRecognizer(notRefundableTap)
        let refundableTap = UITapGestureRecognizer(target: self, action: #selector(self.refundableTapped))
        self.refundableView.addGestureRecognizer(refundableTap)
        
        struct Item: DropDownItem {
            var id: String
            var name: String
        }
        let year = Calendar.current.component(.year, from: Date())
        years = Array(year-40 ... year).reversed().map({Item(id: "\($0)", name: "\($0)")})
        
        
    }
    
    func addDismissibleBackButtonWith(title: String) {
        let button = UIButton()
        button.setImage(UIImage(named: "backArrow"), for: .normal)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = Theme.colors.whiteColor
        button.isUserInteractionEnabled = false
        let stack = UIStackView.init(arrangedSubviews: [button, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissibleBackButtonPressed))
        stack.addGestureRecognizer(tap)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stack)
    }
    @objc private func dismissibleBackButtonPressed() {
        self.dismiss(animated: true)
    }
    
    
    
    
    
    private func configureInitialData() {
        
        if let data = UserDefaults.addCarData {
            self.brandArray = data.carBrands
            self.typeArray = []
            self.classArray = data.carCategories
            self.specificationsArray = data.specifications
            self.incomingArray = data.importedCars
            self.colorArray = data.colors
            self.driveArray = data.vehicleTypes
            self.fuelArray = data.fuelTypes
            self.asphaltArray = data.transmissionGears
            self.statusArray = data.carStatus
            self.howToSellArray = data.sellTypes
            self.cityArray = data.cities
        } else {
            self.getAttributes()
        }
        switch self.operationType {
        case .add:
            break
        case .edit(let car):
            
            struct Item: DropDownItem {
                var id: String
                var name: String
            }
            
            if let id = car.details.brandId, let name = car.details.brandName {
                self.brandTextFieldView.set(value: Item(id: id, name: name))
                if let types = UserDefaults.addCarData?.carBrands.first(where: {$0.id == id})?.carTypes {
                    self.typeArray = types
                }
            }
            if let id = car.details.typeId, let name = car.details.typeName {
                self.typeTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.categoryId, let name = car.details.categoryName {
                self.classTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.specificationId, let name = car.details.specificationName {
                self.specificationsTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.importedCarId, let name = car.details.importedCarName {
                self.incomingTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.colorId, let name = car.details.colorName {
                self.colorTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.vehicleTypeId, let name = car.details.vehicleTypeName {
                self.driveTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.fuelTypeId, let name = car.details.fuelTypeName {
                self.fuelTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.transmissionGearId, let name = car.details.transmissionGearName {
                self.asphaltTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.statusId, let name = car.details.statusName {
                self.statusTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.sellTypeId, let name = car.details.sellTypeName {
                self.howToSellTextFieldView.set(value: Item(id: id, name: name))
            }
            if let id = car.details.cityId, let name = car.details.cityName {
                self.cityTextFieldView.set(value: Item(id: id, name: name))
            }
            if let year = car.details.year {
                self.yearTextFieldView.set(value: Item(id: year, name: year))
            }
            if let isRefundable = car.details.isRefundable, isRefundable {
                self.refundableTapped()
            }
            
            self.priceTextFieldView.set(text: car.details.price?.toString())
            self.cylindersTextFieldView.set(text: car.details.cylinders)
            self.engineTextFieldView.set(text: car.details.engineSize)
            self.walkwayTextFieldView.set(text: car.details.walkway)
            self.descriptionTextView.set(text: car.details.description_en)
            self.descriptionArTextView.set(text: car.details.description_ar)
            self.imagesView.setFrontImage(with: car.details.frontSideCar)
            self.imagesView.setBackImage(with: car.details.backSideCar)
            self.imagesView.setLeftImage(with: car.details.leftSideCar)
            self.imagesView.setRightImage(with: car.details.rightSideCar)
            self.imagesView.setInsideImage(with: car.details.insideCar)
            
        }
        
    }
    private func addDelegates() {
        
        self.brandTextFieldView.delegate = self
        self.typeTextFieldView.delegate = self
        self.classTextFieldView.delegate = self
        self.specificationsTextFieldView.delegate = self
        self.incomingTextFieldView.delegate = self
        self.colorTextFieldView.delegate = self
        self.driveTextFieldView.delegate = self
        self.fuelTextFieldView.delegate = self
        self.asphaltTextFieldView.delegate = self
        self.statusTextFieldView.delegate = self
        self.howToSellTextFieldView.delegate = self
        self.cityTextFieldView.delegate = self
        self.yearTextFieldView.delegate = self
        
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc private func notRefundableTapped() {
        self.notRefundableButton.isSelected.toggle()
        self.refundableButton.isSelected.toggle()
        self.isRefundable = false
    }
    @objc private func refundableTapped() {
        self.notRefundableButton.isSelected.toggle()
        self.refundableButton.isSelected.toggle()
        self.isRefundable = true
    }
    @IBAction private func addButtonPressed() {
        
        do {
            
            switch self.operationType {
            case .add:
                let frontImage = try imagesView.validateFrontImage()
                let backImage = try imagesView.validateBackImage()
                let rightImage = try imagesView.validateRightImage()
                let leftImage = try imagesView.validateLeftImage()
                let insideImage = try imagesView.validateInsideImage()
                
                let price = try CarValidationService.validate(price: self.priceTextFieldView.textValue())
                let brandId = try CarValidationService.validate(brandId: self.brandTextFieldView.value()?.id)
                let typeId = try CarValidationService.validate(typeId: self.typeTextFieldView.value()?.id)
                let classId = try CarValidationService.validate(classId: self.classTextFieldView.value()?.id)
                let year = try CarValidationService.validate(year: self.yearTextFieldView.value()?.id)
                let engine = try CarValidationService.validate(engineId: self.engineTextFieldView.textValue())
                let specificationsId = try CarValidationService.validate(specificationsId: self.specificationsTextFieldView.value()?.id)
                let incomingId = try CarValidationService.validate(incomingId: self.incomingTextFieldView.value()?.id)
                let colorId = try CarValidationService.validate(colorId: self.colorTextFieldView.value()?.id)
                let driveId = try CarValidationService.validate(driveId: self.driveTextFieldView.value()?.id)
                let fuelId = try CarValidationService.validate(fuelId: self.fuelTextFieldView.value()?.id)
                let asphaltId = try CarValidationService.validate(asphaltId: self.asphaltTextFieldView.value()?.id)
                let statusId = try CarValidationService.validate(statusId: self.statusTextFieldView.value()?.id)
                let cylinders = try CarValidationService.validate(cylinders: self.cylindersTextFieldView.textValue())
                let howToSellId = try CarValidationService.validate(howToSellId: self.howToSellTextFieldView.value()?.id)
                let walkway = try CarValidationService.validate(walkway: self.walkwayTextFieldView.textValue())
                let cityId = try CarValidationService.validate(cityId: self.cityTextFieldView.value()?.id)
                let description = try CarValidationService.validate(description: self.descriptionTextView.textValue())
                let descriptionAr = try CarValidationService.validate(description: self.descriptionArTextView.textValue())
                
                let images: [UploadData] = [
                    UploadData(data: frontImage, fileName: "frontImage\(Date()).jpeg", mimeType: .jpeg, name: "frontSideCar"),
                    UploadData(data: backImage, fileName: "backImage\(Date()).jpeg", mimeType: .jpeg, name: "backSideCar"),
                    UploadData(data: rightImage, fileName: "rightImage\(Date()).jpeg", mimeType: .jpeg, name: "rightSideCar"),
                    UploadData(data: leftImage, fileName: "leftImage\(Date()).jpeg", mimeType: .jpeg, name: "leftSideCar"),
                    UploadData(data: insideImage, fileName: "insideImage\(Date()).jpeg", mimeType: .jpeg, name: "insideCar")
                ]
                
                self.addCarWith(
                    price: price,
                    brandId: brandId,
                    typeId: typeId,
                    classId: classId,
                    year: year,
                    specificationsId: specificationsId,
                    incomingId: incomingId,
                    colorId: colorId,
                    driveId: driveId,
                    fuelId: fuelId,
                    asphaltId: asphaltId,
                    statusId: statusId,
                    cylinders: cylinders,
                    engineId: engine,
                    howToSellId: howToSellId,
                    walkway: walkway,
                    cityId: cityId,
                    description: description,
                    descriptionAr: descriptionAr,
                    isRefundable: self.isRefundable,
                    type: "haraj",
                    images: images
                )
            case .edit(let car):
                
                let frontImage = self.imagesView.frontImage()
                let backImage = self.imagesView.backImage()
                let rightImage = self.imagesView.leftImage()
                let leftImage = self.imagesView.rightImage()
                let insideImage = self.imagesView.insideImage()
                
                let price = try CarValidationService.validate(price: self.priceTextFieldView.textValue())
                let brandId = try CarValidationService.validate(brandId: self.brandTextFieldView.value()?.id)
                let typeId = try CarValidationService.validate(typeId: self.typeTextFieldView.value()?.id)
                let classId = try CarValidationService.validate(classId: self.classTextFieldView.value()?.id)
                let year = try CarValidationService.validate(year: self.yearTextFieldView.value()?.id)
                let engine = try CarValidationService.validate(engineId: self.engineTextFieldView.textValue())
                let specificationsId = try CarValidationService.validate(specificationsId: self.specificationsTextFieldView.value()?.id)
                let incomingId = try CarValidationService.validate(incomingId: self.incomingTextFieldView.value()?.id)
                let colorId = try CarValidationService.validate(colorId: self.colorTextFieldView.value()?.id)
                let driveId = try CarValidationService.validate(driveId: self.driveTextFieldView.value()?.id)
                let fuelId = try CarValidationService.validate(fuelId: self.fuelTextFieldView.value()?.id)
                let asphaltId = try CarValidationService.validate(asphaltId: self.asphaltTextFieldView.value()?.id)
                let statusId = try CarValidationService.validate(statusId: self.statusTextFieldView.value()?.id)
                let cylinders = try CarValidationService.validate(cylinders: self.cylindersTextFieldView.textValue())
                let howToSellId = try CarValidationService.validate(howToSellId: self.howToSellTextFieldView.value()?.id)
                let walkway = try CarValidationService.validate(walkway: self.walkwayTextFieldView.textValue())
                let cityId = try CarValidationService.validate(cityId: self.cityTextFieldView.value()?.id)
                let description = try CarValidationService.validate(description: self.descriptionTextView.textValue())
                let descriptionAr = try CarValidationService.validate(description: self.descriptionArTextView.textValue())
                
                var images: [UploadData] = []
                
                
                if let frontImage = frontImage {
                    images.append(UploadData(data: frontImage, fileName: "frontImage\(Date()).jpeg", mimeType: .jpeg, name:
                                "frontSideCar"))
                }
                if let backImage = backImage {
                    images.append(UploadData(data: backImage, fileName: "backImage\(Date()).jpeg", mimeType: .jpeg, name: "backSideCar"))
                }
                if let rightImage = rightImage {
                    images.append(UploadData(data: rightImage, fileName: "rightImage\(Date()).jpeg", mimeType: .jpeg, name: "rightSideCar"))
                }
                if let leftImage = leftImage {
                    images.append(UploadData(data: leftImage, fileName: "leftImage\(Date()).jpeg", mimeType: .jpeg, name: "leftSideCar"))
                }
                if let insideImage = insideImage {
                    images.append(UploadData(data: insideImage, fileName: "insideImage\(Date()).jpeg", mimeType: .jpeg, name: "insideCar"))
                }
                
                
                self.editCarWith(
                    id: car.details.id,
                    price: price,
                    brandId: brandId,
                    typeId: typeId,
                    classId: classId,
                    year: year,
                    specificationsId: specificationsId,
                    incomingId: incomingId,
                    colorId: colorId,
                    driveId: driveId,
                    fuelId: fuelId,
                    asphaltId: asphaltId,
                    statusId: statusId,
                    cylinders: cylinders,
                    engineId: engine,
                    howToSellId: howToSellId,
                    walkway: walkway,
                    cityId: cityId,
                    description: description,
                    descriptionAr: descriptionAr,
                    isRefundable: self.isRefundable,
                    type: "haraj",
                    images: images
                )
            }
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
        
    }
    
}


//MARK: - Networking -
extension AddCarVC {
    private func getAttributes() {
        self.showIndicator()
        CarRouter.addCarData.send { [weak self] (response: APIGenericResponse<AddCarData>) in
            guard let self = self else {return}
            self.hideIndicator()
            UserDefaults.addCarData = response.data
            self.configureInitialData()
        }
    }
    private func addCarWith(
        price: String,
        brandId: String,
        typeId: String,
        classId: String,
        year: String,
        specificationsId: String,
        incomingId: String,
        colorId: String,
        driveId: String,
        fuelId: String,
        asphaltId: String,
        statusId: String,
        cylinders: String,
        engineId: String,
        howToSellId: String,
        walkway: String,
        cityId: String,
        description: String,
        descriptionAr: String,
        isRefundable: Bool,
        type: String,
        images: [UploadData]
    ) {
        self.showIndicator()
        CarRouter.addCar(price: price, brandId: brandId, typeId: typeId, classId: classId, year: year, specificationsId: specificationsId, incomingId: incomingId, colorId: colorId, driveId: driveId, fuelId: fuelId, asphaltId: asphaltId, statusId: statusId, cylinders: cylinders, engineId: engineId, howToSellId: howToSellId, walkway: walkway, cityId: cityId, description: description, descriptionAr: descriptionAr, type: type, isRefundable: isRefundable).send(data: images) { [weak self] (response: APIGenericResponse<String>) in
            guard let self = self else {return}
            self.hideIndicator()
            self.showSuccessAlert(message: response.message)
            self.dismiss(animated: true)
        }
    }
    private func editCarWith(
        id: String,
        price: String?,
        brandId: String?,
        typeId: String?,
        classId: String?,
        year: String?,
        specificationsId: String?,
        incomingId: String?,
        colorId: String?,
        driveId: String?,
        fuelId: String?,
        asphaltId: String?,
        statusId: String?,
        cylinders: String?,
        engineId: String?,
        howToSellId: String?,
        walkway: String?,
        cityId: String?,
        description: String?,
        descriptionAr: String?,
        isRefundable: Bool?,
        type: String?,
        images: [UploadData]?
    ) {
        self.showIndicator()
        CarRouter.editCar(id: id, price: price, brandId: brandId, typeId: typeId, classId: classId, year: year, specificationsId: specificationsId, incomingId: incomingId, colorId: colorId, driveId: driveId, fuelId: fuelId, asphaltId: asphaltId, statusId: statusId, cylinders: cylinders, engineId: engineId, howToSellId: howToSellId, walkway: walkway, cityId: cityId, description: description, descriptionAr: descriptionAr, type: type, isRefundable: isRefundable).send(data: images) { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.hideIndicator()
            self.showSuccessAlert(message: response.message)
            self.pop()
        }
    }
}

//MARK: - Routes -
extension AddCarVC {
    func goToCarDetails(id: String) {
        let vc = CarDetailsVC.create(id: id)
        self.push(vc)
    }
}

//MARK: - Delegate -
extension AddCarVC: DropDownTextFieldViewDelegate {
    
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
        case brandTextFieldView: return self.brandArray
        case typeTextFieldView: return self.typeArray
        case classTextFieldView: return self.classArray
        case specificationsTextFieldView: return self.specificationsArray
        case incomingTextFieldView: return self.incomingArray
        case colorTextFieldView: return self.colorArray
        case driveTextFieldView: return self.driveArray
        case fuelTextFieldView: return self.fuelArray
        case asphaltTextFieldView: return self.asphaltArray
        case statusTextFieldView: return self.statusArray
        case howToSellTextFieldView: return self.howToSellArray
        case cityTextFieldView: return self.cityArray
        case yearTextFieldView: return self.years
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
