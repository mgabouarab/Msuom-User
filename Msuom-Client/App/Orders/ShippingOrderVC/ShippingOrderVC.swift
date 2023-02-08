//
//  ShippingOrderVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 08/02/2023.
//
//  Template by MGAbouarab®


import UIKit

enum OrderStatus: String {
    case waitForAccept
    case waitForPay
    case finishOrder
}

class ShippingOrderVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    @IBOutlet weak private var orderNumberLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var acceptRefuseStackView: UIStackView!
    @IBOutlet weak private var paymentView: UIView!
    @IBOutlet weak private var tableView: TableViewContentSized!
    @IBOutlet weak private var confirmView: UIView!
    
    
    //MARK: - Properties -
    private var data: ShippingOrderDetails?
    private var id: String?
    
    //MARK: - Creation -
    static func create(data: ShippingOrderDetails?, id: String?) -> ShippingOrderVC {
        let vc = AppStoryboards.orders.instantiate(ShippingOrderVC.self)
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
        self.confirmView.clipsToBounds = false
        self.confirmView.addShadow()
    }
    
    //MARK: - Logic Methods -
    func setViewWith(data: ShippingOrderDetails) {
        self.imageView.setWith(string: data.image)
        let items = [data.typeName, data.brandName, data.year].compactMap({$0})
        self.titleLabel.text = items.joined(separator: " ")
        self.bodyLabel.text = data.description
        self.orderNumberLabel.text = "Ad Number:".localized + " " + "\(data.orderNo ?? 0)"
        self.priceLabel.text = "\(data.deliveryPrice ?? 0) \(data.currency ?? appCurrency)"
        if let status = data.orderStatus, let orderStatus = OrderStatus(rawValue: status) {
            switch orderStatus {
            case .waitForAccept:
                self.confirmView.isHidden = true
                self.acceptRefuseStackView.isHidden = false
                self.paymentView.isHidden = true
            case .waitForPay:
                self.confirmView.isHidden = false
                self.acceptRefuseStackView.isHidden = true
                self.paymentView.isHidden = false
            case .finishOrder:
                self.confirmView.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.paymentView.isHidden = true
            }
        }
    }
    
    //MARK: - Actions -
    @IBAction private func acceptButtonPressed() {
        if let id = self.data?.id {
            self.acceptRejectOffer(id: id, status: "accept")
        } else if let id = self.id {
            self.acceptRejectOffer(id: id, status: "accept")
        }
    }
    @IBAction private func refuseButtonPressed() {
        if let id = self.data?.id {
            self.acceptRejectOffer(id: id, status: "reject")
        } else if let id = self.id {
            self.acceptRejectOffer(id: id, status: "reject")
        }
    }
    @IBAction private func confirmButtonPressed() {
        if let id = self.data?.id, let price = self.data?.price, let paymentMethod = self.data?.paymentMethod {
            self.payOrder(id: id, paymentMethod: paymentMethod, price: "\(price)")
        }
    }
    
}


//MARK: - Networking -
extension ShippingOrderVC {
    private func getDetailsFor(order id: String) {
        self.showIndicator()
        OrderRouter.detailsOrder(id: id).send { [weak self] (response: APIGenericResponse<ShippingOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
    private func acceptRejectOffer(id: String, status: String) {
        self.showIndicator()
        OrderRouter.acceptRejectOffer(id: id, status: status).send { [weak self] (response: APIGenericResponse<ShippingOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
    private func payOrder(id: String, paymentMethod: String, price: String) {
        self.showIndicator()
        OrderRouter.payOrder(id: id, paymentMethod: paymentMethod, price: price).send { [weak self] (response: APIGenericResponse<ShippingOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
}

//MARK: - Routes -
extension ShippingOrderVC {
    
}
