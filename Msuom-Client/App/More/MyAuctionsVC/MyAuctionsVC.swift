//
//  MyAuctionsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/01/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class MyAuctionsVC: BaseVC {
    
    enum TypeOfAuction: String {
        case subscribed = "subscribe"
        case wined = "winner"
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    
    //MARK: - Properties -
    private var items: [BidDetails.HomeSoonAuction] = []
    private var filterType: MyAuctionsVC.TypeOfAuction = .subscribed
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    
    //MARK: - Creation -
    static func create() -> MyAuctionsVC {
        let vc = AppStoryboards.more.instantiate(MyAuctionsVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "My Auctions".localized)
        self.segmentedControl.setupSegmented(mainColor: Theme.colors.secondaryColor, font: .systemFont(ofSize: 16), normalColor: Theme.colors.secondaryColor, selectedColor: Theme.colors.whiteColor)
        self.segmentedControl.setTitle("Subscribed Auctions".localized, forSegmentAt: 0)
        self.segmentedControl.setTitle("Wined Auctions".localized, forSegmentAt: 1)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.items = []
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        self.currentPage = 1
        self.isLast = false
        self.isFetching = false
        self.getSubscribedAuctions()
    }
    @IBAction func didChangeType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.filterType = .subscribed
            self.refresh()
        case 1:
            self.filterType = .wined
            self.refresh()
        default:
            return
        }
    }
    
}


//MARK: - Start Of TableView -
extension MyAuctionsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ComingSoonAuctionCell.self, bundle: nil)
        self.tableView.register(cellType: MyAuctionsCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension MyAuctionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.items.isEmpty)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.filterType {
        case .subscribed:
            let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
            let item = self.items[indexPath.row]
            cell.configureWith(details: item)
            return cell
        case .wined:
            let cell = tableView.dequeueReusableCell(with: MyAuctionsCell.self, for: indexPath)
            let item = self.items[indexPath.row]
            cell.configureWith(details: item)
            
            cell.requestChargeAction = { [weak self] in
                let vc = AfterSaleVC.create(type: .charge, data: item)
                self?.push(vc)
            }
            cell.saleAction = { [weak self] in
                let vc = AfterSaleVC.create(type: .service, data: item)
                self?.push(vc)
            }
            cell.openAction = { [weak self] in
                let vc = OpenReportVC.create(data: item)
                self?.push(vc)
            }
            
            return cell
        }
    }
}
extension MyAuctionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.items[indexPath.row].id
        let vc = AuctionDetailsVC.create(id: id)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.filterType {
        case .subscribed:
            return 120
        case .wined:
            return tableView.estimatedRowHeight
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isLast && !self.isFetching && (indexPath.row % listLimit == 0) {
            self.getSubscribedAuctions()
        }
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension MyAuctionsVC {
    private func getSubscribedAuctions() {
        self.showIndicator()
        AuctionRouter.subscribeWinnerBids(type: filterType.rawValue).send { [weak self] (response: APIGenericResponse<[BidDetails]>) in
            guard let self = self else { return }
            
            self.items = response.data?.map({$0.homeComingSoonCellData()}) ?? []
            self.tableView.reloadData()

            self.currentPage += 1
            if response.paginate?.currentPage == response.paginate?.lastPage {
                self.isLast = true
            }
            self.isFetching = false
            
        }
    }
}

//MARK: - Routes -
extension MyAuctionsVC {
    
}
