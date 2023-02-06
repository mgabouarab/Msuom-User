//
//  SplashVC.swift
//
//  Created by MGAbouarab®
//

import UIKit

class SplashVC: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var stackView: UIStackView!
    
    //MARK: - Properties -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    static func create() -> SplashVC {
        let vc = AppStoryboards.main.instantiate(SplashVC.self)
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDesign()
        self.getAddCarData()
    }
    
    //MARK: - Design Methods -
    func setupDesign() {
        self.stackView.animateToTop()
        let window = UIApplication.shared.windows.first
        window?.backgroundColor = Theme.colors.mainColor
    }
    
    //MARK: - Logic Methods -
    private func goNext() {
        switch UserDefaults.isLogin {
        case true:
            self.goToHome()
        case false:
            self.goToLanguage()
        }
    }
    
    //MARK: - Route Methods -
    private func goToLanguage() {
        let vc = IntroLanguageVC.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    private func goToHome() {
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    //MARK: - IBActions -
    
}

extension SplashVC {
    private func getAddCarData() {
        CarRouter.addCarData.send { [weak self] (response: APIGenericResponse<AddCarData>) in
            guard let self = self else {return}
            UserDefaults.addCarData = response.data
            self.goNext()
        }
    }
}
