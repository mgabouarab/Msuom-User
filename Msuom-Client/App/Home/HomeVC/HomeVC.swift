//
//  HomeVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 14/11/2022.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class HomeVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [HomeModel] = []
    
    
    //MARK: - Creation -
    static func create() -> HomeVC {
        let vc = AppStoryboards.home.instantiate(HomeVC.self)
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
        self.setupNavigationView()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.items = []
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        self.getHomeData()
    }
    
}


//MARK: - Start Of TableView -
extension HomeVC {
    private func setupTableView() {
        self.tableView.register(cellType: HomeSliderCell.self)
        self.tableView.register(cellType: HomeCategoryCell.self)
        self.tableView.register(cellType: HomeTypeCell.self)
        self.tableView.register(cellType: ComingAuctionsCell.self)
        self.tableView.register(cellType: HarajHomeCell.self)
        self.tableView.register(cellType: CarShowHomeCell.self)
        self.tableView.register(cellType: CurrentAuctionsCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        switch item.key {
        case .sliders:
            let cell = tableView.dequeueReusableCell(with: HomeSliderCell.self, for: indexPath)
            cell.setup(data: item.sliders.compactMap({SliderView.SliderItem(image: $0.image, title: $0.title, description: $0.description, link: $0.link)}))
            return cell
        case .carBrands:
            let cell = tableView.dequeueReusableCell(with: HomeCategoryCell.self, for: indexPath)
            cell.set(carBrands: item.carBrands, title: item.title)
            return cell
        case .carStructures:
            let cell = tableView.dequeueReusableCell(with: HomeTypeCell.self, for: indexPath)
            cell.set(carBrands: item.carStructures, title: item.title)
            return cell
        case .bidsComingSoon:
            let cell = tableView.dequeueReusableCell(with: ComingAuctionsCell.self, for: indexPath)
            cell.set(title: item.title, items: item.bidsComingSoon.compactMap({$0.homeComingSoonCellData()}))
            cell.didEndWaitingTime = { [weak self] index in
                guard let self = self else {return}
                if let streamIndex = self.items.firstIndex(where: {$0.streams.isEmpty == false}) {
                    guard self.items[indexPath.row].bidsComingSoon.count > index else {return}
                    let auction = self.items[indexPath.row].bidsComingSoon[index]
                    self.items[streamIndex].streams.append(auction)
                    self.items[indexPath.row].bidsComingSoon.remove(at: index)
                    self.tableView.reloadData()
                }
            }
            return cell
        case .haraj:
            let cell = tableView.dequeueReusableCell(with: HarajHomeCell.self, for: indexPath)
            cell.set(title: item.title, items: item.haraj)
            cell.seeAllAction = { [weak self] in
                let vc = HarajVC.create()
                self?.push(vc)
            }
            return cell
        case .providers:
            let cell = tableView.dequeueReusableCell(with: CarShowHomeCell.self, for: indexPath)
            cell.set(title: item.title, items: item.providers)
            cell.seeAllAction = { [weak self] in
                let vc = ProvidersVC.create()
                self?.push(vc)
            }
            return cell
        case .streams:
            let cell = tableView.dequeueReusableCell(with: CurrentAuctionsCell.self, for: indexPath)
            cell.set(auctions: item.streams, title: item.title)
            return cell
        }
    }
    
}
extension HomeVC: UITableViewDelegate {
    
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension HomeVC {
    private func getHomeData() {
        self.showIndicator()
        HomeRouter.home.send { [weak self] (response: APIGenericResponse<[HomeModel]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension HomeVC {
    
}
