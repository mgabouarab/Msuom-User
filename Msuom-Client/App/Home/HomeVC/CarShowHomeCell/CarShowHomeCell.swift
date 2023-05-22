//
//  CarShowHomeCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 13/02/2023.
//

import UIKit

class CarShowHomeCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var tableView: TableViewContentSized!

    //MARK: - Properties -
    private var items: [OfferProvider] = []
    var seeAllAction: (()->())?
    
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
    func set(title: String?, items: [OfferProvider]) {
        self.titleLabel.text = title
        self.items = items
        self.tableView.reloadData()
    }
    
    //MARK: - IBAction -
    @IBAction private func seeAllButtonPressed() {
        self.seeAllAction?()
    }
}

//MARK: - Start Of TableView -
extension CarShowHomeCell {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ProvidersCell.self, bundle: nil)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension CarShowHomeCell: UITableViewDataSource {
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
extension CarShowHomeCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let provider = self.items[indexPath.row]
        let vc = ProviderDetailsVC.create(providerDetails: provider)
        self.parentContainerViewController?.show(vc, sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
//MARK: - End Of TableView -
