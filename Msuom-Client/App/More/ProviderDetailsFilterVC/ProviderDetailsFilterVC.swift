//
//  ProviderDetailsFilterVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 14/06/2023.
//

import UIKit

protocol ProviderDetailsFilterDelegate {
    func didSelectFilter(brandId: String?, typeId: String?, year: String?, cityId: String?, statusId: String?)
}

class ProviderDetailsFilterVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var brandTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var typeTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var yearTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var cityTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var statusTextFieldView: DropDownTextFieldView!
    
    //MARK: - Properties -
    private var delegate: ProviderDetailsFilterDelegate!
    private var brandArray: [DropDownItem] = []
    private var typeArray: [DropDownItem] = []
    private var years: [DropDownItem] = []
    private var cityArray: [DropDownItem] = []
    private var statusArray: [DropDownItem] = []
    
    //MARK: - Creation -
    static func create(delegate: ProviderDetailsFilterDelegate) -> ProviderDetailsFilterVC {
        let vc = AppStoryboards.more.instantiate(ProviderDetailsFilterVC.self)
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
            self.statusArray = data.carStatus
            self.cityArray = data.cities
        } else {
            self.getAttributes()
        }
        
        struct Item: DropDownItem {
            var id: String
            var name: String
        }
        let year = Calendar.current.component(.year, from: Date())
        self.years = Array(year-40 ... year).reversed().map({Item(id: "\($0)", name: "\($0)")})
        
    }
    
    private func addDelegates() {
        
        self.brandTextFieldView.delegate = self
        self.typeTextFieldView.delegate = self
        self.statusTextFieldView.delegate = self
        self.cityTextFieldView.delegate = self
        self.yearTextFieldView.delegate = self
        
    }
    
    //MARK: - Actions -
    @IBAction private func filterButtonPressed() {
        
        let brandId = self.brandTextFieldView.value()?.id
        let typeId = self.typeTextFieldView.value()?.id
        let year = self.yearTextFieldView.value()?.id
        let cityId = self.cityTextFieldView.value()?.id
        let statusId = self.statusTextFieldView.value()?.id
        
        self.delegate.didSelectFilter(
            brandId: brandId,
            typeId: typeId,
            year: year,
            cityId: cityId,
            statusId: statusId
        )
        self.dismiss(animated: true)
    }
    
}


//MARK: - Networking -
extension ProviderDetailsFilterVC {
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
extension ProviderDetailsFilterVC {
    
}

//MARK: - Delegate -
extension ProviderDetailsFilterVC: DropDownTextFieldViewDelegate {
    
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
            case self.brandTextFieldView: return self.brandArray
            case self.typeTextFieldView: return self.typeArray
            case self.yearTextFieldView: return self.years
            case self.cityTextFieldView: return self.cityArray
            case self.statusTextFieldView: return self.statusArray
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

