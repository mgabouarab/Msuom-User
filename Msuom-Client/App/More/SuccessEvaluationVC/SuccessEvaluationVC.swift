//
//  SuccessEvaluationVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 30/01/2023.
//
//  Template by MGAbouarab®


import UIKit

protocol SuccessEvaluationDelegate {
    func goToHome()
    func goToOrders()
}

class SuccessEvaluationVC: BaseVC {
    
    //MARK: - IBOutlets -
    
    
    //MARK: - Properties -
    private var delegate: SuccessEvaluationDelegate!
    
    //MARK: - Creation -
    static func create(delegate: SuccessEvaluationDelegate) -> SuccessEvaluationVC {
        let vc = AppStoryboards.cars.instantiate(SuccessEvaluationVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = delegate
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "".localized
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func homeButtonPressed() {
        self.delegate.goToHome()
        self.dismiss(animated: true)
    }
    
    @IBAction private func orderButtonPressed() {
        self.delegate.goToOrders()
        self.dismiss(animated: true)
    }
}


//MARK: - Networking -
extension SuccessEvaluationVC {
    
}

//MARK: - Routes -
extension SuccessEvaluationVC {
    
}
