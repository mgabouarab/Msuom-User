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
    func goToOrders(id: String)
}

class SuccessEvaluationVC: BaseVC {
    
    //MARK: - IBOutlets -
    
    
    //MARK: - Properties -
    private var delegate: SuccessEvaluationDelegate!
    private var id: String!
    
    //MARK: - Creation -
    static func create(delegate: SuccessEvaluationDelegate, id: String) -> SuccessEvaluationVC {
        let vc = AppStoryboards.cars.instantiate(SuccessEvaluationVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = delegate
        vc.id = id
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
        self.delegate.goToOrders(id: self.id)
        self.dismiss(animated: true)
    }
}


//MARK: - Networking -
extension SuccessEvaluationVC {
    
}

//MARK: - Routes -
extension SuccessEvaluationVC {
    
}
