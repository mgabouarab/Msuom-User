//
//  WalletVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/01/2023.
//
//  Template by MGAbouarab®


import UIKit




class WalletVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var balanceLabel: UILabel!
    
    //MARK: - Properties -
//    var payMethods = [PaymentBrandsModel]()
    
    
    //MARK: - Creation -
    static func create() -> WalletVC {
        let vc = AppStoryboards.more.instantiate(WalletVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.getWallet()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Wallet".localized)
    }
    
    //MARK: - Logic Methods -
    private func showEnterAmountAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Enter Amount".localized, message: nil, preferredStyle: .alert)
        
        //cancel button
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alertController.addAction(cancelAction)
        
        //Create an optional action
        let nextAction: UIAlertAction = UIAlertAction(title: "Continue".localized, style: .default) { action -> Void in
            if let text = alertController.textFields?.first?.text, let amount = Double(text) {
//                self.showPaymentTypes(amount: amount)
                self.chargeWallet(with: "\(amount)")
            }
        }
        alertController.addAction(nextAction)
        
        //Add text field
        alertController.addTextField { (textField) -> Void in
            textField.textColor = Theme.colors.mainDarkFontColor
            textField.keyboardType = .asciiCapableNumberPad
        }
        //Present the AlertController
        self.present(alertController, animated: true, completion: nil)
    }
    private func showPaymentTypes(amount: Double) {
        
        
        let actionAlert = UIAlertController(title: "Select Payment type".localized, message: nil, preferredStyle: .actionSheet)
        actionAlert.overrideUserInterfaceStyle = .dark
        actionAlert.view.tintColor = Theme.colors.whiteColor
        
//        for method in self.payMethods {
//            let action = UIAlertAction(title: method.name, style: .default) { [weak self] _ in
//                guard let self = self else {return}
//                #warning("Don't forget to implement this after payment done")
//                self.showSuccessAlert(message: "Payment done successfully.")
//            }
//            actionAlert.addAction(action)
//        }
        
        let action = UIAlertAction(title: "Cancel".localized, style: .cancel)
        actionAlert.addAction(action)
        
        self.present(actionAlert, animated: true)
    }
    
    //MARK: - Actions -
    @IBAction private func addBalanceButtonPressed() {
        self.showEnterAmountAlert()
    }
    
}


//MARK: - Networking -
extension WalletVC {
    private func getWallet() {
        self.showIndicator()
        MoreRouter.wallet.send { [weak self] (response: APIGenericResponse<String>) in
            guard let self = self else {return}
            self.balanceLabel.text = response.data?.htmlToAttributedString?.string
        }
    }
    private func chargeWallet(with price: String) {
        self.showIndicator()
        MoreRouter.chargeWallet(price: price).send { [weak self] (response: APIGenericResponse<Double>) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.getWallet()
        }
    }
}

//MARK: - Routes -
extension WalletVC {
    
}
