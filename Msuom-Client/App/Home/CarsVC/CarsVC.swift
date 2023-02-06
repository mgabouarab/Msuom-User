//
//  CarsVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/11/2022.
//

import UIKit


//MARK: - ViewController
class CarsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var cars: [Car] = []
    
    //MARK: - Creation -
    static func create() -> CarsVC {
        let vc = AppStoryboards.home.instantiate(CarsVC.self)
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
        self.refresh()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.setupNavigationView()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.cars = []
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        self.getCarsData()
    }
    @IBAction private func addButtonPressed() {
        let vc = VehicleTypeSelectionVC.create(delegate: self)
        self.present(vc, animated: false)
    }
}


//MARK: - Start Of TableView -
extension CarsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension CarsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard !cars.isEmpty else {
            return nil
        }
        
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
        titleLabel.text = "Recent added cars".localized
        
        stack.addArrangedSubview(spacer())
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(spacer())
        
        return stack
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.cars.isEmpty)
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: CarCell.self, for: indexPath)
        let car = self.cars[indexPath.row]
        cell.configureWith(data: car.cellViewData())
        return cell
        
    }
}
extension CarsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let car = self.cars[indexPath.row]
//        self.goToCar(id: car.id)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension CarsVC {
    private func getCarsData() {
        self.showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideIndicator()
//            self.cars = Car.cars
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension CarsVC {
    func goToCar(id: String) {
        let vc = CarDetailsVC.create(id: id)
        self.push(vc)
    }
}

//MARK: - Delegation -
extension CarsVC: VehicleTypeSelectionDelegate {
    func didSelect(type: VehicleTypeSelectionVC.VehicleTypes) {
        switch type {
            
        case .ads:
            let vc = AddCarVC.create()
            self.push(vc)
        case .auction:
            let vc = AddCarVC.create()
            self.push(vc)
        }
        
    }
}
