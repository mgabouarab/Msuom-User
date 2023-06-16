//
//  DropDownListVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 17/11/2022.
//

import UIKit

final class DropDownListVC: UIViewController {
    
    //MARK: - Properties -
    var items: [DropDownItem]
    var delegate: DropDownTextFieldViewListDelegate
    let tableView = UITableView()
    let headerTitle: String?
    
    //MARK: - Init -
    init(items: [DropDownItem], delegate: DropDownTextFieldViewListDelegate, title: String?) {
        self.items = items
        self.delegate = delegate
        self.headerTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = headerTitle
        let resultVC = DropDownListResultVC(items: self.items, delegate: self, title: self.headerTitle)
        let searchBar = UISearchController(searchResultsController: resultVC)
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.placeholder = "Search".phoneNumberLocalizable
        navigationItem.searchController = searchBar
        
        view.addSubview(tableView)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel".phoneNumberLocalizable
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: DropDownListCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        for view in searchBar.searchBar.subviews {
            print(view.self)
        }
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
}

extension DropDownListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: items.isEmpty, separator: .singleLine)
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DropDownListCell()
        cell.setup(item: self.items[indexPath.row])
        return cell
    }
}
extension DropDownListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didSelect(item: self.items[indexPath.row])
        self.navigationController?.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension DropDownListVC: DropDownTextFieldViewListDelegate {
    func didSelect(item: DropDownItem) {
        self.dismiss(animated: true) {
            self.delegate.didSelect(item: item)
        }
    }
}
extension DropDownListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        guard let vc = searchController.searchResultsController as? DropDownListResultVC else {return}
        let filteredItems = self.items.filter({$0.name.contains(text)})
        vc.items = filteredItems
        vc.tableView.reloadData()
    }
}

