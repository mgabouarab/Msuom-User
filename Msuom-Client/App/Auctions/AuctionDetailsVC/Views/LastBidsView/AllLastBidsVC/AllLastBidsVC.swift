//
//  AllLastBidsVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/05/2023.
//
//  Template by MGAbouarab®

import UIKit

protocol LoadMoreLastBids {
    func getMoreData(_ completion: @escaping ([LastBidModel]) -> () )
}

//MARK: - ViewController
class AllLastBidsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [LastBidModel] = []
    private var delegate: LoadMoreLastBids?
    
    //MARK: - Creation -
    static func create(items: [LastBidModel], delegate: LoadMoreLastBids?) -> AllLastBidsVC {
        let vc = AppStoryboards.auctions.instantiate(AllLastBidsVC.self)
        vc.items = items
        vc.delegate = delegate
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "Latest bids".localized
        
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    
}


//MARK: - Start Of TableView -
extension AllLastBidsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: LastBidsCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension AllLastBidsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: LastBidsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.set(
            image: item.avatar,
            name: item.name,
            date: item.createAt,
            bid: item.price?.stringValue?.toPrice()
        )
        return cell
    }
}

extension AllLastBidsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.delegate?.getMoreData { [weak self] data in
            guard let self = self else {return}
            self.items += data
            self.tableView.reloadData()
        }
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension AllLastBidsVC {
    
}

//MARK: - Routes -
extension AllLastBidsVC {
    
}
