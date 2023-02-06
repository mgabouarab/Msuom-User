//
//  CountriesResultVC.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import UIKit

final class CountriesResultVC: UIViewController {
    
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
        view.addSubview(tableView)
        
        title = "Select Country".phoneNumberLocalizable
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(cellType: CountryCodeCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
}

extension CountriesResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.countries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CountryCodeCell()
        cell.setup(country: self.countries[indexPath.row])
        return cell
    }
}
extension CountriesResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.didSelectCountry(self.countries[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

