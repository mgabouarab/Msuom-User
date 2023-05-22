//
//  NotificationsVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/11/2022.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class NotificationsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [NotificationModel] = []
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    
    
    //MARK: - Creation -
    static func create() -> NotificationsVC {
        let vc = AppStoryboards.home.instantiate(NotificationsVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getNotifications()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Notifications".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.tableView.refreshControl?.endRefreshing()
        self.items = []
        self.tableView.reloadData()
        self.currentPage = 1
        self.isLast = false
        self.isFetching = false
        self.getNotifications()
    }
    
}


//MARK: - Start Of TableView -
extension NotificationsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: NotificationsCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension NotificationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.items.isEmpty)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NotificationsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item.message)
        return cell
    }
}
extension NotificationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isLast && !self.isFetching && (indexPath.row % listLimit == 0) {
            self.getNotifications()
        }
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension NotificationsVC {
    private func getNotifications() {
        self.showIndicator()
        self.isFetching = true
        HomeRouter.notifications(page: self.currentPage).send { [weak self] (response: APIGenericResponse<[NotificationModel]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
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
extension NotificationsVC {
    
}
