//
//  TryToBuyVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/06/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class TryToBuyVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var deliveryView: UIView!
    @IBOutlet weak private var deliveryButton: UIButton!
    @IBOutlet weak private var addressView: SelectLocationView!
    @IBOutlet weak private var receiveView: UIView!
    @IBOutlet weak private var receiveButton: UIButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    //MARK: - Properties -
    private var items: [PaymentModel] = []
    private var isDelivery: Bool = true
    private var carId: String!
    private var price: String!
    private var providerId: String!
    
    
    //MARK: - Creation -
    static func create(carId: String, providerId: String, price: String) -> TryToBuyVC {
        let vc = AppStoryboards.cars.instantiate(TryToBuyVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.carId = carId
        vc.providerId = providerId
        vc.price = price
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.getPaymentMethods()
        self.handleTaps()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Try to sell".localized)
        self.deliveryViewTapped()
        self.scrollView.isHidden = true
    }
    private func handleTaps() {
        let deliveryTap = UITapGestureRecognizer(target: self, action: #selector(self.deliveryViewTapped))
        let receiveTapp = UITapGestureRecognizer(target: self, action: #selector(self.receiveViewTapped))
        
        self.deliveryView.addGestureRecognizer(deliveryTap)
        self.receiveView.addGestureRecognizer(receiveTapp)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func confirmButtonPressed() {
        if self.isDelivery {
            do {
                let _ = try ValidationService.validateLocation(
                    address: self.addressView.address(),
                    lat: self.addressView.value()?.latitude,
                    long: self.addressView.value()?.longitude
                )
            } catch {
                self.showErrorAlert(error: error.localizedDescription)
                return
            }
        }
        self.purchaseOrders(
            carId: self.carId,
            providerId: self.providerId,
            isDelivery: self.isDelivery,
            latitude: self.addressView.value()?.latitude,
            longitude: self.addressView.value()?.longitude,
            address:  self.addressView.address(),
            paymentMethod: self.items.first(where: {$0.isSelected == true})?.slug ?? "",
            price: self.price
        )
    }
    @objc
    private func deliveryViewTapped() {
        self.isDelivery = true
        self.deliveryButton.isSelected = true
        self.receiveButton.isSelected = false
        self.addressView.isHidden = false
    }
    @objc
    private func receiveViewTapped() {
        self.isDelivery = false
        self.deliveryButton.isSelected = false
        self.receiveButton.isSelected = true
        self.addressView.set(file: nil)
        self.addressView.isHidden = true
    }
    
}


//MARK: - Start Of TableView -
extension TryToBuyVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: TryToBuyCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension TryToBuyVC: UITableViewDataSource {
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
extension TryToBuyVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in self.items.indices {
            self.items[index].isSelected = false
        }
        self.items[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension TryToBuyVC {
    private func getPaymentMethods() {
        self.showIndicator()
        SettingRouter.paymentMethods.send { [weak self] (response: APIGenericResponse<[PaymentModel]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            if !self.items.isEmpty {
                self.items[0].isSelected = true
            }
            self.tableView.reloadData()
            self.scrollView.isHidden = false
        }
    }
    private func purchaseOrders(
        carId: String,
        providerId: String,
        isDelivery: Bool,
        latitude: Double?,
        longitude: Double?,
        address: String?,
        paymentMethod: String,
        price: String
    ) {
        self.showIndicator()
        CarRouter.purchaseOrders(
            carId: carId,
            providerId: providerId,
            isDelivery: isDelivery,
            latitude: latitude,
            longitude: longitude,
            address: address,
            paymentMethod: paymentMethod,
            price: price).send { [weak self] (response: APIGlobalResponse) in
                guard let self = self else {return}
                self.showSuccessAlert(message: response.message)
                self.pop()
            }
    }
}

//MARK: - Routes -
extension TryToBuyVC {
    
}

struct PaymentModel: Codable {
    let paymentId: String
    let name: PaymentModelName
    let slug: String
    let uploads: String
    let status: String
    let timeAdd: String
    var isSelected: Bool?
}

struct PaymentModelName: Codable {
    let ar: String
    let en: String
}
