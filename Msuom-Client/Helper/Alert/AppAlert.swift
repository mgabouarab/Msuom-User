//
//  AppAlert.swift
//
//  Created by MGAbouarab®
//

import UIKit

//MARK: - Alert Action Types -
fileprivate enum AlertActions {
    case internetConnection
    case delete
    case deleteAccount
    case login
    case logout
    case refuse
}
extension AlertActions {
    var imageName: String {
        switch self {
        case .internetConnection:
            return "noConnection"
        case .delete:
            return "deleteImage"
        case .deleteAccount:
            return "deleteImage"
        case .login:
            return "login"
        case .logout:
            return "login"
        case .refuse:
            return "warningAlert"
        }
    }
    var message: String {
        switch self {
        case .internetConnection:
            return "Please cheack your connection".helperLocalizable
        case .delete:
            return "Do you Need to delete this Item?".helperLocalizable
        case .deleteAccount:
            return "Do you Need to delete your account?".helperLocalizable
        case .login:
            return "Are you sure you want to logout?".helperLocalizable
        case .logout:
            return "You should login first".helperLocalizable
        case .refuse:
            return "Are you sure to refuse".helperLocalizable
        }
    }
    var actionTitle: String {
        switch self {
        case .internetConnection:
            return "Try again".helperLocalizable
        case .delete:
            return "Delete".helperLocalizable
        case .deleteAccount:
            return "Delete".helperLocalizable
        case .login:
            return "Logout".helperLocalizable
        case .logout:
            return "Login".helperLocalizable
        case .refuse:
            return "Refuse".helperLocalizable
        }
    }
}

//MARK: - Private Functions to Create all type of Alerts -
fileprivate func createAlert(message: String, type: AlertType = .error) {
    TopAlert.shared.type = type
    TopAlert.shared.message = message
    TopAlert.shared.showAnimate()
}
fileprivate func createAlert(action: AlertActions, completion:@escaping(()->Void)) {
    
    //MARK: - ActionSheet Design -
    let actionSheet = UIAlertController(title: "\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "Cancel".helperLocalizable, style: .cancel, handler: nil)
    let tryAgainAction = UIAlertAction(title: action.actionTitle, style: (action == .delete || action == .login || action == .deleteAccount) ? .destructive : .default, handler: { (action) in
        completion()
    })
    actionSheet.addAction(tryAgainAction)
    actionSheet.addAction(cancelAction)
    
    if #available(iOS 13.0, *) {
        actionSheet.overrideUserInterfaceStyle = .dark
        actionSheet.view.tintColor = Theme.colors.whiteColor
    }
    
    let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
    subview.backgroundColor = .clear//action.backgroundColor
    
    //MARK: - Design BackgroundView -
    let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 120.0))
    view.backgroundColor = UIColor.clear
    actionSheet.view.addSubview(view)
    
    //MARK: - Image Design -
    let imageView = UIImageView()
    imageView.image = UIImage(named: action.imageName)
    imageView.tintColor = Theme.colors.whiteColor
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    
    //MARK: - Message Body -
    let title = UILabel()
    title.textAlignment = .center
    title.numberOfLines = 0
    title.text = action.message
    title.textColor = Theme.colors.whiteColor
    title.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(title)
    title.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    title.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    title.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    title.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    //MARK: - present the action sheet -
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    guard let window = window else {return}
    window.topViewController()?.present(actionSheet, animated: true)
}

//MARK: - App Alerts -
class AppAlert {
    
    //MARK: - Alert Without Action -
    static func showErrorAlert(error: String?){
        createAlert(message: error ?? "Error".helperLocalizable, type: .error)
    }
    static func showSuccessAlert(message: String?){
        createAlert(message: message ?? "Success".helperLocalizable, type: .success)
    }
    static func showSomethingError(){
        createAlert(message: "Something worng please try again later.".helperLocalizable, type: .error)
    }
    
    //MARK: - Alert With Action -
    static func showInternetConnectionErrorAlert(completion:@escaping(()->())){
        createAlert(action: .internetConnection, completion: completion)
    }
    static func showDeleteAlert(complation: @escaping () -> ()) {
        createAlert(action: .delete, completion: complation)
    }
    static func showDeleteAccountAlert(complation: @escaping () -> ()) {
        createAlert(action: .deleteAccount, completion: complation)
    }
    static func showLogoutAlert(complation: @escaping () -> ()) {
        createAlert(action: .logout, completion: complation)
    }
    static func showLoginAlert(complation: @escaping () -> ()) {
        createAlert(action: .login, completion: complation)
    }
    static func showRefuseAlert(complation: @escaping () -> ()) {
        createAlert(action: .refuse, completion: complation)
    }
}
