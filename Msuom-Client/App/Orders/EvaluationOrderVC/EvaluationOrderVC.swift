//
//  EvaluationOrderVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 08/02/2023.
//
//  Template by MGAbouarab®


import UIKit

class EvaluationOrderVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var brandLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var walkwayLabel: UILabel!
    @IBOutlet weak private var orderNumberLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var notesLabel: UILabel!
    @IBOutlet weak private var waitingView: UIView!
    @IBOutlet weak private var infoView: UIView!
    
    @IBOutlet weak private var acceptRefuseStackView: UIStackView!
    @IBOutlet weak private var paymentView: UIView!
    @IBOutlet weak private var tableView: TableViewContentSized!
    @IBOutlet weak private var confirmView: UIView!
    @IBOutlet weak private var orderStatusLabel: UILabel!
    @IBOutlet weak private var priceView: UIView!
    @IBOutlet weak private var notesView: UIView!
    @IBOutlet weak private var pdfFileView: UIView!
    @IBOutlet weak private var yearLabel: UILabel!
    @IBOutlet weak private var currentStatusLabel: UILabel!
    
    //MARK: - Properties -
    private var data: EvaluationOrderDetails?
    private var id: String?
    private var items: [PaymentModel] = []
    
    //MARK: - Creation -
    static func create(data: EvaluationOrderDetails?, id: String?) -> EvaluationOrderVC {
        let vc = AppStoryboards.orders.instantiate(EvaluationOrderVC.self)
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
    }
    
    //MARK: - Logic Methods -
    func setViewWith(data: EvaluationOrderDetails) {
        self.brandLabel.text = data.brandName
        self.typeLabel.text = data.typeName
        self.categoryLabel.text = data.categoryName
        self.statusLabel.text = data.statusName
        self.walkwayLabel.text = data.walkway
        self.orderNumberLabel.text = "Order Number:".localized + " " + "\(data.orderNo ?? 0)"
        self.priceLabel.text = "\(data.deliveryPrice ?? 0) \(data.currency ?? appCurrency)"
        self.notesLabel.text = data.notes
        self.yearLabel.text = data.year
        self.currentStatusLabel.text = data.orderStatusTxt
        if let status = data.orderStatus, let orderStatus = OrderStatus(rawValue: status) {
            switch orderStatus {
            case .waitForPay:
                self.getPaymentMethods()
            default:
                self.waitingView.isHidden = true
                self.infoView.isHidden = false
            }
        }
        self.setVisibility(data: data)
        
    }
    private func setVisibility(data: EvaluationOrderDetails) {
        
        paymentView.isHidden = !(data.orderStatus == OrderStatus.waitForPay.rawValue)
        priceView.isHidden = !(data.orderStatus != OrderStatus.waitForAccept.rawValue)
        confirmView.isHidden = !(data.orderStatus == OrderStatus.waitForPay.rawValue)
        orderStatusLabel.isHidden = !(data.orderStatus == OrderStatus.waitForAccept.rawValue)
        pdfFileView.isHidden = !(data.orderStatus == OrderStatus.finishOrder.rawValue)
        acceptRefuseStackView.isHidden = !(data.orderStatus == OrderStatus.sendOffer.rawValue)
        
//        priceView.isHidden = !(data.orderStatus != OrderStatus.waitForAccept.rawValue) //&& data.isDelivery == true)
        
        notesView.isHidden = !(data.orderStatus == OrderStatus.finishOrder.rawValue && data.notes != "")
        
    }
    
    //MARK: - Actions -
    @IBAction private func pdfButtonPressed() {
        guard let pdfLink = self.data?.attach else {return}
        AppHelper.openUrl(pdfLink)
    }
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
        if let id = self.data?.id, let price = self.data?.deliveryPrice, let paymentMethod = self.items.first(where: {$0.isSelected == true})?.slug {
            self.payOrder(id: id, paymentMethod: paymentMethod, price: "\(price)")
        }
    }
    
}


//MARK: - Networking -
extension EvaluationOrderVC {
    private func getDetailsFor(order id: String) {
        self.showIndicator()
        OrderRouter.detailsOrder(id: id).send { [weak self] (response: APIGenericResponse<EvaluationOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
    private func acceptRejectOffer(id: String, status: String) {
        self.showIndicator()
        if status == "accept" {
            OrderRouter.acceptRejectOffer(id: id, status: status).send { [weak self] (response: APIGenericResponse<EvaluationOrderDetails>) in
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
        OrderRouter.payOrder(id: id, paymentMethod: paymentMethod, price: price).send { [weak self] (response: APIGenericResponse<EvaluationOrderDetails>) in
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
extension EvaluationOrderVC {
    
}

//MARK: - Start Of TableView -
extension EvaluationOrderVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: TryToBuyCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension EvaluationOrderVC: UITableViewDataSource {
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
extension EvaluationOrderVC: UITableViewDelegate {
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
