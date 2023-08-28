//
//  AllAuctionsProvidersVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 06/08/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class AllAuctionsProvidersVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [BidDetails] = []
    private var bidIds: String!
    private var brandId: String? = nil
    private var typeId: String? = nil
    private var year: String? = nil
    private var cityId: String? = nil
    private var statusId: String? = nil
    private var gearId: String? = nil
    private var colorId: String? = nil
    private var headerTitle: String? = nil
    
    //MARK: - Creation -
    static func create(bidIds: String, headerTitle: String?) -> AllAuctionsProvidersVC {
        let vc = AppStoryboards.auctions.instantiate(AllAuctionsProvidersVC.self)
        vc.bidIds = bidIds
        vc.hidesBottomBarWhenPushed = true
        vc.headerTitle = headerTitle
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.showAllProviders()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: self.headerTitle ?? "Car show".localized)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filterIcon"),
            style: .plain,
            target: self,
            action: #selector(self.filterButtonPressed)
        )
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.tableView.refreshControl?.endRefreshing()
        self.items = []
        self.tableView.reloadData()
        self.showAllProviders()
    }
    @objc private func filterButtonPressed() {
        let vc = AuctionProviderDetailsFilterVC.create(delegate: self)
        let nav = BaseNav(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
}


//MARK: - Start Of TableView -
extension AllAuctionsProvidersVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ComingSoonAuctionCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension AllAuctionsProvidersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: items.isEmpty)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
        cell.configureWith(details: item.homeComingSoonCellData())
        return cell
    }
}
extension AllAuctionsProvidersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.items[indexPath.row].id else {return}
        let vc = AuctionDetailsVC.create(id: id)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension AllAuctionsProvidersVC {
    private func showAllProviders() {
        self.showIndicator()
        AuctionRouter.auctionsFilter(
            bidIds: self.bidIds,
            brandId: brandId,
            typeId: typeId,
            year: year,
            cityId: cityId,
            statusId: statusId,
            gearId: gearId,
            colorId: colorId
        ).send { [weak self] (response: APIGenericResponse<[BidDetails]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension AllAuctionsProvidersVC {
    
}

extension AllAuctionsProvidersVC: AuctionProviderDetailsFilterDelegate {
    
    func didSelectFilter(brandId: String?, typeId: String?, year: String?, cityId: String?, statusId: String?, gear: String?, color: String?) {
        
        self.brandId = brandId
        self.typeId = typeId
        self.year = year
        self.cityId = cityId
        self.statusId = statusId
        self.gearId = gear
        self.colorId = color
        
        self.items = []
        self.tableView.reloadData()
        
        self.showAllProviders()
    }
    
}
