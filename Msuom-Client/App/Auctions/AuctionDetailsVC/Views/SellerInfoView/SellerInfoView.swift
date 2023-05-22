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
    
    //MARK: - Properties -
    private var pdfLink: String?
    private var bidId: String?
    private var providerId: String?
    
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
        
    }
    func set(name: String?, address: String?, image: String?, pdfLink: String?, bidId: String?, providerId: String?) {
        self.imageView.setWith(string: image)
        self.nameLabel.text = name
        self.addressLabel.text = address
        self.pdfLink = pdfLink
        self.bidId = bidId
        self.providerId = providerId
    }
    
    //MARK: - Encapsulation -
    
    
    
    //MARK: - Action -
    @objc private func openPDF() {
        AppHelper.openUrl(self.pdfLink)
    }
    @objc private func requestReport() {
        guard let bidId, let providerId else {return}
        self.summaryReport(bidId: bidId, providerId: providerId)
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
}
