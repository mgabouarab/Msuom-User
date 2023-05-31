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
    private var providerDetails: OfferProvider!
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    
    
    //MARK: - Creation -
    static func create(providerDetails: OfferProvider) -> ProviderDetailsVC {
        let vc = AppStoryboards.more.instantiate(ProviderDetailsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.providerDetails = providerDetails
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
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage(named: "filterIcon"),
//            style: .plain,
//            target: self,
//            action: #selector(self.filterButtonPressed)
//        )
        self.configureWith(data: self.providerDetails)
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
        guard let latitude = self.providerDetails.latitude, let longitude = self.providerDetails.longitude else {return}
        AppHelper.openLocationOnMap(lat: latitude, long: longitude)
    }
    @objc private func filterButtonPressed() {
        
    }
}


//MARK: - Start Of TableView -
extension ProviderDetailsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension ProviderDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CarCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.setupDataWith(data: item)
        return cell
    }
}
extension ProviderDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.items[indexPath.row].id
        let vc = CarDetailsVC.create(id: id)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension ProviderDetailsVC {
    private func getProviderDetails() {
        guard let id = self.providerDetails.id else {return}
        self.showIndicator()
        
        CarRouter.providerDetails(id: id ,page: self.currentPage).send { [weak self] (response: APIGenericResponse<ProviderDetailsModel>) in
            guard let self = self else {return}
            self.tableView.refreshControl?.endRefreshing()
            self.items.append(contentsOf: response.data?.cars ?? [])
            self.tableView.reloadData()
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
