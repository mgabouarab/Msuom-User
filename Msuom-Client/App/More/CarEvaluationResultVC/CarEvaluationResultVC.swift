//
//  CarEvaluationResultVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/01/2023.
//
//  Template by MGAbouarab®


import UIKit

class CarEvaluationResultVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var brandLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var classLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var walkwayLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var evaluateLabel: UILabel!
    @IBOutlet weak private var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    private var result: CarEvaluationResultModel?
    private var evaluateDescription: String?
    private var items: [MyCarsModel] = []
    
    //MARK: - Creation -
    static func create(result: CarEvaluationResultModel, evaluateDescription: String?) -> CarEvaluationResultVC {
        let vc = AppStoryboards.cars.instantiate(CarEvaluationResultVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.result = result
        vc.evaluateDescription = evaluateDescription
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.configureInitialDesign()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Car Evaluation".localized)
        self.evaluateLabel.text = self.evaluateDescription
        self.brandLabel.text = self.result?.result?.brandName
        self.typeLabel.text = self.result?.result?.typeName
        self.classLabel.text = self.result?.result?.categoryName
        self.statusLabel.text = self.result?.result?.statusName
        self.walkwayLabel.text = self.result?.result?.walkway
        self.priceLabel.text = self.result?.result?.price
        self.items = self.result?.carsLike ?? []
        self.tableView.reloadData()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    
}


//MARK: - Networking -
extension CarEvaluationResultVC {
    
}

//MARK: - Routes -
extension CarEvaluationResultVC {
    
}

//MARK: - Start Of TableView -
extension CarEvaluationResultVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: CarCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension CarEvaluationResultVC: UITableViewDataSource {
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
extension CarEvaluationResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CarDetailsVC.create(id: items[indexPath.row].id)
        self.push(vc)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
//MARK: - End Of TableView -
