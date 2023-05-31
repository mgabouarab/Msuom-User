//
//  HarajVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 30/01/2023.
//
//  Template by MGAbouarab®


import UIKit

class HarajVC: BaseVC {
    
    enum Mode {
        case filter
        case normal
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [MyCarsModel] = []
    private var brands: [BrandModel] = []
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    private var selectedBrandId: String?
    private var mode: Mode = .normal
    private var brandId: String?
    private var typeId: String?
    private var cityId: String?
    private var statusId: String?
    
    //MARK: - Creation -
    static func create() -> HarajVC {
        let vc = AppStoryboards.more.instantiate(HarajVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.setupCollectionView()
        self.getHaraj(brandId: self.selectedBrandId)
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Car Auction".localized)
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
        switch self.mode {
        case .filter:
            self.filterHaraj(brandId: self.brandId, typeId: self.typeId, cityId: self.cityId, statusId: self.statusId)
        case .normal:
            self.getHaraj(brandId: self.selectedBrandId)
        }
        
        self.tableView.setPlaceholder(isEmpty: items.isEmpty)
        self.tableView.refreshControl?.endRefreshing()
    }
    @objc private func filterButtonPressed() {
        let vc = HarajFilterVC.create(delegate: self)
        let nav = BaseNav(rootViewController: vc)
        self.present(nav, animated: true)
    }
}


//MARK: - Networking -
extension HarajVC {
    private func getHaraj(brandId: String?) {
        self.showIndicator()
        CarRouter.haraj(brandId: brandId, page: self.currentPage).send { [weak self] (response: APIGenericResponse<HarajModel>) in
            guard let self = self else {return}
            self.tableView.refreshControl?.endRefreshing()
            self.items.append(contentsOf: response.data?.cars ?? [])
            if self.brands.isEmpty {
                self.brands = response.data?.carBrands ?? []
                self.collectionView.reloadData()
            }
            self.tableView.reloadData()
            self.currentPage += 1
            if self.items.isEmpty || (response.data?.cars ?? []).isEmpty || response.data?.cars.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
    private func filterHaraj(brandId: String?, typeId: String?, cityId: String?, statusId: String?) {
        self.showIndicator()
        CarRouter.harajFilter(brandId: brandId, typeId: typeId, cityId: cityId, statusId: statusId).send { [weak self] (response: APIGenericResponse<HarajModel>) in
            guard let self = self else {return}
            self.tableView.refreshControl?.endRefreshing()
            self.items.append(contentsOf: response.data?.cars ?? [])
            self.tableView.reloadData()
            self.currentPage += 1
            if self.items.isEmpty || (response.data?.cars ?? []).isEmpty || response.data?.cars.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
}

//MARK: - Routes -
extension HarajVC {
    
}

//MARK: - Start Of TableView -
extension HarajVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
//        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension HarajVC: UITableViewDataSource {
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
extension HarajVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CarDetailsVC.create(id: items[indexPath.row].id)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isLast && !self.isFetching && (indexPath.row % listLimit == 0) {
            switch self.mode {
                case .filter:
                    self.filterHaraj(brandId: self.brandId, typeId: self.typeId, cityId: self.cityId, statusId: self.statusId)
                case .normal:
                    self.getHaraj(brandId: self.selectedBrandId)
            }
        }
    }
}
//MARK: - End Of TableView -


//MARK: - CollectionView -
extension HarajVC {
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: BrandCell.self)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
extension HarajVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.brands[indexPath.item]
        let cell = collectionView.dequeueReusableCell(with: BrandCell.self, for: indexPath)
        cell.setup(image: item.image, name: item.name, isSelected: item.isSelected)
        return cell
    }
    
    
}
extension HarajVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedBrandId = self.brands[indexPath.item].id
        for index in self.brands.indices {
            self.brands[index].isSelected = false
        }
        self.brands[indexPath.item].isSelected = true
        self.collectionView.reloadData()
        self.mode = .normal
        self.refresh()
    }
}
extension HarajVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 80)
    }
}

//MARK: - Delegate -
extension HarajVC: HarajFilterDelegate {
    func didSelect(brandId: String?, typeId: String?, cityId: String?, statusId: String?) {
        self.brandId = brandId
        self.typeId = typeId
        self.cityId = cityId
        self.statusId = statusId
        self.mode = .filter
        self.selectedBrandId = nil
        for index in self.brands.indices {
            self.brands[index].isSelected = false
        }
        self.collectionView.reloadData()
        self.refresh()
    }
}
