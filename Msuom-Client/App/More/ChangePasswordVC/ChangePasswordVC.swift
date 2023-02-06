//
//  ChangePasswordVC.swift
//  Msuom
//
//  Created by MGAbouarab on 07/11/2022.
//
//  Template by MGAbouarab®


import UIKit

class ChangePasswordVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var currentPasswordTextFieldView: PasswordTextFieldView!
    @IBOutlet weak private var newPasswordTextFieldView: PasswordTextFieldView!
    @IBOutlet weak private var confirmNewPasswordTextFieldView: PasswordTextFieldView!
    
    
    //MARK: - Properties -
    
    
    //MARK: - Creation -
    static func create() -> ChangePasswordVC {
        let vc = AppStoryboards.more.instantiate(ChangePasswordVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Change password".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func changeButtonPressed() {
        do {
            let currentPassword = try self.currentPasswordTextFieldView.passwordText(for: .oldPassword)
            let newPassword = try self.newPasswordTextFieldView.passwordText(for: .newPassword)
            let _ = try self.confirmNewPasswordTextFieldView.passwordText(for: .confirmNewPassword(password: newPassword))
            self.change(currentPassword: currentPassword, to: newPassword)
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    
}


//MARK: - Networking -
extension ChangePasswordVC {
    private func change(currentPassword: String, to newPassword: String) {
        self.showIndicator()
        ProfileRouter.updatePassword(oldPassword: currentPassword, password: newPassword, passwordConfirmation: newPassword).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            switch response.key {
            case .success:
                self.showSuccessAlert(message: response.message)
                self.popToRoot()
            case .fail:
                self.showErrorAlert(error: response.message)
            case .unauthenticated:
                fatalError()
                #warning("Handle this")
            case .needActive:
                fatalError()
                #warning("Handle this")
            case .exception:
                fatalError()
                #warning("Handle this")
            case .blocked:
                fatalError()
                #warning("Handle this")
            }
        }
    }
}

//MARK: - Routes -
extension ChangePasswordVC {
    
}
