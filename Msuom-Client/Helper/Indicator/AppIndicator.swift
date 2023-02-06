//
//  AppIndicator.swift
//
//  Created by MGAbouarab®
//

import UIKit

class AppIndicator {
    
    //MARK: - properties -
    private let indicatorContainer: UIView  = UIView()
    private let indicatorView: UIView = UIView()
    private let indicatorImageView: UIImageView = UIImageView()
    private let length: CGFloat = UIScreen.main.bounds.width * 0.2
    private let innerLength: CGFloat = UIScreen.main.bounds.width * 0.2
    private let duration: TimeInterval = 1.4
    private var timer: Timer?
    private let tag: Int = 19920301
    
    static let shared: AppIndicator = AppIndicator()
    
    //MARK: - Initializer -
    private init() {}
    
    
    //MARK: - Private Methods -
    private func handleInitialView(isGif: Bool) {
        
        self.indicatorContainer.tag = self.tag
        self.indicatorContainer.alpha = 0
        self.indicatorContainer.backgroundColor = .black.withAlphaComponent(0.2)
        self.indicatorView.backgroundColor = .clear
        self.indicatorImageView.contentMode = .scaleAspectFit
        if isGif {
            self.indicatorImageView.image = UIImage.gifImageWithName("indicatorGifImage")
        } else {
            self.indicatorImageView.image = UIImage(named: "AppIcon")
        }
        self.indicatorView.layer.cornerRadius = 15
        self.indicatorView.clipsToBounds = true
        
        self.indicatorView.addSubview(self.indicatorImageView)
        self.indicatorContainer.addSubview(self.indicatorView)
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        window.addSubview(self.indicatorContainer)
        
        //MARK:- Add constraints
        self.indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.indicatorContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        self.indicatorContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        self.indicatorView.heightAnchor.constraint(equalToConstant: self.length).isActive = true
        self.indicatorView.widthAnchor.constraint(equalToConstant: self.length).isActive = true
        self.indicatorView.centerYAnchor.constraint(equalTo: self.indicatorContainer.centerYAnchor).isActive = true
        self.indicatorView.centerXAnchor.constraint(equalTo: self.indicatorContainer.centerXAnchor).isActive = true
        
        self.indicatorImageView.heightAnchor.constraint(equalToConstant: self.innerLength).isActive = true
        self.indicatorImageView.widthAnchor.constraint(equalToConstant: self.innerLength).isActive = true
        self.indicatorImageView.centerYAnchor.constraint(equalTo: self.indicatorView.centerYAnchor).isActive = true
        self.indicatorImageView.centerXAnchor.constraint(equalTo: self.indicatorView.centerXAnchor).isActive = true
        
        
        var x = 0.05
        for _ in 0 ... 4 {
            x += 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + x) {
                
                let pulse = PulseAnimation(numberOfPulse: Float.infinity, radius: 150, position: self.indicatorView.center)
                pulse.animationDuration = 2.0
                pulse.backgroundColor = Theme.colors.mainColor.cgColor
                self.indicatorContainer.layer.insertSublayer(pulse, at: 0)
            }
        
        }
    }
    
    //MARK: - Action Methods -
    func show(isGif: Bool) {
        self.handleInitialView(isGif: isGif)
        UIView.animate(withDuration: 0.1) {
            self.indicatorContainer.alpha = 1
        }
    }
    func dismiss() {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        UIView.animate(withDuration: 0.2) {
            window.viewWithTag(self.tag)?.alpha = 0
        } completion: { _ in
            window.viewWithTag(self.tag)?.removeFromSuperview()
        }
    }
    
}
