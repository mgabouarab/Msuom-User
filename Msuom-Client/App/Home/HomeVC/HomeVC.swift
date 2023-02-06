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
    private var cars: [Car] = []
    private var auctions: [Auction] = []
    
    
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
//        self.refresh()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.setupNavigationView()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.cars = []
        self.auctions = []
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        self.getHomeData()
    }
    @objc func goToAuctions() {
        self.tabBarController?.selectedIndex = 1
    }
    @objc func goToCars() {
        self.tabBarController?.selectedIndex = 2
    }
    
}


//MARK: - Start Of TableView -
extension HomeVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.register(cellType: AuctionCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        func spacer() -> UIView {
            let spacer = UIImageView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            spacer.widthAnchor.constraint(equalToConstant: 20).isActive = true
            return spacer
        }
        
        
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = Theme.colors.mainDarkFontColor
        
        
        let moreButton = UIButton()
        moreButton.setTitle("See all".localized, for: .normal)
        moreButton.setTitleColor(Theme.colors.mainDarkFontColor, for: .normal)
        moreButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        stack.addArrangedSubview(spacer())
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(moreButton)
        stack.addArrangedSubview(spacer())
        
        switch section {
        case 0:
            guard !auctions.isEmpty else {
                return nil
            }
            titleLabel.text = "Next Auctions".localized
            moreButton.addTarget(self, action: #selector(self.goToAuctions), for: .touchUpInside)
        case 1:
            guard !cars.isEmpty else {
                return nil
            }
            titleLabel.text = "Recent added cars".localized
            moreButton.addTarget(self, action: #selector(self.goToCars), for: .touchUpInside)
        default:
            fatalError("This is not handled case")
        }
        
        return stack
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if auctions.isEmpty && cars.isEmpty {
            self.tableView.setPlaceholder(isEmpty: true)
        } else {
            self.tableView.setPlaceholder(isEmpty: false)
        }
        
        switch section {
        case 0:
            return auctions.count
        case 1:
            return 1//cars.count
        default:
            fatalError("This is not handled case")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(with: AuctionCell.self, for: indexPath)
            let auction = self.auctions[indexPath.row]
            cell.configureWith(data: auction.cellViewData())
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(with: CarCell.self, for: indexPath)
//            let car = self.cars[indexPath.row]
//            cell.configureWith(data: car.cellViewData())
            return cell
        default:
            fatalError("Please handle this case it is not car nor auction")
        }
        
    }
}
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
//            let car = self.cars[indexPath.row]
            let vc = CarDetailsVC.create(id: "63ada1ce8883547762bd83ee")//"63949339ae7f8927afc9eeb2")
            self.push(vc)
            return
        default:
            fatalError("Please handle this case it is not car nor auction")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 110
        default:
            fatalError("Please handle this case it is not car nor auction")
        }
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension HomeVC {
    private func getHomeData() {
        self.showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideIndicator()
//            self.cars = Car.cars
            self.auctions = Auction.auctions
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension HomeVC {
    
}
