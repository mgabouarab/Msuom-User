//
//  ReportsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 25/05/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class ReportsVC: BaseVC {
    
    struct Report: Codable {
        let adNumber: Int
        let carImage: String
        let carName: String
        let descriptionBid: String
        let id: String
        let status: String
    }
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [Report] = []
    
    
    //MARK: - Creation -
    static func create() -> ReportsVC {
        let vc = AppStoryboards.auctions.instantiate(ReportsVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.getData()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Complains".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.tableView.refreshControl?.endRefreshing()
        self.items = []
        self.tableView.reloadData()
        self.getData()
    }
    
}


//MARK: - Start Of TableView -
extension ReportsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ReportsCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension ReportsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ReportsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension ReportsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.items[indexPath.row].id
        let vc = ReportDetailsVC.create(id: id)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension ReportsVC {
    private func getData() {
        self.showIndicator()
        AuctionRouter.disputesUser.send { [weak self] (response: APIGenericResponse<[Report]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension ReportsVC {
    
}
