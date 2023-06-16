//
//  HeaderView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/11/2022.
//

import UIKit

class HeaderView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var searchView: UIView!
    @IBOutlet weak private var notificationButton: UIButton!
    @IBOutlet weak private var scannerButton: UIButton!
    
    //MARK: - Initializer -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    
    private func xibSetUp() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HeaderView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.searchViewTapped))
        self.searchView.addGestureRecognizer(tap)
        self.addObservers()
        self.handleButtons()
    }
    private func handleButtons() {
        if UserDefaults.isLogin {
            self.notificationButton.isHidden = false
            self.scannerButton.isHidden = false
        } else {
            self.notificationButton.isHidden = true
            self.scannerButton.isHidden = true
        }
    }
    
    //MARK: - Actions -
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateChildrenDependingOnUserLoginStatus), name: .isLoginChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCountDidChanged), name: .notificationNumberChanged, object: nil)
    }
    @objc private func updateChildrenDependingOnUserLoginStatus() {
        self.handleButtons()
    }
    @objc private func notificationCountDidChanged() {
        self.notificationButton.setImage(
            UIImage(named: UserDefaults.notificationCount == 0 ? "notificationButton" : "notificationButtonUnRead"),
            for: .normal
        )
    }
    @objc private func searchViewTapped() {
        let vc = SearchVC.create()
        self.parentContainerViewController?.show(vc, sender: nil)
    }
    @IBAction private func notificationButtonPressed() {
        guard UserDefaults.isLogin else {
            AppAlert.showLogoutAlert {
                let vc = LoginVC.create()
                let nav = BaseNav(rootViewController: vc)
                self.parentContainerViewController?.present(vc, animated: true)
            }
            return
        }
        let vc = NotificationsVC.create()
        self.parentContainerViewController?.show(vc, sender: nil)
    }
    @IBAction private func scannerButtonPressed() {
//        AppAlert.showLogoutAlert {
//            let vc = LoginVC.create()
//            let nav = BaseNav(rootViewController: vc)
//            self.parentContainerViewController?.present(vc, animated: true)
//        }
        let vc = ScannerViewController()
        vc.modalPresentationStyle = .fullScreen
        self.parentContainerViewController?.present(vc, animated: true)
    }
}
