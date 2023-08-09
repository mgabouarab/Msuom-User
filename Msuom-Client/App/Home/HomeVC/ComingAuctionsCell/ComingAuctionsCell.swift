//
//  ComingAuctionsCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 13/02/2023.
//

import UIKit

class ComingAuctionsCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var tableView: TableViewContentSized!

    //MARK: - Properties -
    private var items: [Auction.HomeSoonAuction] = []
    
    // MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setupTableView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    func set(title: String?, items: [Auction.HomeSoonAuction]) {
        self.items = items
        self.tableView.reloadData()
        self.titleLabel.text = title
    }
    
}

//MARK: - Start Of TableView -
extension ComingAuctionsCell {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ComingSoonAuctionCell.self, bundle: nil)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension ComingAuctionsCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.items.isEmpty)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension ComingAuctionsCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard UserDefaults.isLogin else {
//            (self.parentContainerViewController as? BaseVC)?.showLogoutAlert { [weak self] in
//                (self?.parentContainerViewController as? BaseVC)?.presentLogin()
//            }
//            return
//        }
        let item = self.items[indexPath.row]
        let vc = AuctionDetailsVC.create(id: item.id, isFromHome: true)
        self.parentContainerViewController?.show(vc, sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
//MARK: - End Of TableView -
