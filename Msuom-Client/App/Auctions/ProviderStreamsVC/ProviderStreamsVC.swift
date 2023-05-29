//
//  ProviderStreamsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 28/05/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class ProviderStreamsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [BidStream] = []
    private var type: String!
    private var providerId: String!
    
    
    //MARK: - Creation -
    static func create(type: String, providerId: String) -> ProviderStreamsVC {
        let vc = AppStoryboards.auctions.instantiate(ProviderStreamsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.providerId = providerId
        vc.type = type
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.getData()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Auctions".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func showButtonPressed() {
        let ids = self.items.filter({$0.isSelected == true}).compactMap { $0.id }
        guard !ids.isEmpty else {
            self.showErrorAlert(error: "Please select at lest one auction".localized)
            return
        }
        let vc = FilterStreamsVC.create(selectedIds: ids)
        self.push(vc)
    }
    
    
}


//MARK: - Start Of TableView -
extension ProviderStreamsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ProviderStreamsCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension ProviderStreamsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProviderStreamsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension ProviderStreamsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let id = self.items[indexPath.row].id else {return}
//        let vc = AuctionDetailsVC.create(id: id, isFromHome: true)
//        self.push(vc)
        self.items[indexPath.row].isSelected.toggleOptional()
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension ProviderStreamsVC {
    private func getData() {
        self.showIndicator()
        AuctionRouter.providerStreams(type: self.type, providerId: self.providerId).send { [weak self] (response: APIGenericResponse<ProviderStreamsModel>) in
            guard let self = self else {return}
            self.items = response.data?.streams ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension ProviderStreamsVC {
    
}
