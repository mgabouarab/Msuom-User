//
//  SearchVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/11/2022.
//

import UIKit

struct SearchModel: Codable {
    let id: String
    let image: String?
    let name: String?
    let price: String?
    let sellTypeName: String?
    let type: String
    let carCount: String?
    let cityName: String?
    
    private let startDate: String?
    private let startTime: String?
    private let endDate: String?
    private let endTime: String?
    private let isRunning: Bool?
    let startPrice: String?
    
    var fullStartDate: String {
        guard let startDate = self.startDate else {
            print("The Auction with id: \(self.id) has no startDate")
            return ""
        }
        guard let startTime = self.startTime else {
            print("The Auction with id: \(self.id) has no startTime")
            return ""
        }
        return "\(startDate) \(startTime)"
    }
    var fullEndDate: String {
        guard let endDate = self.endDate else {
            print("The Auction with id: \(self.id) has no endDate")
            return ""
        }
        guard let endTime = self.endTime else {
            print("The Auction with id: \(self.id) has no endTime")
            return ""
        }
        return "\(endDate) \(endTime)"
    }
    var isLive: Bool {
        guard type == "live" else {
            return false
        }
        return true
    }
    var isStart: Bool {
        guard self.isRunning == true else {
            return false
        }
        return true
    }
}


extension SearchModel {
    
    //MARK: - SubStructs -
    struct CellData: CarCellViewData {
        let image: String?
        let name: String?
        let price: String
        let sellType: String
        var isFinancing: String?
    }
    
    //MARK: - Views Data -
    func cellViewData() -> CellData {
        
        var displayedPrice: String {
            guard let price = self.price else {return ""}
            return price
        }
        var displayedSellType: String {
            guard let type = self.sellTypeName else {return ""}
            return type
        }
        var displayedName: String {
            
            return self.name ?? ""
            
        }
        
        return CellData(
            image: self.image,
            name: displayedName,
            price: displayedPrice,
            sellType: displayedSellType,
            isFinancing: nil
        )
        
    }
    
    
}

//MARK: - ViewController
class SearchVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchTextField: UITextField!
    
    //MARK: - Properties -
    private var cars: [SearchModel] = []
    
    //MARK: - Creation -
    static func create() -> SearchVC {
        let vc = AppStoryboards.home.instantiate(SearchVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.search(for: nil)
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Search".localized)
        self.searchTextField.delegate = self
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    
}


//MARK: - Start Of TableView -
extension SearchVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.register(cellType: ProvidersCell.self, bundle: nil)
        self.tableView.register(cellType: ComingSoonAuctionCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.cars.isEmpty)
        return cars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.cars[indexPath.row]
         
        if item.type == "provider" {
            let cell = tableView.dequeueReusableCell(with: ProvidersCell.self, for: indexPath)
            cell.configureWith(data: item)
            return cell
        } else if item.type == "live" || item.type == "normal" {
            let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
            cell.configureWith(auction: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: CarCell.self, for: indexPath)
            cell.configureWith(data: item.cellViewData())
            return cell
        }
    }
}
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.cars[indexPath.row]
        if item.type == "provider" {
            let vc = ProviderDetailsVC.create(providerDetails: nil, id: item.id)
            self.push(vc)
        } else if item.type == "live" || item.type == "normal" {
            let vc = AuctionDetailsVC.create(id: item.id)
            self.push(vc)
        } else {
            self.goToCar(id: item.id)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension SearchVC {
    private func search(for word: String?) {
//        guard let word = word else {
//            self.cars = []
//            self.tableView.reloadData()
//            return
//        }
        
        self.showIndicator()
        HomeRouter.search(keyword: word).send { [weak self] (response: APIGenericResponse<[SearchModel]>) in
            guard let self = self else {return}
            self.cars = response.data ?? []
            self.tableView.reloadData()
        }
        
    }
}

//MARK: - Routes -
extension SearchVC {
    func goToCar(id: String) {
        let vc = CarDetailsVC.create(id: id)
        self.push(vc)
    }
}

//MARK: - Delegation -
extension SearchVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction(_:)), object: nil)
        perform(#selector(searchAction), with: nil, afterDelay: 0.5)
        
    }
    @objc func searchAction(_ textField: UITextField) {
        self.search(for: self.searchTextField.textValue)
    }
}
