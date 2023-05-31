//
//  OffersVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 30/01/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class OffersVC: BaseVC {
    
    enum FilterType: String {
        case brand
        case provider
    }
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var collectionHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Properties -
    private let brandsHeight: CGFloat = 25
    private let providersHeight: CGFloat = 50
    private var items: [OfferModel] = []
    private var brands: [BrandModel] = []
    private var providers: [OfferProvider] = []
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    private var selectedBrandId: String?
    private var selectedProviderId: String?
    private var filterType: FilterType = .brand {
        didSet {
            switch self.filterType {
            case .brand:
                self.collectionHeightConstraint.constant = self.brandsHeight
            case .provider:
                self.collectionHeightConstraint.constant = self.providersHeight
            }
            self.view.layoutIfNeeded()
            
        }
    }
    
    //MARK: - Creation -
    static func create() -> OffersVC {
        let vc = AppStoryboards.more.instantiate(OffersVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.setupCollectionView()
        self.getOffers()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Offers".localized)
        self.segmentedControl.setupSegmented(mainColor: Theme.colors.secondaryColor, font: .systemFont(ofSize: 16), normalColor: Theme.colors.secondaryColor, selectedColor: Theme.colors.whiteColor)
        self.segmentedControl.setTitle("Offers by brands".localized, forSegmentAt: 0)
        self.segmentedControl.setTitle("Offers by company".localized, forSegmentAt: 1)
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
        
        switch self.filterType {
        case .brand:
            if let brandId = self.selectedBrandId {
                self.offerFilter(brandId: brandId, providerId: nil, page: self.currentPage)
            } else {
                self.getOffers()
            }
        case .provider:
            if let providerId = self.selectedProviderId {
                self.offerFilter(brandId: nil, providerId: providerId, page: self.currentPage)
            } else {
                self.getOffers()
            }
        }
        self.collectionView.reloadData()
    }
    @IBAction func didChangeType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.filterType = .brand
            self.refresh()
        case 1:
            self.filterType = .provider
            self.refresh()
        default:
            return
        }
    }
    
}


//MARK: - Start Of TableView -
extension OffersVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: OffersCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension OffersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OffersCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension OffersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = self.items[indexPath.row]
        let vc = OfferDetailsVC.create(offer: offer)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isLast && !self.isFetching && (indexPath.row % listLimit == 0) {
            
            if self.selectedBrandId != nil || self.selectedProviderId != nil {
                switch self.filterType {
                case .brand:
                    self.offerFilter(brandId: self.selectedBrandId, providerId:  self.selectedProviderId , page: self.currentPage)
                case .provider:
                    self.offerFilter(brandId: self.selectedBrandId, providerId:  self.selectedProviderId , page: self.currentPage)
                }
            } else {
                self.getOffers()
            }
        }
    }
}
//MARK: - End Of TableView -

//MARK: - CollectionView -
extension OffersVC {
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: BrandCell.self)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension OffersVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.filterType == .brand ? self.brands.count: self.providers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch self.filterType {
            
        case .brand:
            let item = self.brands[indexPath.item]
            let cell = collectionView.dequeueReusableCell(with: BrandCell.self, for: indexPath)
            cell.setup(image: item.image, name: nil, isSelected: item.isSelected)
            cell.hideName(true)
            return cell
        case .provider:
            let item = self.providers[indexPath.item]
            let cell = collectionView.dequeueReusableCell(with: BrandCell.self, for: indexPath)
            cell.setup(image: item.image, name: item.name, isSelected: item.isSelected)
            cell.hideName(false)
            return cell
        }
        
    }
    
    
}
extension OffersVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        switch self.filterType {
        case .brand:
            self.selectedBrandId = self.brands[indexPath.item].id
            self.selectedProviderId = nil
            for index in self.brands.indices {
                self.brands[index].isSelected = false
            }
            self.brands[indexPath.item].isSelected = true
        case .provider:
            self.selectedProviderId = self.providers[indexPath.item].id
            self.selectedBrandId = nil
            for index in self.providers.indices {
                self.providers[index].isSelected = false
            }
            self.providers[indexPath.item].isSelected = true
        }
        
        self.collectionView.reloadData()
        self.refresh()
        
    }
}
extension OffersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.filterType {
        case .brand:
            return CGSize(width: 70, height: self.brandsHeight)
        case .provider:
            return CGSize(width: 70, height: self.providersHeight)
        }
    }
}



//MARK: - Networking -
extension OffersVC {
    private func getOffers() {
        self.showIndicator()
        CarRouter.offers(page: self.currentPage, type: self.filterType.rawValue).send { [weak self] (response: APIGenericResponse<Offers>) in
            guard let self = self else { return }
            
            if self.brands.isEmpty {
                self.brands = response.data?.carBrands ?? []
                self.collectionView.reloadData()
            }
            
            if self.providers.isEmpty {
                self.providers = response.data?.providers ?? []
                self.collectionView.reloadData()
            }
            
            self.items = response.data?.offers ?? []
            self.tableView.reloadData()
            
            self.currentPage += 1
            if self.items.isEmpty || (response.data?.offers ?? []).isEmpty || response.data?.offers.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
            
        }
    }
    private func offerFilter(brandId: String?, providerId: String?, page: Int) {
        self.showIndicator()
        CarRouter.offerFilter(brandId: brandId, providerId: providerId, page: page).send { [weak self] (response: APIGenericResponse<[OfferModel]>) in
            guard let self = self else { return }
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
extension OffersVC {
    
}
