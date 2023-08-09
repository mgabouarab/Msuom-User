//
//  ProviderDetailsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/02/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class ProviderDetailsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var placeLabel: UILabel!
    @IBOutlet weak private var bioLabel: UILabel!
    
    //MARK: - Properties -
    private var items: [MyCarsModel] = []
    private var providerDetails: OfferProvider?
    private var id: String?
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    private var brandId: String? = nil
    private var typeId: String? = nil
    private var year: String? = nil
    private var cityId: String? = nil
    private var statusId: String? = nil
    
    
    //MARK: - Creation -
    static func create(providerDetails: OfferProvider?, id: String?) -> ProviderDetailsVC {
        let vc = AppStoryboards.more.instantiate(ProviderDetailsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.providerDetails = providerDetails
        vc.id = id
        return vc
    }
    
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.getProviderDetails()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Provider Details".localized)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filterIcon"),
            style: .plain,
            target: self,
            action: #selector(self.filterButtonPressed)
        )
        if let providerDetails = self.providerDetails {
            self.configureWith(data: providerDetails)
        }
    }
    func configureWith(data: OfferProvider) {
        self.imageView.setWith(string: data.image)
        self.nameLabel.text = data.name
        self.countLabel.text = data.carCount?.htmlToAttributedString?.string
        self.placeLabel.text = data.cityName
        self.bioLabel.text = data.bio
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func goToLocation() {
        guard let latitude = self.providerDetails?.latitude, let longitude = self.providerDetails?.longitude else {return}
        AppHelper.openLocationOnMap(lat: latitude, long: longitude)
    }
    @objc private func filterButtonPressed() {
        let vc = ProviderDetailsFilterVC.create(delegate: self)
        let nav = BaseNav(rootViewController: vc)
        self.present(nav, animated: true)
    }
}


//MARK: - Start Of TableView -
extension ProviderDetailsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.register(cellType: OffersCell.self, bundle: nil)
        self.tableView.register(cellType: ComingSoonAuctionCell.self, bundle: nil)
        self.tableView.register(cellType: ComingSoonAuctionCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension ProviderDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        
        if item.type == "advertise" {
            let cell = tableView.dequeueReusableCell(with: CarCell.self, for: indexPath)
            cell.setupDataWith(data: item)
            return cell
        } else if item.type == "offer" {
            let cell = tableView.dequeueReusableCell(with: OffersCell.self, for: indexPath)
            cell.configureWith(model: item)
            return cell
        } else if item.type == "live" {
            let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
            cell.configureWith(model: item)
            return cell
        } else if item.type == "normal" {
            let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
            cell.configureWith(model: item)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
}
extension ProviderDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.items[indexPath.row]
        let id = item.id
        
        if item.type == "advertise" {
            let vc = CarDetailsVC.create(id: id)
            self.push(vc)
        } else if item.type == "offer" {
            let vc = OfferDetailsVC.create(
                offer: OfferModel(
                    offer: item,
                    provider: OfferProvider(
                        id: nil,
                        name: item.name,
                        phoneNo: item.phoneNo,
                        image: item.avatar,
                        endDate: item.endDate,
                        cityName: nil,
                        address: nil,
                        latitude: nil,
                        longitude: nil,
                        carCount: nil,
                        bio: nil,
                        star: nil
                    )
                )
            )
            self.push(vc)
        } else if item.type == "live" {
            let vc = AuctionDetailsVC.create(id: id)
            self.push(vc)
        } else if item.type == "normal" {
            let vc = AuctionDetailsVC.create(id: id)
            self.push(vc)
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension ProviderDetailsVC {
    private func getProviderDetails() {
        
        var providerId: String?
        
        if let id = self.providerDetails?.id {
            providerId = id
        } else if let id = self.id {
            providerId = id
        }
        guard let id = providerId else {return}
        
        self.showIndicator()
        
        CarRouter.providerDetails(id: id ,page: self.currentPage, brandId: brandId, typeId: typeId, year: year, cityId: cityId, statusId: statusId).send { [weak self] (response: APIGenericResponse<ProviderDetailsModel>) in
            guard let self = self else {return}
            self.tableView.refreshControl?.endRefreshing()
            self.items.append(contentsOf: response.data?.cars ?? [])
            self.tableView.reloadData()
            self.providerDetails = response.data?.provider
            if let providerDetails = self.providerDetails {
                self.configureWith(data: providerDetails)
            }
            self.currentPage += 1
            if self.items.isEmpty || (response.data?.cars ?? []).isEmpty || response.data?.cars.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
}

//MARK: - Routes -
extension ProviderDetailsVC {
    
}
//MARK: - Routes -
extension ProviderDetailsVC: ProviderDetailsFilterDelegate {
    
    func didSelectFilter(brandId: String?, typeId: String?, year: String?, cityId: String?, statusId: String?) {
        
        self.brandId = brandId
        self.typeId = typeId
        self.year = year
        self.cityId = cityId
        self.statusId = statusId
        
        self.items = []
        self.tableView.reloadData()
        self.currentPage = 1
        
        self.getProviderDetails()
    }
    
}
