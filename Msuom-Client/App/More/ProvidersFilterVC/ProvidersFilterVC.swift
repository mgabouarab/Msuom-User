//
//  ProvidersFilterVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/02/2023.
//
//  Template by MGAbouarab®


import UIKit

protocol ProvidersFilterDelegate {
    func didSelectFilter(name: String?, brandId: String?, cityId: String?)
}

class ProvidersFilterVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var cityTextFieldView: DropDownTextFieldView!
    @IBOutlet weak private var nameTextFieldView: NormalTextFieldView!
    @IBOutlet weak private var brandTextFieldView: DropDownTextFieldView!
    
    
    //MARK: - Properties -
    private var delegate: ProvidersFilterDelegate!
    private var brandArray: [DropDownItem] = []
    private var cityArray: [DropDownItem] = []
    
    //MARK: - Creation -
    static func create(delegate: ProvidersFilterDelegate) -> ProvidersFilterVC {
        let vc = AppStoryboards.more.instantiate(ProvidersFilterVC.self)
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
            self.cityArray = data.cities
        } else {
            self.getAttributes()
        }
    }
    
    private func addDelegates() {
        
        self.brandTextFieldView.delegate = self
        self.cityTextFieldView.delegate = self
        
    }
    
    //MARK: - Actions -
    @IBAction private func filterButtonPressed() {
        self.delegate.didSelectFilter(
            name: self.nameTextFieldView.textValue(),
            brandId: self.brandTextFieldView.value()?.id,
            cityId: self.cityTextFieldView.value()?.id
        )
        self.dismiss(animated: true)
    }
    
}


//MARK: - Networking -
extension ProvidersFilterVC {
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
extension ProvidersFilterVC {
    
}

//MARK: - Delegate -
extension ProvidersFilterVC: DropDownTextFieldViewDelegate {
    
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
        case brandTextFieldView: return self.brandArray
        case cityTextFieldView: return self.cityArray
        default: return []
        }
    }
    
    func didSelect(item: DropDownItem, for textFieldView: DropDownTextFieldView) {
        
    }
    
}
