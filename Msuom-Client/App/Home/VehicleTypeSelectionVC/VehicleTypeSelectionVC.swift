//
//  VehicleTypeSelectionVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/11/2022.
//

import UIKit

protocol VehicleTypeSelectionDelegate {
    func didSelect(type: VehicleTypeSelectionVC.VehicleTypes)
}

class VehicleTypeSelectionVC: UIViewController {
    
    enum VehicleTypes {
        case ads
        case auction
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var dismissView: UIView!
    @IBOutlet weak private var containerView: UIView!
    
    //MARK: - Proprieties -
    private var delegate: VehicleTypeSelectionDelegate!
    
    //MARK: - Creation -
    static func create(delegate: VehicleTypeSelectionDelegate) -> VehicleTypeSelectionVC {
        let vc = AppStoryboards.home.instantiate(VehicleTypeSelectionVC.self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = delegate
        return vc
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDismissGesture()
        self.setupInitialDesign()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.containerView.transform = .identity
            self.dismissView.alpha = 0.2
        }
    }
    
    //MARK: - Design -
    private func setupInitialDesign(withDuration: CGFloat = 0, completion: (()->())? = nil) {
        
        UIView.animate(withDuration: withDuration) {
            let height = UIScreen.main.bounds.height
            self.containerView.transform = CGAffineTransform(translationX: 0, y: height)
            self.dismissView.alpha = 0
        } completion: { _ in
            completion?()
        }
        
        
    }
    private func addDismissGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapDismissView))
        self.dismissView.addGestureRecognizer(tap)
    }
    
    
    //MARK: - Actions -
    @objc private func didTapDismissView() {
        
        self.setupInitialDesign(withDuration: 0.5) {
            self.dismiss(animated: true)
        }
        
    }
    @IBAction private func auctionButtonPressed() {
        
        self.setupInitialDesign(withDuration: 0.5) {
            self.dismiss(animated: true) {
                self.delegate.didSelect(type: .auction)
            }
        }
        
    }
    @IBAction private func adButtonPressed() {
        
        self.setupInitialDesign(withDuration: 0.5) {
            self.dismiss(animated: true) {
                self.delegate.didSelect(type: .ads)
            }
        }
    }
    
}
