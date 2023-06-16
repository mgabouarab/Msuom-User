//
//  AfterSaleVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/05/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class AfterSaleVC: BaseVC {
    
    struct Service: Codable {
        let name: String
        let id: String
        var isSelected = false
    }
    
    enum AfterSaleType {
        
        case charge
        case service
        
        var title: String {
            switch self {
            case .charge:
                return "Charge Request".localized
            case .service:
                return "After sale Services".localized
            }
        }
        
        
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var chargeViewContainer: UIView!
    @IBOutlet weak private var serviceViewContainer: UIView!
    @IBOutlet weak private var deliveryView: UIView!
    @IBOutlet weak private var receiveView: UIView!
    
    @IBOutlet weak private var deliveryViewButton: UIButton!
    @IBOutlet weak private var receiveViewButton: UIButton!
    
    
    @IBOutlet weak private var chargeAddressView: SelectLocationView!
    @IBOutlet weak private var serviceAddressView: SelectLocationView!
    
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var adNumberLabel: UILabel!
    
    
    
    
    //MARK: - Properties -
    private var items: [Service] = []
    private var type: AfterSaleType = .charge
    private var data: BidDetails.HomeSoonAuction?
    private var isDelivery: Bool = true {
        didSet {
            self.deliveryViewButton.isSelected = isDelivery
            self.receiveViewButton.isSelected = !isDelivery
            self.chargeAddressView.isHidden = !isDelivery
        }
    }
    
    //MARK: - Creation -
    static func create(type: AfterSaleType, data: BidDetails.HomeSoonAuction?) -> AfterSaleVC {
        let vc = AppStoryboards.auctions.instantiate(AfterSaleVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.type = type
        vc.data = data
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: self.type.title)
        self.imageView.setWith(string: self.data?.image)
        self.nameLabel.text = self.data?.name
        self.descriptionLabel.text = self.data?.description
        self.adNumberLabel.text = "Auction Number".localized + " " + (self.data?.number ?? "")
        
        switch self.type {
        case .charge:
            self.chargeViewContainer.isHidden = false
            self.serviceViewContainer.isHidden = true
            self.deliveryViewTapped()
            self.handleTaps()
        case .service:
            self.serviceViewContainer.isHidden = false
            self.chargeViewContainer.isHidden = true
            self.getAfterSaleServices()
        }
        
    }
    private func handleTaps() {
        let rTap = UITapGestureRecognizer(target: self, action: #selector(self.receiveViewTapped))
        self.receiveView.addGestureRecognizer(rTap)
        let dTap = UITapGestureRecognizer(target: self, action: #selector(self.deliveryViewTapped))
        self.deliveryView.addGestureRecognizer(dTap)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc private func receiveViewTapped() {
        self.isDelivery = false
    }
    @objc private func deliveryViewTapped() {
        self.isDelivery = true
    }
    
    @IBAction private func confirmButtonPressed() {
        guard let id = self.data?.id else {return}
        switch self.type {
        case .charge:
            do {
                var location: (address: String, lat: Double, long: Double)?
                if isDelivery {
                    location = try ValidationService.validateLocation(address: chargeAddressView.address(), lat: chargeAddressView.value()?.latitude, long: chargeAddressView.value()?.longitude)
                }
                self.shippingOrders(bidId: id, latitude: location?.lat, longitude: location?.long, address: location?.address, isDelivery: isDelivery)
            } catch {
                self.showErrorAlert(error: error.localizedDescription)
            }
        case .service:
            do {
                let location = try ValidationService.validateLocation(address: serviceAddressView.address(), lat: serviceAddressView.value()?.latitude, long: serviceAddressView.value()?.longitude)
                guard let serviceId = self.items.first(where: {$0.isSelected})?.id else {return}
                self.sendAfterSaleServices(bidId: id, latitude: location.lat, longitude: location.long, address: location.address, serviceId: serviceId)
            } catch {
                self.showErrorAlert(error: error.localizedDescription)
            }
        }
    }
    
    
}


//MARK: - Start Of TableView -
extension AfterSaleVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: AfterSaleCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension AfterSaleVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()//tableView.dequeueReusableCell(with: AfterSaleCell.self, for: indexPath)
        let item = self.items[indexPath.row]
//        cell.configureWith(data: item)
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(named: item.isSelected ? "radioButton" : "radioButtonUnSelected")
        cell.textLabel?.text = item.name
        return cell
    }
}
extension AfterSaleVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in self.items.indices {
            self.items[index].isSelected = false
        }
        self.items[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension AfterSaleVC {
    private func getAfterSaleServices() {
        guard let id = self.data?.id else {return}
        self.showIndicator()
        AuctionRouter.afterSaleServices(bidId: id).send { [weak self] (response: APIGenericResponse<[IdName]>) in
            guard let self = self else {return}
            self.items = (response.data ?? []).map({Service(name: $0.name, id: $0.id)})
            if !self.items.isEmpty {
                self.items[0].isSelected = true
            }
            self.tableView.reloadData()
        }
    }
    private func sendAfterSaleServices(bidId: String, latitude: Double, longitude: Double, address: String, serviceId: String) {
        self.showIndicator()
        AuctionRouter.afterSaleServiceOrder(bidId: bidId, latitude: latitude, longitude: longitude, address: address, serviceId: serviceId).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.pop()
        }
    }
    private func shippingOrders(bidId: String, latitude: Double?, longitude: Double?, address: String?, isDelivery: Bool) {
        self.showIndicator()
        AuctionRouter.shippingOrders(bidId: bidId, latitude: latitude, longitude: longitude, address: address, isDelivery: isDelivery).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.pop()
        }
    }
}

//MARK: - Routes -
extension AfterSaleVC {
    
}
