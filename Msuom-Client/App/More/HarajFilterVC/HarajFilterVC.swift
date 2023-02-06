//
//  HarajFilterVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 30/01/2023.
//
//  Template by MGAbouarab®


import UIKit


protocol HarajFilterDelegate {
    func didSelect(brandId: String?, typeId: String?, cityId: String?, statusId: String?)
}


class HarajFilterVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var brandTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var typeTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var classTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var statusTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var cityTextFieldView: DropDownTextFieldView!
    
    //MARK: - Properties -
    private var delegate: HarajFilterDelegate!
    private var brandArray: [DropDownItem] = []
    private var typeArray: [DropDownItem] = []
    private var classArray: [DropDownItem] = []
    private var statusArray: [DropDownItem] = []
    private var cityArray: [DropDownItem] = []
    
    //MARK: - Creation -
    static func create(delegate: HarajFilterDelegate) -> HarajFilterVC {
        let vc = AppStoryboards.more.instantiate(HarajFilterVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = delegate
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
        self.title = "Filter By".localized
    }
    
    //MARK: - Logic Methods -
    private func configureInitialData() {
        
        if let data = UserDefaults.addCarData {
            self.brandArray = data.carBrands
            self.typeArray = []
            self.classArray = data.carCategories
            self.statusArray = data.carStatus
            self.cityArray = data.cities
        } else {
            self.getAttributes()
        }
    }
    private func addDelegates() {
        
        self.brandTextFieldView.delegate = self
        self.typeTextFieldView.delegate = self
        self.classTextFieldView.delegate = self
        self.statusTextFieldView.delegate = self
        self.cityTextFieldView.delegate = self
        
    }
    
    //MARK: - Actions -
    @IBAction private func filterButtonPressed() {
        self.delegate.didSelect(
            brandId: self.brandTextFieldView.value()?.id,
            typeId: self.typeTextFieldView.value()?.id,
            cityId: self.cityTextFieldView.value()?.id,
            statusId: self.cityTextFieldView.value()?.id
        )
        self.dismiss(animated: true)
    }
}


//MARK: - Networking -
extension HarajFilterVC {
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
extension HarajFilterVC {
    
}

//MARK: - Delegate -
extension HarajFilterVC: DropDownTextFieldViewDelegate {
    
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
        case brandTextFieldView: return self.brandArray
        case typeTextFieldView: return self.typeArray
        case classTextFieldView: return self.classArray
        case statusTextFieldView: return self.statusArray
        case cityTextFieldView: return self.cityArray
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
