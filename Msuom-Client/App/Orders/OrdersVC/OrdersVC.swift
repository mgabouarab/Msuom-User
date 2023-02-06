//
//  OrdersVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/02/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class OrdersVC: BaseVC {
    
    enum Types: String {
        case shipping
        case evaluation
        case purchaseOrder
        case summaryReport
    }
    
    struct OrderType: SegmentedCollectionItem{
        
        var id: String
        var name: String?
        var isSelected: Bool
        
    }
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var segmentedCollection: SegmentedCollection!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var segmentedItems: [SegmentedCollectionItem] = [
        OrderType(id: "shipping", name: "Shipping Orders".localized, isSelected: true),
        OrderType(id: "evaluation", name: "Evaluation Orders".localized, isSelected: false),
        OrderType(id: "summaryReport", name: "Summary Report Orders".localized, isSelected: false),
        OrderType(id: "purchaseOrder", name: "Purchase Orders".localized, isSelected: false)
    ]
    private var shippingOrderDetails: [ShippingOrderDetails] = []
    private var evaluationOrderDetails: [EvaluationOrderDetails] = []
    private var purchaseOrderDetails: [PurchaseOrderDetails] = []
    private var summaryReportDetails: [SummaryReportDetails] = []
    private var selectedType: Types = .shipping
    
    
    //MARK: - Creation -
    static func create() -> OrdersVC {
        let vc = AppStoryboards.orders.instantiate(OrdersVC.self)
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
        self.setLeading(title: "My Orders".localized)
        self.setNotificationButton()
        self.segmentedCollection.delegate = self
        self.segmentedCollection.reload()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        
        self.shippingOrderDetails = []
        self.evaluationOrderDetails = []
        self.purchaseOrderDetails = []
        self.summaryReportDetails = []
        
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.animateToTop()
    }
    
}


//MARK: - Start Of TableView -
extension OrdersVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: OrdersCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension OrdersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.selectedType {
        case .shipping:
            return self.shippingOrderDetails.count
        case .evaluation:
            return self.evaluationOrderDetails.count
        case .purchaseOrder:
            return self.purchaseOrderDetails.count
        case .summaryReport:
            return self.summaryReportDetails.count
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OrdersCell.self, for: indexPath)
        
        switch self.selectedType {
        case .shipping:
            let item = self.shippingOrderDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        case .evaluation:
            let item = self.evaluationOrderDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        case .purchaseOrder:
            let item = self.purchaseOrderDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        case .summaryReport:
            let item = self.summaryReportDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        }
        
    }
}
extension OrdersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension OrdersVC {
    
    private func getShippingOrderDetails(page: Int) {
        self.showIndicator()
        OrderRouter.shippingOrderDetails(page: page).send { [weak self] (response: APIGenericResponse<[ShippingOrderDetails]>) in
            guard let self = self else {return}
            self.shippingOrderDetails = response.data ?? []
            self.tableView.reloadData()
        }
    }
    private func getEvaluationOrderDetails(page: Int) {
        self.showIndicator()
        OrderRouter.evaluationOrderDetails(page: page).send { [weak self] (response: APIGenericResponse<[EvaluationOrderDetails]>) in
            guard let self = self else {return}
            self.evaluationOrderDetails = response.data ?? []
            self.tableView.reloadData()
        }
    }
    private func getPurchaseOrderDetails(page: Int) {
        self.showIndicator()
        OrderRouter.purchaseOrderDetails(page: page).send { [weak self] (response: APIGenericResponse<[PurchaseOrderDetails]>) in
            guard let self = self else {return}
            self.purchaseOrderDetails = response.data ?? []
            self.tableView.reloadData()
        }
    }
    private func getSummaryReportDetails(page: Int) {
        self.showIndicator()
        OrderRouter.summaryReportDetails(page: page).send { [weak self] (response: APIGenericResponse<[SummaryReportDetails]>) in
            guard let self = self else {return}
            self.summaryReportDetails = response.data ?? []
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - Routes -
extension OrdersVC {
    
}

//MARK: - Delegate -
extension OrdersVC: SegmentedCollectionDelegate {
    var collectionItems: [SegmentedCollectionItem] {
        self.segmentedItems
    }
    
    func segmentedCollectionItem(_ segmentedCollectionItem: SegmentedCollection, didSelectItemAt indexPath: IndexPath) {
        for index in self.segmentedItems.indices {
            self.segmentedItems[index].isSelected = false
        }
        self.segmentedItems[indexPath.row].isSelected = true
        self.selectedType = Types(rawValue: self.segmentedItems[indexPath.row].id)!
        self.segmentedCollection.reload()
    }
}
