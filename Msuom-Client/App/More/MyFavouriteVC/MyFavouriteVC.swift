//
//  MyFavouriteVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/01/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class MyFavouriteVC: BaseVC {
    
    enum FavsType: String {
        case advertise
        case bid
    }
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [MyCarsModel] = []
    private var type: FavsType = .bid
    
    
    //MARK: - Creation -
    static func create() -> MyFavouriteVC {
        let vc = AppStoryboards.more.instantiate(MyFavouriteVC.self)
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
        self.getFavs()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "My Favourite".localized)
        self.segmentedControl.setupSegmented(mainColor: Theme.colors.secondaryColor, font: .systemFont(ofSize: 16), normalColor: Theme.colors.secondaryColor, selectedColor: Theme.colors.whiteColor)
        self.segmentedControl.setTitle("Auctions".localized, forSegmentAt: 0)
        self.segmentedControl.setTitle("Ads".localized, forSegmentAt: 1)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.items = []
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        self.getFavs()
    }
    
    @IBAction func didChangeType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.type = .bid
            self.refresh()
        case 1:
            self.type = .advertise
            self.refresh()
        default:
            return
        }
    }
    
}


//MARK: - Start Of TableView -
extension MyFavouriteVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension MyFavouriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CarCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension MyFavouriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemId = self.items[indexPath.row].id
        switch self.type {
        case .advertise:
            let vc = CarDetailsVC.create(id: itemId)
            self.push(vc)
        case .bid:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension MyFavouriteVC {
    private func getFavs() {
        self.showIndicator()
        MoreRouter.favs(type: self.type.rawValue).send { [weak self] (response: APIGenericResponse<[MyCarsModel]>) in
            guard let self = self else {return}
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension MyFavouriteVC {
    
}
