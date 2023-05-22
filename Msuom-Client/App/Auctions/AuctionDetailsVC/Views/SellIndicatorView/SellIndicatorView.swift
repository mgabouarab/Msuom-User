//
//  SellIndicatorView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class SellIndicatorView: UIView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var progressView: UIProgressView!
    @IBOutlet weak private var detailsButton: UIButton!
    
    //MARK: - Properties -
    var detailsAction: (()->())?
    
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
        let nib = UINib(nibName: "SellIndicatorView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        
    }
    
    func set(progress: String?) {
        
        guard let progress = progress else {
            self.progressView.progress = 0
            self.progressView.progressTintColor = Theme.colors.errorColor
            return
        }
        
        
        let doubleProgress = progress.toDouble()/100
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else {return}
            self.progressView.setProgress(Float(doubleProgress), animated: true)
            switch doubleProgress {
            case 0 ..< 0.25:
                self.progressView.progressTintColor = Theme.colors.errorColor
            case 0.25 ..< 0.5:
                self.progressView.progressTintColor = Theme.colors.c
            case 0.5 ..< 0.75:
                self.progressView.progressTintColor = Theme.colors.b
            case 0.75 ..< 1:
                self.progressView.progressTintColor = Theme.colors.a
                
            default:
                self.progressView.progress = Float(doubleProgress)
                self.progressView.progressTintColor = .clear
            }
        }
        
    }
    func setDetailsButton(isHidden: Bool) {
        self.detailsButton.isHidden = isHidden
    }
    
    //MARK: - Encapsulation -
    
    
    
    //MARK: - Action -
    @IBAction private func detailsButtonPressed() {
        self.detailsAction?()
    }
    
}
