//
//  ConfirmationPayVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/06/2023.
//

import UIKit

protocol ConfirmationPayDelegate {
    func didConfirm()
}

class ConfirmationPayVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var dismissImageView: UIImageView!
    @IBOutlet weak private var sheetView: UIView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    //MARK: - Properties -
    private lazy var sheetHeight: CGFloat = self.sheetView.bounds.height
    private var delegate: ConfirmationPayDelegate!
    private var price: String!
    
    //MARK: - Creation -
    static func create(delegate: ConfirmationPayDelegate, price: String) -> ConfirmationPayVC {
        let vc = AppStoryboards.cars.instantiate(ConfirmationPayVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = delegate
        vc.price = price
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupPanGesture()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showAnimate()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "".localized
        self.view.backgroundColor = Theme.colors.blackColor.withAlphaComponent(0.2)
        
        self.descriptionLabel.text = "Please note that a deposit of".localized + " \(self.price ?? "")" + " SAR is required to be able to make the purchase".localized
        self.sheetView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeAnimate))
        self.dismissImageView.addGestureRecognizer(tap)
        self.dismissImageView.isUserInteractionEnabled = true
        
    }
    private func showAnimate(){
        self.sheetView.transform = CGAffineTransform(translationX: 0, y: self.sheetView.bounds.height)
        self.sheetView.alpha = 1
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            self.sheetView.transform = .identity
        }
    }
    @objc private func removeAnimate(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.sheetView.transform = CGAffineTransform(translationX: 0, y: self.sheetView.bounds.height)
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.dismiss(animated: false) {
                    self.delegate?.didConfirm()
                }
            }
        })
    }
    
    //MARK: - Logic Methods -
    
    // MARK: - Pan gesture handler -
    private func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        sheetView.addGestureRecognizer(panGesture)
    }
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: sheetView)
        let newHeight = sheetHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < sheetHeight {
                self.sheetView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            
            if newHeight < sheetHeight * 0.35 {
                self.removeAnimate()
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.sheetView.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    
    //MARK: - Actions -
    @IBAction private func confirmButtonPressed() {
        self.removeAnimate()
    }
}
