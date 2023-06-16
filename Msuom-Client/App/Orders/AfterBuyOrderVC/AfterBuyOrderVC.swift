//
//  AfterBuyOrderVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 04/06/2023.
//

import UIKit

class AfterBuyOrderVC: BaseVC {
    
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
    @IBOutlet weak private var orderStatusLabel: UILabel!
    @IBOutlet weak private var priceView: UIView!
    @IBOutlet weak private var servicesLabel: UILabel!
    @IBOutlet weak private var currentStatusLabel: UILabel!
    
    //MARK: - Properties -
    private var data: ShippingOrderDetails?
    private var id: String?
    private var items: [PaymentModel] = []
    
    //MARK: - Creation -
    static func create(data: ShippingOrderDetails?, id: String?) -> AfterBuyOrderVC {
        let vc = AppStoryboards.orders.instantiate(AfterBuyOrderVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.data = data
        vc.id = id
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
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
//        self.orderStatusLabel.text = data.orderStatusTxt
        self.servicesLabel.text = data.services
        self.currentStatusLabel.text = data.orderStatusTxt
        if let status = data.orderStatus, let orderStatus = OrderStatus(rawValue: status) {
            switch orderStatus {
            case .waitForAccept:
                self.confirmView.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.paymentView.isHidden = true
                self.orderStatusLabel.isHidden = false
                self.priceView.isHidden = true
            case .waitForPay:
                self.confirmView.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.paymentView.isHidden = false
                self.orderStatusLabel.isHidden = true
                self.priceView.isHidden = false
                self.getPaymentMethods()
            case .finishOrder:
                self.confirmView.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.paymentView.isHidden = true
                self.orderStatusLabel.isHidden = false
                self.priceView.isHidden = false
            case .sendOffer:
                self.confirmView.isHidden = true
                self.acceptRefuseStackView.isHidden = true
                self.paymentView.isHidden = true
                self.orderStatusLabel.isHidden = true
                self.priceView.isHidden = true
            }
        }
        self.setVisibility(data: data)
        
    }
    
    private func setVisibility(data: ShippingOrderDetails) {
        
        paymentView.isHidden = !(data.orderStatus == OrderStatus.waitForPay.rawValue)
        priceView.isHidden = !(data.orderStatus != OrderStatus.waitForAccept.rawValue)
        confirmView.isHidden = !(data.orderStatus == OrderStatus.waitForPay.rawValue)
        orderStatusLabel.isHidden = !(data.orderStatus == OrderStatus.waitForAccept.rawValue)
//        pdfFileView.isHidden = !(data.orderStatus == OrderStatus.finishOrder.rawValue)
        acceptRefuseStackView.isHidden = !(data.orderStatus == OrderStatus.sendOffer.rawValue)
        
//        priceView.isHidden = !(data.orderStatus != OrderStatus.waitForAccept.rawValue) //&& data.isDelivery == true)
        
//        cvNotes.isHidden = !(data.orderStatus == OrderStatus.finishOrder.rawValue)
        
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
        if let id = self.data?.id, let price = self.data?.price, let paymentMethod = self.items.first(where: {$0.isSelected == true})?.slug {
            self.payOrder(id: id, paymentMethod: paymentMethod, price: "\(price)")
        }
    }
    
}


//MARK: - Networking -
extension AfterBuyOrderVC {
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
        if status == "accept" {
            OrderRouter.acceptRejectOffer(id: id, status: status).send { [weak self] (response: APIGenericResponse<ShippingOrderDetails>) in
                guard let self = self, let data = response.data else {return}
                self.data = data
                self.setViewWith(data: data)
            }
        } else {
            OrderRouter.acceptRejectOffer(id: id, status: status).send { [weak self] (response: APIGlobalResponse) in
                guard let self = self else {return}
                self.showSuccessAlert(message: response.message)
                self.pop()
            }
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
    private func getPaymentMethods() {
        self.showIndicator()
        SettingRouter.paymentMethods.send { [weak self] (response: APIGenericResponse<[PaymentModel]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            if let selectedPaymentMethod = self.data?.paymentMethod, let index = self.items.firstIndex(where: {$0.slug == selectedPaymentMethod}) {
                self.items[index].isSelected = true
            } else {
                if !self.items.isEmpty {
                    self.items[0].isSelected = true
                }
            }
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension AfterBuyOrderVC {
    
}

//MARK: - Start Of TableView -
extension AfterBuyOrderVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: TryToBuyCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension AfterBuyOrderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TryToBuyCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension AfterBuyOrderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in self.items.indices {
            self.items[index].isSelected = false
        }
        self.items[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
//MARK: - End Of TableView -

