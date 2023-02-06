//
//  BaseVC.swift
//
//  Created by MGAbouarab®
//

import UIKit
import Alamofire

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBaseVC()
        self.addKeyboardDismiss()
    }
    
    //MARK: - Design -
    private func setupBaseVC() {
        self.view.backgroundColor = Theme.colors.mainBackgroundColor
        self.setBack(title: "")
        self.view.tintColor = Theme.colors.mainColor
    }
    func setupNavigationView() {
        self.navigationItem.titleView = HeaderView()
    }
    func setBack(title: String?) {
        let backItem = UIBarButtonItem()
        backItem.title = title
        self.navigationItem.backBarButtonItem = backItem
    }
    func changeNavigationBar(alpha: CGFloat) {
        self.navigationController?.navigationBar.subviews.first?.alpha = alpha
    }
    func addBackButtonWith(title: String) {
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backButtonPressed))
        stack.addGestureRecognizer(tap)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stack)
    }
    func setLeading(title: String?) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = Theme.colors.whiteColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    func setNotificationButton() {
        let button = UIButton()
        button.setImage(UIImage(named: "notificationButton"), for: .normal)
        button.addTarget(self, action: #selector(self.notificationButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func addUserInfoBarButton(userName: String?, userImage: String?) {
        
        let width: CGFloat = 40
        
        let userImageView = UIImageView()
        userImageView.setWith(string: userImage)
        userImageView.contentMode = .scaleAspectFill
        userImageView.heightAnchor.constraint(equalToConstant: width).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        userImageView.layer.cornerRadius = width / 2
        userImageView.clipsToBounds = true
        
        let userNameLabel = UILabel()
        userNameLabel.text = userName
        userNameLabel.textColor = Theme.colors.mainDarkFontColor
        userNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        let stack = UIStackView(arrangedSubviews: [userImageView, userNameLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stack)
        
    }
    
    //MARK: - Deinit -
    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "BaseVC") is deinit, No memory leak found")
    }
    
    //MARK: - IBActions -
    @objc private func notificationButtonPressed() {
        guard UserDefaults.isLogin else {
            self.showLogoutAlert {
                self.presentLogin()
            }
            return
        }
        let vc = NotificationsVC.create()
        self.push(vc)
    }
    
}

//MARK: - Dismiss Keyboard -
extension BaseVC {
    private func addKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @objc func backButtonPressed() {
        self.pop()
    }
}

//MARK: - Alerts and indicators -
extension BaseVC {
    
    func showIndicator(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            AppIndicator.shared.show(isGif: false)
        }
    }
    func hideIndicator(){
        AppIndicator.shared.dismiss()
    }
    
    func showErrorAlert(error: String?){
        AppAlert.showErrorAlert(error: error)
    }
    func showSuccessAlert(message: String?){
        AppAlert.showSuccessAlert(message: message)
    }
    func showSomethingError(){
        AppAlert.showSomethingError()
    }
    
    func showInternetConnectionErrorAlert(completion:@escaping(()->())){
        AppAlert.showInternetConnectionErrorAlert(completion: completion)
    }
    func showDeleteAlert(complation: @escaping () -> ()) {
        AppAlert.showDeleteAlert(complation: complation)
    }
    func showDeleteAccountAlert(complation: @escaping () -> ()) {
        AppAlert.showDeleteAccountAlert(complation: complation)
    }
    func showLoginAlert(complation: @escaping () -> ()) {
        AppAlert.showLoginAlert(complation: complation)
    }
    func showLogoutAlert(complation: @escaping () -> ()) {
        AppAlert.showLogoutAlert(complation: complation)
    }
    
    func presentLogin() {
        let vc = LoginVC.create()
        let nav = AuthNav(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
}

//MARK: - Router -
extension BaseVC {
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    func popToRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
