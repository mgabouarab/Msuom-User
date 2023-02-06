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
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [String] = []
    
    
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
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "My Auctions".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.animateToTop()
    }
    
}


//MARK: - Start Of TableView -
extension MyAuctionsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: MyAuctionsCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension MyAuctionsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MyAuctionsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension MyAuctionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension MyAuctionsVC {
    
}

//MARK: - Routes -
extension MyAuctionsVC {
    
}
