//
//  FilterStreamsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/05/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class FilterStreamsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [BidStream] = []
    private var selectedIds: [String] = []
    private var providerIds: [String] = []
    private var topTitle: String?
    
    //MARK: - Creation -
    static func create(selectedIds: [String], topTitle: String?, providerIds: [String]) -> FilterStreamsVC {
        let vc = AppStoryboards.auctions.instantiate(FilterStreamsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.selectedIds = selectedIds
        vc.topTitle = topTitle
        vc.providerIds = providerIds
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
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        self.getData()
    }
    
}


//MARK: - Start Of TableView -
extension FilterStreamsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: FilterStreamsCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension FilterStreamsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FilterStreamsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        cell.detailsActions = { [weak self] in
            guard let self = self, let streamId = item.id else {return}
            guard item.type == "live" else {
                for index in self.items.indices {
                    self.items[index].isPlaying = false
                }
                let vc = AuctionDetailsVC.create(id: streamId, isFromHome: true)
                self.push(vc)
                self.tableView.reloadData()
                return
            }
            guard item.isPlaying == true else {return}
            let vc = AuctionDetailsVC.create(id: streamId, isFromHome: true)
            self.push(vc)
            self.items[indexPath.row].isPlaying = false
            self.tableView.reloadData()
        }
        return cell
    }
}
extension FilterStreamsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.items[indexPath.row].type == "live" else {
            guard let streamId = self.items[indexPath.row].id else {return}
            for index in self.items.indices {
                self.items[index].isPlaying = false
            }
            let vc = AuctionDetailsVC.create(id: streamId, isFromHome: true)
            self.push(vc)
            self.tableView.reloadData()
            return
        }
        for index in self.items.indices {
            self.items[index].isPlaying = false
        }
        self.items[indexPath.row].isPlaying = true
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension FilterStreamsVC {
    private func getData() {
        self.showIndicator()
        AuctionRouter.filterStreams(streamIds: self.selectedIds.toString(), providerIds: self.providerIds.toString()).send { [weak self] (response: APIGenericResponse<ProviderStreamsModel>) in
            guard let self = self else {return}
            self.items = response.data?.streams ??  []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension FilterStreamsVC {
    
}
