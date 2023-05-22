//
//  BrowseCarVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 14/02/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class BrowseCarVC: BaseVC {
    
    
    enum BrowseBy {
        case brand(id: String, title: String?)
        case category(id: String, title: String?)
    }
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [MyCarsModel] = []
    private var type: BrowseBy!
    
    //MARK: - Creation -
    static func create(type: BrowseBy ) -> BrowseCarVC {
        let vc = AppStoryboards.home.instantiate(BrowseCarVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.type = type
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        
        switch self.type! {
        case .brand(let id, _):
            self.browseByBrand(id: id)
        case .category(let id, _):
            self.browseByCategory(id: id)
        }
        
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        switch self.type! {
        case .brand(_, let title):
            self.addBackButtonWith(title: title ?? "")
        case .category(_, let title):
            self.addBackButtonWith(title: title ?? "")
        }
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.items = []
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        switch self.type! {
        case .brand(let id, _):
            self.browseByBrand(id: id)
        case .category(let id, _):
            self.browseByCategory(id: id)
        }
    }
    
}


//MARK: - Start Of TableView -
extension BrowseCarVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension BrowseCarVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.items.isEmpty)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CarCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension BrowseCarVC: UITableViewDelegate {
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
extension BrowseCarVC {
    private func browseByBrand(id: String) {
        self.showIndicator()
        HomeRouter.browseByBrand(id: id).send { [weak self] (response: APIGenericResponse<[MyCarsModel]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
    private func browseByCategory(id: String) {
        self.showIndicator()
        HomeRouter.browseByCategory(id: id).send { [weak self] (response: APIGenericResponse<[MyCarsModel]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension BrowseCarVC {
    
}
