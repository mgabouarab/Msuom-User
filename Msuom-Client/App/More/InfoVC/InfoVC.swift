//
//  InfoVC.swift
//  Msuom
//
//  Created by MGAbouarab on 02/11/2022.
//
//  Template by MGAbouarab®


import UIKit

class InfoVC: BaseVC {
    
    enum InfoType {
        case about
        case terms
        case privacy
        
        var title: String {
            switch self {
            case .about:
                return "About".localized
            case .terms:
                return "Contact us".localized
            case .privacy:
                return "Privacy Policy".localized
            }
        }
        
    }
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var textView: UITextView!
    
    //MARK: - Properties -
    private var type: InfoType = .terms
    
    //MARK: - Creation -
    static func create(type: InfoType) -> InfoVC {
        let vc = AppStoryboards.more.instantiate(InfoVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.type = type
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.getData()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: self.type.title)
    }
    
    //MARK: - Logic Methods -
    private func getData() {
        switch self.type {
        case .about:
            self.getAbout()
        case .terms:
            self.getTerms()
        case .privacy:
            self.getPrivacy()
        }
    }
    
    //MARK: - Actions -
    
}


//MARK: - Networking -
extension InfoVC {
    
}

//MARK: - Routes -
extension InfoVC {
    private func getAbout() {
        
    }
    private func getTerms() {
        self.showIndicator()
        SettingRouter.terms.send { [weak self] (response: APIGenericResponse<String>) in
            guard let self = self else {return}
            self.textView.text = response.data?.htmlToAttributedString?.string
        }
    }
    private func getPrivacy() {
        self.showIndicator()
        SettingRouter.policy.send { [weak self] (response: APIGenericResponse<String>) in
            guard let self = self else {return}
            self.textView.text = response.data?.htmlToAttributedString?.string
        }
    }
}
