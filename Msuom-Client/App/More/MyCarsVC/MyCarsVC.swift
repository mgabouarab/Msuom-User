//
//  MyCarsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/01/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class MyCarsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [MyCarsModel] = []
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    
    
    //MARK: - Creation -
    static func create() -> MyCarsVC {
        let vc = AppStoryboards.more.instantiate(MyCarsVC.self)
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
        self.addBackButtonWith(title: "My Ads".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.items = []
        self.tableView.reloadData()
        self.currentPage = 1
        self.isLast = false
        self.getMyAdvertises(page: self.currentPage)
        self.tableView.setPlaceholder(isEmpty: items.isEmpty)
        self.tableView.refreshControl?.endRefreshing()
    }
    
}


//MARK: - Start Of TableView -
extension MyCarsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension MyCarsVC: UITableViewDataSource {
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
extension MyCarsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CarDetailsVC.create(id: items[indexPath.row].id)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isLast && !self.isFetching && (indexPath.row % listLimit == 0) {
            self.getMyAdvertises(page: self.currentPage)
        }
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension MyCarsVC {
    private func getMyAdvertises(page: Int) {
        self.showIndicator()
        self.isFetching = true
        MoreRouter.advertises(page: page).send { [weak self] (response: APIGenericResponse<[MyCarsModel]>) in
            guard let self = self else {return}
            self.tableView.refreshControl?.endRefreshing()
            self.items.append(contentsOf: response.data ?? [])
            self.tableView.reloadData()
            self.currentPage += 1
            if self.items.isEmpty || (response.data ?? []).isEmpty || response.data?.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
}

//MARK: - Routes -
extension MyCarsVC {
    
}
