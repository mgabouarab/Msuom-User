//
//  InAppLanguageVC.swift
//  Msuom
//
//  Created by MGAbouarab on 02/11/2022.
//

import UIKit

class InAppLanguageVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var arabicButton: UIButton!
    @IBOutlet weak private var englishButton: UIButton!
    @IBOutlet weak private var arabicCircleView: UIView!
    @IBOutlet weak private var englishCircleView: UIView!
    @IBOutlet weak private var arabicRectangleView: UIView!
    @IBOutlet weak private var englishRectangleView: UIView!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var confirmView: UIView!
    
    
    //MARK: - Properties -
    private var selectedLanguage: String?
    
    //MARK: - Creation -
    static func create() -> InAppLanguageVC {
        let vc = AppStoryboards.more.instantiate(InAppLanguageVC.self)
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
        self.title = "".localized
        self.arabicRectangleView.layer.cornerRadius = 12
        self.englishRectangleView.layer.cornerRadius = 12
        self.view.backgroundColor = Theme.colors.whiteColor
        self.arabicCircleView.layer.cornerRadius = self.arabicCircleView.bounds.width / 2
        self.englishCircleView.layer.cornerRadius = self.englishCircleView.bounds.width / 2
        self.arabicCircleView.clipsToBounds = true
        self.englishCircleView.clipsToBounds = true
        self.confirmView.clipsToBounds = false
        self.confirmView.addShadow()
        self.stackView.animateToTop()
        self.handleView(for: Language.apiLanguage())
        self.addBackButtonWith(title: "App Language".localized)
    }
    private func handleView(for language: String) {
        UIView.animate(withDuration: 0.3) {
            switch language {
            case Language.Languages.ar:
                self.active(rectView: self.arabicRectangleView, and: self.arabicCircleView)
                self.inActive(rectView: self.englishRectangleView, and: self.englishCircleView)
            case Language.Languages.en:
                self.active(rectView: self.englishRectangleView, and: self.englishCircleView)
                self.inActive(rectView: self.arabicRectangleView, and: self.arabicCircleView)
            default:
                print("handle this case")
            }
        }
    }
    
    private func active(rectView: UIView, and circleView: UIView) {
        circleView.backgroundColor = Theme.colors.whiteColor
        rectView.backgroundColor = Theme.colors.mainWithAlph
        rectView.addBorder(with: Theme.colors.mainColor.cgColor)
    }
    private func inActive(rectView: UIView, and circleView: UIView) {
        circleView.backgroundColor = Theme.colors.mainWithAlph
        rectView.backgroundColor = Theme.colors.whiteColor
        rectView.addBorder()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    
    /*
     if current language is the selected one, No need to change semantic attribute, just go to next page
     */
    
    @IBAction private func arabicButtonPressed() {
        self.selectedLanguage = Language.Languages.ar
        self.handleView(for: Language.Languages.ar)
    }
    @IBAction private func englishButtonPressed() {
        self.selectedLanguage = Language.Languages.en
        self.handleView(for: Language.Languages.en)
    }
    @IBAction private func confirmButtonPressed() {
        if let _ = selectedLanguage {
            if Language.isRTL() {
                if self.selectedLanguage == Language.Languages.en {
                    Language.setAppLanguage(lang: Language.Languages.en)
                    goToNext()
                } else {
                    self.pop()
                }
            } else {
                if self.selectedLanguage == Language.Languages.ar {
                    Language.setAppLanguage(lang: Language.Languages.ar)
                    goToNext()
                } else {
                    self.pop()
                }
            }
        } else {
            self.pop()
        }
    }
    
}


//MARK: - Networking -
extension InAppLanguageVC {
    
}

//MARK: - Routes -
extension InAppLanguageVC {
    private func goToNext() {
        let vc = SplashVC.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
}

