//
//  CountriesVC.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import UIKit

final class CountriesVC: UIViewController {
    
    //MARK: - Properties -
    var countries: [CountryCodeItem]
    var delegate: CountryCodeDelegate
    let tableView = UITableView()
    
    //MARK: - Init -
    init(countries: [CountryCodeItem], delegate: CountryCodeDelegate) {
        self.countries = countries
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Country".phoneNumberLocalizable
        let resultVC = CountriesResultVC(countries: self.countries, delegate: self)
        let searchBar = UISearchController(searchResultsController: resultVC)
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.placeholder = "Search".phoneNumberLocalizable
        navigationItem.searchController = searchBar
        
        view.addSubview(tableView)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel".phoneNumberLocalizable
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CountryCodeCell.self)
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

extension CountriesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CountryCodeCell()
        cell.setup(country: self.countries[indexPath.row])
        return cell
    }
}
extension CountriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didSelectCountry(self.countries[indexPath.row])
        self.navigationController?.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CountriesVC: CountryCodeDelegate {
    func didSelectCountry(_ item: CountryCodeItem) {
        self.navigationController?.dismiss(animated: true) {
            self.delegate.didSelectCountry(item)
        }
    }
}
extension CountriesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        guard let vc = searchController.searchResultsController as? CountriesResultVC else {return}
        let filteredCountries = self.countries.filter({$0.name.contains(text)})
        vc.countries = filteredCountries
        vc.tableView.reloadData()
    }
}
