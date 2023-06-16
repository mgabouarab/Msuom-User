//
//  AddAuctionVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 12/05/2023.
//

import UIKit


struct AddAuctionModel {
    
    var price: String?
    
    var brandId: String
    var typeId: String
    var classId: String
    var year: String
    var specificationsId: String
    var incomingId: String
    var colorId: String
    var driveId: String
    var fuelId: String
    var asphaltId: String
    var statusId: String
    var cylinders: String
    var engineId: String
    var howToSellId: String
    var walkway: String
    var cityId: String
    var type: String
    var images: [UploadData]
    
    var startDate: String?
    var startTime: String?
    var endDate: String?
    var endTime: String?
    
    
}

class AddAuctionVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var imagesView: SelectCarImagesView!
    
    @IBOutlet weak private var basicInfoView: UIView!
    @IBOutlet weak private var startDateTextFieldView: DatePickerTextFieldView!
    @IBOutlet weak private var startTimeTextFieldView: DatePickerTextFieldView!
    @IBOutlet weak private var endDateTextFieldView: DatePickerTextFieldView!
    @IBOutlet weak private var endTimeTextFieldView: DatePickerTextFieldView!
    
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
    
    
    //MARK: - Properties -
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
    private var type: AuctionTypeSelectionVC.AuctionTypes = .normal
    
    //MARK: - Creation -
    static func create(type: AuctionTypeSelectionVC.AuctionTypes) -> AddAuctionVC {
        let vc = AppStoryboards.auctions.instantiate(AddAuctionVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.type = type
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
        self.addBackButtonWith(title: "Add Auction".localized)
        self.startTimeTextFieldView.mode = .time()
        self.endTimeTextFieldView.mode = .time()
        
        switch self.type {
        case .normal:
            self.basicInfoView.isHidden = false
        case .live:
            self.basicInfoView.isHidden = true
        }
        
        struct Item: DropDownItem {
            var id: String
            var name: String
        }
        let year = Calendar.current.component(.year, from: Date())
        years = Array(year-40 ... year).reversed().map({Item(id: "\($0)", name: "\($0)")})
        
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
    @IBAction private func addButtonPressed() {
        
        do {
            let frontImage = try imagesView.validateFrontImage()
            let backImage = try imagesView.validateBackImage()
            let rightImage = try imagesView.validateRightImage()
            let leftImage = try imagesView.validateLeftImage()
            let insideImage = try imagesView.validateInsideImage()
            
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
            
            let images: [UploadData] = [
                UploadData(data: frontImage, fileName: "frontImage\(Date()).jpeg", mimeType: .jpeg, name: "frontSideCar"),
                UploadData(data: backImage, fileName: "backImage\(Date()).jpeg", mimeType: .jpeg, name: "backSideCar"),
                UploadData(data: rightImage, fileName: "rightImage\(Date()).jpeg", mimeType: .jpeg, name: "rightSideCar"),
                UploadData(data: leftImage, fileName: "leftImage\(Date()).jpeg", mimeType: .jpeg, name: "leftSideCar"),
                UploadData(data: insideImage, fileName: "insideImage\(Date()).jpeg", mimeType: .jpeg, name: "insideCar")
            ]
            
            
            switch self.type {
            case .normal:
                let price = try CarValidationService.validate(startPrice: self.priceTextFieldView.textValue())
                let startDate = try CarValidationService.validate(startDate: self.startDateTextFieldView.value())
                let startTime = try CarValidationService.validate(startTime: self.startTimeTextFieldView.value())
                let endDate = try CarValidationService.validate(endDate: self.endDateTextFieldView.value())
                let endTime = try CarValidationService.validate(endTime: self.endTimeTextFieldView.value())
                
                self.addAuctionWith(
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
                    type: "normal",
                    images: images,
                    startDate: startDate,
                    startTime: startTime,
                    endDate: endDate,
                    endTime: endTime
                )
            case .live:
                self.addAuctionWith(
                    price: nil,
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
                    type: "live",
                    images: images,
                    startDate: nil,
                    startTime: nil,
                    endDate: nil,
                    endTime: nil
                )
            }
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
        
    }
    
}


//MARK: - Networking -
extension AddAuctionVC {
    private func getAttributes() {
        self.showIndicator()
        CarRouter.addCarData.send { [weak self] (response: APIGenericResponse<AddCarData>) in
            guard let self = self else {return}
            self.hideIndicator()
            UserDefaults.addCarData = response.data
            self.configureInitialData()
        }
    }
    private func addAuctionWith(
        price: String?,
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
        type: String,
        images: [UploadData],
        startDate: String?,
        startTime: String?,
        endDate: String?,
        endTime: String?
    ) {
        
        let auction = AddAuctionModel(
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
            engineId: engineId,
            howToSellId: howToSellId,
            walkway: walkway,
            cityId: cityId,
            type: type,
            images: images,
            startDate: startDate,
            startTime: startTime,
            endDate: endDate,
            endTime: endTime
        )
        let vc = CompleteAuctionInfoVC.create(type: self.type, addAuctionModel: auction)
        self.push(vc)
        
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
        type: String?,
        images: [UploadData]?
    ) {
        
    }
}

//MARK: - Routes -
extension AddAuctionVC {
    func goToCarDetails(id: String) {
        let vc = CarDetailsVC.create(id: id)
        self.push(vc)
    }
}

//MARK: - Delegate -
extension AddAuctionVC: DropDownTextFieldViewDelegate {
    
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

