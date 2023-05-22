//
//  HarajHomeCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 13/02/2023.
//

import UIKit

class HarajHomeCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var tableView: TableViewContentSized!

    //MARK: - Properties -
    private var items: [MyCarsModel] = []
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
    func set(title: String?, items: [MyCarsModel]) {
        self.items = items
        self.tableView.reloadData()
        self.titleLabel.text = title
    }
    
    //MARK: - IBActions -
    @IBAction private func seeAllButtonPressed() {
        self.seeAllAction?()
    }
    
}

//MARK: - Start Of TableView -
extension HarajHomeCell {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension HarajHomeCell: UITableViewDataSource {
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
extension HarajHomeCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CarDetailsVC.create(id: items[indexPath.row].id)
        self.parentContainerViewController?.show(vc, sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
//MARK: - End Of TableView -
