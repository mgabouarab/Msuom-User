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
    }
    
    //MARK: - Actions -
    @objc private func searchViewTapped() {
        let vc = SearchVC.create()
        self.parentContainerViewController?.show(vc, sender: nil)
    }
    @IBAction private func notificationButtonPressed() {
        let vc = NotificationsVC.create()
        self.parentContainerViewController?.show(vc, sender: nil)
    }
    @IBAction private func scannerButtonPressed() {
        let vc = ScannerViewController()
        vc.modalPresentationStyle = .fullScreen
        self.parentContainerViewController?.present(vc, animated: true)
    }
}
