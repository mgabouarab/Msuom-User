//
//  ShowAllProvidersVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 28/05/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class ShowAllProvidersVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [BidStream] = []
    private var selectedType: String!
    private var topTitle: String?
    
    //MARK: - Creation -
    static func create(type: String, topTitle: String?) -> ShowAllProvidersVC {
        let vc = AppStoryboards.auctions.instantiate(ShowAllProvidersVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.selectedType = type
        vc.topTitle = topTitle
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.refresh()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "\(topTitle ?? "Auctions")".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.items = []
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        self.getData()
    }
    
}


//MARK: - Start Of TableView -
extension ShowAllProvidersVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: AuctionsStoreCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension ShowAllProvidersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: self.items.isEmpty)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: AuctionsStoreCell.self, for: indexPath)
        
        let time = (item.isRunning == true) ? ((item.endDate ?? "") + " " + (item.endTime ?? "")) : ((item.startDate ?? "") + " " + (item.startTime ?? ""))
        
        cell.set(image: item.image, name: item.name, count: item.carCount, address: item.cityName, time: time)
        return cell
    }
}
extension ShowAllProvidersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let providerId = self.items[indexPath.row].providerId else {return}
        let vc = ProviderStreamsVC.create(type: self.selectedType, providerId: providerId, topTitle: self.topTitle)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension ShowAllProvidersVC {
    private func getData() {
        self.showIndicator()
        AuctionRouter.showAllProviders(type: self.selectedType).send { [weak self] (response: APIGenericResponse<[BidStream]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension ShowAllProvidersVC {
    
}
