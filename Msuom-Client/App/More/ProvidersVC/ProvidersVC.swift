//
//  ProvidersVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/02/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class ProvidersVC: BaseVC {
    
    enum Mode {
        case filter(name: String?, brandId: String?, cityId: String?)
        case normal
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [OfferProvider] = []
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    private var mode: Mode = .normal
    
    //MARK: - Creation -
    static func create() -> ProvidersVC {
        let vc = AppStoryboards.more.instantiate(ProvidersVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.getProviders()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Car show".localized)
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
        self.items = []
        self.tableView.reloadData()
        self.currentPage = 1
        self.isLast = false
        self.tableView.setPlaceholder(isEmpty: items.isEmpty)
        self.tableView.refreshControl?.endRefreshing()
        switch self.mode {
        case .filter(let name, let brandId, let cityId):
            self.getProviderFilter(name: name, brandId: brandId, cityId: cityId)
        case .normal:
            self.getProviders()
        }
    }
    @objc private func filterButtonPressed() {
        let vc = ProvidersFilterVC.create(delegate: self)
        let nav = BaseNav(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
}


//MARK: - Start Of TableView -
extension ProvidersVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ProvidersCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension ProvidersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.items.isEmpty)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProvidersCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension ProvidersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let provider = self.items[indexPath.row]
        let vc = ProviderDetailsVC.create(providerDetails: provider)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isLast && !self.isFetching && (indexPath.row % listLimit == 0) {
            switch self.mode {
            case .filter(let name, let brandId, let cityId):
                self.getProviderFilter(name: name, brandId: brandId, cityId: cityId)
            case .normal:
                self.getProviders()
            }
        }
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension ProvidersVC {
    private func getProviders() {
        self.showIndicator()
        CarRouter.providers(page: self.currentPage).send { [weak self] (response: APIGenericResponse<[OfferProvider]>) in
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
    private func getProviderFilter(name: String?, brandId: String?, cityId: String?) {
        self.showIndicator()
        CarRouter.providerFilter(name: name, brandId: brandId, cityId: cityId, page: self.currentPage).send { [weak self] (response: APIGenericResponse<[OfferProvider]>) in
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
extension ProvidersVC {
    
}

extension ProvidersVC: ProvidersFilterDelegate {
    func didSelectFilter(name: String?, brandId: String?, cityId: String?) {
        if name == nil, brandId == nil, cityId == nil {
            self.mode = .normal
        } else {
            self.mode = .filter(name: name, brandId: brandId, cityId: cityId)
        }
        self.refresh()
    }
}
