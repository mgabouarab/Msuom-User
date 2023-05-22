//
//  PurchaseOrderVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 08/02/2023.
//
//  Template by MGAbouarab®


import UIKit

class PurchaseOrderVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var deliveryPriceLabel: UILabel!
    @IBOutlet weak private var isFinancingLabel: UILabel!
    @IBOutlet weak private var amountToBePaidLabel: UILabel!
    @IBOutlet weak private var waitingView: UIView!
    @IBOutlet weak private var payStack: UIStackView!
    @IBOutlet weak private var acceptRefuseStackView: UIStackView!
    @IBOutlet weak private var deliveryPriceView: CardView!
    
    //MARK: - Properties -
    private var data: PurchaseOrderDetails?
    private var id: String?
    
    //MARK: - Creation -
    static func create(data: PurchaseOrderDetails?, id: String?) -> PurchaseOrderVC {
        let vc = AppStoryboards.orders.instantiate(PurchaseOrderVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.data = data
        vc.id = id
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        if let data = self.data {
            self.setViewWith(data: data)
        } else if let id = self.id {
            self.getDetailsFor(order: id)
        }
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Order Details".localized)
    }
    
    //MARK: - Logic Methods -
    func setViewWith(data: PurchaseOrderDetails) {
        let items = [data.typeName, data.brandName, data.year].compactMap({$0})
        imageView.setWith(string: data.image)
        nameLabel.text = items.joined(separator: " ")
        priceLabel.text = "Cash price:".localized + " \(data.price ?? 0) \(data.currency ?? appCurrency)"
        deliveryPriceLabel.text = "\(data.deliveryPrice ?? 0) \(data.currency ?? appCurrency)"
        amountToBePaidLabel.text = "\(data.price ?? 0) \(data.currency ?? appCurrency)"
        isFinancingLabel.text = data.isFinancing
        if let status = data.orderStatus, let orderStatus = OrderStatus(rawValue: status) {
            switch orderStatus {
            case .waitForAccept:
                self.waitingView.isHidden = false
                self.payStack.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.deliveryPriceView.isHidden = true
            case .acceptOrder:
                self.waitingView.isHidden = true
                self.payStack.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.deliveryPriceView.isHidden = true
            case .sendOffer:
                self.waitingView.isHidden = true
                self.payStack.isHidden = true
                self.acceptRefuseStackView.isHidden = false
                self.deliveryPriceView.isHidden = false
            case .rejectOrder:
                self.waitingView.isHidden = true
                self.payStack.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.deliveryPriceView.isHidden = true
            case .waitForPay:
                self.waitingView.isHidden = true
                self.payStack.isHidden = false
                self.acceptRefuseStackView.isHidden = true
                self.deliveryPriceView.isHidden = false
            case .processing:
                self.waitingView.isHidden = true
                self.payStack.isHidden = false
                self.acceptRefuseStackView.isHidden = true
                self.deliveryPriceView.isHidden = false
            case .finishOrder:
                self.waitingView.isHidden = true
                self.payStack.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.deliveryPriceView.isHidden = false
            }
        }
    }
    
    //MARK: - Actions -
    @IBAction private func payButtonPressed() {
        if let id = self.data?.id, let price = self.data?.price, let paymentMethod = self.data?.paymentMethod {
            self.payOrder(id: id, paymentMethod: paymentMethod, price: "\(price)")
        }
    }
    @IBAction private func acceptButtonPressed() {
        if let id = self.data?.id {
            self.acceptRejectOffer(id: id, status: "accept")
        } else if let id = self.id {
            self.acceptRejectOffer(id: id, status: "accept")
        }
    }
    @IBAction private func rejectButtonPressed() {
        if let id = self.data?.id {
            self.acceptRejectOffer(id: id, status: "reject")
        } else if let id = self.id {
            self.acceptRejectOffer(id: id, status: "reject")
        }
    }
    
}


//MARK: - Networking -
extension PurchaseOrderVC {
    private func getDetailsFor(order id: String) {
        self.showIndicator()
        OrderRouter.detailsOrder(id: id).send { [weak self] (response: APIGenericResponse<PurchaseOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
    private func payOrder(id: String, paymentMethod: String, price: String) {
        self.showIndicator()
        OrderRouter.payOrder(id: id, paymentMethod: paymentMethod, price: price).send { [weak self] (response: APIGenericResponse<PurchaseOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
    private func acceptRejectOffer(id: String, status: String) {
        self.showIndicator()
        OrderRouter.acceptRejectOffer(id: id, status: status).send { [weak self] (response: APIGenericResponse<PurchaseOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
}

//MARK: - Routes -
extension PurchaseOrderVC {
    
}

