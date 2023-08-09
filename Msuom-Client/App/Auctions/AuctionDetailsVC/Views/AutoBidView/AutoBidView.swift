//
//  AutoBidView.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 23/05/2023.
//

import UIKit

class AutoBidView: UIView {
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var priceStackView: UIStackView!
    @IBOutlet weak private var autoBidView: UIView!
    @IBOutlet weak private var autoSwitch: UISwitch!
    @IBOutlet weak private var autoBidTextField: UITextField!
    @IBOutlet weak private var increaseAmountTextField: UITextField!
    @IBOutlet weak private var manualBidView: UIView!
    
    //MARK: - Properties -
    ///Auto
    private var isAutoEnabled: Bool = false {
        didSet {
            self.manualBidView.isHidden = isAutoEnabled
        }
    }
    var currentHighBid: Double = 0
    var isMyLastBid: Bool =  false
    ///Normal
    private var maxManualIncrease: Double = 500
    private var streamId: String?
    private var bidId: String?
    
    
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
        let nib = UINib(nibName: "AutoBidView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.priceStackView.addBorder()
        self.priceStackView.layer.cornerRadius = 8
        self.priceStackView.clipsToBounds = true
        self.increaseAmountTextField.delegate = self
    }
    
    //MARK: - Encapsulation -
    func set(isAutoEnabled: Bool, maxManualIncrease: Double, streamId: String, bidId: String, max: Double?) {
        self.autoBidView.isHidden = !isAutoEnabled
        self.autoSwitch.setOn(isAutoEnabled, animated: true)
        self.maxManualIncrease = maxManualIncrease
        self.increaseAmountTextField.text = "\(maxManualIncrease)"
        self.streamId = streamId
        self.bidId = bidId
        self.isAutoEnabled = isAutoEnabled
        self.autoBidTextField.text = "\(max ?? 0)"
    }
    
    
    //MARK: - Action -
    @IBAction private func switchToggle(_ sender: UISwitch) {
        self.autoBidView.isHidden = !sender.isOn
        self.manualBidView.isHidden = sender.isOn
        guard isAutoEnabled else {return}
        guard  let price = self.autoBidTextField.text?.toDouble() else {
            return
        }
        self.toggleAutoAuction(maxPrice: "\(price)")
    }
    @IBAction private func startAutoButtonPressed() {
        guard !isAutoEnabled else {
            return
        }
        guard  let price = self.autoBidTextField.text?.toDouble(), price > currentHighBid else {
            (self.parentContainerViewController as? BaseVC)?.showErrorAlert(error: "Price should be more than current heigh price".localized + " \(currentHighBid.toPrice())")
            return
        }
        
        self.toggleAutoAuction(maxPrice: "\(price)")
    }
    @IBAction private func increaseButtonPressed() {
        
        let currentPrice = self.increaseAmountTextField.text?.toDouble() ?? 0
        let newPrice = currentPrice + 500
        
//        guard self.maxManualIncrease >= newPrice else {return}
        
        self.increaseAmountTextField.text = (newPrice).toString()
    }
    @IBAction private func decreaseButtonPressed() {
        
        let currentPrice = self.increaseAmountTextField.text?.toDouble() ?? 0
        let newPrice = currentPrice - 500
        
        guard newPrice >= 500 else {
            self.increaseAmountTextField.text = (500.0).toString()
            return
        }
        
        self.increaseAmountTextField.text = (newPrice).toString()
        
    }
    @IBAction private func addManualBidButtonPressed() {
        guard let price = self.increaseAmountTextField.text?.toDouble() else {return}
        guard let streamId = self.streamId else {return}
        guard let bidId = self.bidId else {return}
        
        (self.parentContainerViewController as? BaseVC)?.showConfirmation(message: "Are you sure to continue?".localized) {
            SocketConnection.sharedInstance.sendBid(
                streamId: streamId,
                bidId: bidId,
                viewerId: UserDefaults.user?.id ?? "",
                price: "\(price)") {
                    print("🚦Socket:: suction Sent")
                    self.increaseAmountTextField.text = "1000"
                }
        }
        
    }
    @objc private func textDidChange(_ sender: UITextField) {
        guard let price = increaseAmountTextField.text?.toDouble() else {
            increaseAmountTextField.text = 500.0.toString()
            return
        }
        guard price > 500 else {
            increaseAmountTextField.text = 500.0.toString()
            return
        }
        guard price <= self.maxManualIncrease else {
            increaseAmountTextField.text = self.maxManualIncrease.toString()
            return
        }
    }
    
}

//MARK: - Networking -
extension AutoBidView {
    private func toggleAutoAuction(maxPrice: String) {
        guard let bidId = self.bidId else {return}
        AppIndicator.shared.show(isGif: false)
        AuctionRouter.checkAutoBid(bidId: bidId, maxPrice: maxPrice).send { [weak self] (response: APIGenericResponse<Bool>) in
            guard let self = self else {return}
            self.isAutoEnabled = response.data ?? false
            if !isMyLastBid {
                
                guard let streamId = self.streamId else {return}
                guard let bidId = self.bidId else {return}
                SocketConnection.sharedInstance.sendBid(
                    streamId: streamId,
                    bidId: bidId,
                    viewerId: UserDefaults.user?.id ?? "",
                    price: "\(maxManualIncrease)") {
                        print("🚦Socket:: suction Sent")
                    }
                
            }
        }
    }
}

//MARK: - Delegation -
extension AutoBidView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == increaseAmountTextField {
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(textDidChange(_:)), object: nil)
            perform(#selector(textDidChange), with: nil, afterDelay: 1)
        }
        
    }
}
