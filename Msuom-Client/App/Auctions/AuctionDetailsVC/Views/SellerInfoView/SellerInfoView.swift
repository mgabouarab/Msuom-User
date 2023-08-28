//
//  SellerInfoView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class SellerInfoView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var imageView: BorderedImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var showPDFView: UIView!
    @IBOutlet weak private var requestReportView: UIView!
    @IBOutlet weak private var refundView: UIView!
    
    //MARK: - Properties -
    private var pdfLink: String?
    private var bidId: String?
    private var providerId: String?
    private var isSubscribe: Bool = false
    
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
        let nib = UINib(nibName: "SellerInfoView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        
//        requestReportView.isHidden = !(UserDefaults.user?.userType == "user")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openPDF))
        self.showPDFView.addGestureRecognizer(tap)
        
        let requestReportTap = UITapGestureRecognizer(target: self, action: #selector(self.requestReport))
        self.requestReportView.addGestureRecognizer(requestReportTap)
        let providerTap = UITapGestureRecognizer(target: self, action: #selector(self.openProviderPage))
        self.imageView.addGestureRecognizer(providerTap)
        let refundTap = UITapGestureRecognizer(target: self, action: #selector(self.requestRefund))
        self.refundView.addGestureRecognizer(refundTap)
        
    }
    func set(name: String?, address: String?, image: String?, pdfLink: String?, bidId: String?, providerId: String?, isRefund: Bool, isSubscribe: Bool) {
        self.imageView.setWith(string: image)
        self.nameLabel.text = name
        self.addressLabel.text = address
        self.pdfLink = pdfLink
        self.bidId = bidId
        self.providerId = providerId
        self.refundView.isVisible = isRefund
        self.isSubscribe = isSubscribe
    }
    
    //MARK: - Encapsulation -
    
    
    
    //MARK: - Action -
    @objc private func openProviderPage() {
        guard let providerId = providerId else {return}
        let vc = ProviderDetailsVC.create(providerDetails: nil, id: providerId)
        self.parentContainerViewController?.show(vc, sender: self)
    }
    @objc private func openPDF() {
        AppHelper.openUrl(self.pdfLink)
    }
    @objc private func requestReport() {
        
        guard self.isSubscribe else {
            AppAlert.showErrorAlert(error: "Please Subscribe first".localized)
            return
        }
        
        guard UserDefaults.isLogin else {
            (self.parentContainerViewController as? BaseVC)?.showLogoutAlert { [weak self] in
                (self?.parentContainerViewController as? BaseVC)?.presentLogin()
            }
            return
        }
        
        (self.parentContainerViewController as? BaseVC)?.showConfirmation(message: "Are you sure to continue?".localized) { [weak self] in
            guard let self = self else {return}
            guard let bidId, let providerId else {return}
            self.summaryReport(bidId: bidId, providerId: providerId)
        }
    }
    @objc private func requestRefund() {
        (self.parentContainerViewController as? BaseVC)?.showConfirmation(message: "Are you sure to continue?".localized) { [weak self] in
            guard let self = self else {return}
            guard let bidId, let providerId else {return}
            self.refund(bidId: bidId, providerId: providerId)
        }
    }
    
    
}

extension SellerInfoView {
    private func summaryReport(bidId: String, providerId: String) {
        AppIndicator.shared.show(isGif: false)
        AuctionRouter.summaryReport(bidId: bidId, providerId: providerId).send { [weak self] (response: APIGlobalResponse) in
            guard let _ = self else {return}
            AppAlert.showSuccessAlert(message: response.message)
        }
    }
    private func refund(bidId: String, providerId: String) {
        AppIndicator.shared.show(isGif: false)
        AuctionRouter.refund(bidId: bidId, providerId: providerId).send { [weak self] (response: APIGlobalResponse) in
            guard let _ = self else {return}
            AppAlert.showSuccessAlert(message: response.message)
        }
    }
}

extension UIView {
    var isVisible: Bool {
        get {
            !self.isHidden
        }
        set {
            self.isHidden = !newValue
        }
    }
}
