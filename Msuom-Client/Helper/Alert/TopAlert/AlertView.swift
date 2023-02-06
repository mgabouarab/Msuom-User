//
//  AlertView.swift
//
//  Created by MGAbouarab®
//

import UIKit

class AlertView: UIView {

    //MARK: - IBOutlets -
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Properties -
    private var isLongPressActive: Bool = false
    private var isSwipePerformed: Bool = false
    
    //MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    //MARK: - Design -
    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else {return}
        viewFromXib.frame = self.bounds
        self.addSubview(viewFromXib)
        self.setupDesign()
        self.setupSwipes()
    }
    private func setupDesign() {
        self.setupCard()
        self.setupBlur()
        self.imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.alertView.transform = CGAffineTransform(translationX: 0, y: -self.alertView.bounds.height * 2)
        self.backgroundColor = .clear
        self.clipsToBounds = false
    }
    private func setupCard() {
        self.alertView.layer.cornerRadius = 16
        self.alertView.layer.shadowColor = Theme.colors.shadowColor
        self.alertView.clipsToBounds = true
    }
    private func setupBlur() {
        self.alertView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.85
        blurEffectView.frame = self.alertView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.alertView.addSubview(blurEffectView)
        self.alertView.sendSubviewToBack(blurEffectView)
        blurEffectView.backgroundColor = .clear
    }
    private func setupSwipes() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.alertView.addGestureRecognizer(swipeUp)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.alertView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    //MARK: - Data -
    func set(message: String, type: AlertType) {
        self.alertLabel.text = message
        self.alertLabel.textColor = Theme.colors.whiteColor
        self.imageView.image = UIImage(named: type.image)
    }
    
    //MARK: - Animations -
    func showAnimate(){
        self.alertView.transform = CGAffineTransform(translationX: 0, y: -self.alertView.bounds.height * 2)
        self.backgroundColor = .clear
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.alertView.transform = .identity
            UIView.animate(withDuration: 0.15, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .allowAnimatedContent) {
                self.imageView.transform = .identity
            }
        } completion: { [weak self] _ in
            guard let self = self else {return}

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if !self.isLongPressActive, !self.isSwipePerformed {
                    self.removeAnimate()
                }
            }
        }
    }
    private func removeAnimate(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alertView.transform = CGAffineTransform(translationX: 0, y: -self.alertView.bounds.height * 2)
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.isLongPressActive = false
                self.isSwipePerformed = false
                self.removeFromSuperview()
            }
        })
    }
    
    //MARK: - Actions -
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        self.isLongPressActive = true
        if sender.state == UIGestureRecognizer.State.ended {
            self.removeAnimate()
        }
    }
    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) {
        self.isSwipePerformed = true
        if gesture.direction == .up || gesture.direction == .down {
            self.removeAnimate()
        }
    }
    
}
