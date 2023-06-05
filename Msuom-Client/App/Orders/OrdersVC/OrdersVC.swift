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
        case afterSaleService
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
        OrderType(id: "purchaseOrder", name: "Purchase Orders".localized, isSelected: false),
        OrderType(id: "afterSaleService", name: "After Sale Orders".localized, isSelected: false)
    ]
    private var shippingOrderDetails: [ShippingOrderDetails] = []
    private var evaluationOrderDetails: [EvaluationOrderDetails] = []
    private var purchaseOrderDetails: [PurchaseOrderDetails] = []
    private var summaryReportDetails: [SummaryReportDetails] = []
    private var afterSaleServiceDetails: [ShippingOrderDetails] = []
    private var selectedType: Types = .shipping
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    
    
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
        self.addObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
        self.getNotificationCount()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.setLeading(title: "My Orders".localized)
        self.setNotificationButton(imageName:
            UserDefaults.notificationCount == 0 ? "notificationButton" : "notificationButtonUnRead"
        )
        self.segmentedCollection.delegate = self
        self.segmentedCollection.reload()
    }
    
    //MARK: - Logic Methods -
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCountDidChanged), name: .notificationNumberChanged, object: nil)
    }
    
    //MARK: - Actions -
    @objc private func notificationCountDidChanged() {
        self.setNotificationButton(imageName:
            UserDefaults.notificationCount == 0 ? "notificationButton" : "notificationButtonUnRead"
        )
    }
    @objc func refresh() {
        
        self.shippingOrderDetails = []
        self.evaluationOrderDetails = []
        self.purchaseOrderDetails = []
        self.summaryReportDetails = []
        self.afterSaleServiceDetails = []
        
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.animateToTop()
        
        self.currentPage = 1
        self.isLast = false
        self.isFetching = false
        
        switch self.selectedType {
            
        case .shipping:
            self.getShippingOrderDetails(page: self.currentPage)
        case .evaluation:
            self.getEvaluationOrderDetails(page: self.currentPage)
        case .purchaseOrder:
            self.getPurchaseOrderDetails(page: self.currentPage)
        case .summaryReport:
            self.getSummaryReportDetails(page: self.currentPage)
        case .afterSaleService:
            self.getAfterSaleServiceDetails(page: self.currentPage)
        }
        
    }
    
}


//MARK: - Start Of TableView -
extension OrdersVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ShippingOrderCell.self, bundle: nil)
        self.tableView.register(cellType: EvaluationOrderCell.self, bundle: nil)
        self.tableView.register(cellType: SummaryReportOrderCell.self, bundle: nil)
        self.tableView.register(cellType: PurchaseOrderCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension OrdersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.selectedType {
        case .shipping:
            self.tableView.setPlaceholder(isEmpty: shippingOrderDetails.isEmpty)
            return self.shippingOrderDetails.count
        case .evaluation:
            self.tableView.setPlaceholder(isEmpty: evaluationOrderDetails.isEmpty)
            return self.evaluationOrderDetails.count
        case .purchaseOrder:
            self.tableView.setPlaceholder(isEmpty: purchaseOrderDetails.isEmpty)
            return self.purchaseOrderDetails.count
        case .summaryReport:
            self.tableView.setPlaceholder(isEmpty: summaryReportDetails.isEmpty)
            return self.summaryReportDetails.count
        case .afterSaleService:
            self.tableView.setPlaceholder(isEmpty: afterSaleServiceDetails.isEmpty)
            return self.afterSaleServiceDetails.count
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.selectedType {
        case .shipping:
            let cell = tableView.dequeueReusableCell(with: ShippingOrderCell.self, for: indexPath)
            let item = self.shippingOrderDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        case .evaluation:
            let cell = tableView.dequeueReusableCell(with: EvaluationOrderCell.self, for: indexPath)
            let item = self.evaluationOrderDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        case .purchaseOrder:
            let cell = tableView.dequeueReusableCell(with: PurchaseOrderCell.self, for: indexPath)
            let item = self.purchaseOrderDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        case .summaryReport:
            let cell = tableView.dequeueReusableCell(with: SummaryReportOrderCell.self, for: indexPath)
            let item = self.summaryReportDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        case .afterSaleService:
            let cell = tableView.dequeueReusableCell(with: ShippingOrderCell.self, for: indexPath)
            let item = self.afterSaleServiceDetails[indexPath.row]
            cell.configureWith(data: item)
            return cell
        }
        
    }
}
extension OrdersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.selectedType {
        case .shipping:
            let item = self.shippingOrderDetails[indexPath.row]
            let vc = ShippingOrderVC.create(data: item, id: nil)
            self.push(vc)
        case .evaluation:
            let item = self.evaluationOrderDetails[indexPath.row]
            let vc = EvaluationOrderVC.create(data: item, id: nil)
            self.push(vc)
        case .purchaseOrder:
            let item = self.purchaseOrderDetails[indexPath.row]
            let vc = PurchaseOrderVC.create(data: item, id: nil)
            self.push(vc)
        case .summaryReport:
            let item = self.summaryReportDetails[indexPath.row]
            let vc = SummaryReportOrderVC.create(data: item, id: nil)
            self.push(vc)
        case .afterSaleService:
            let item = self.afterSaleServiceDetails[indexPath.row]
            let vc = AfterBuyOrderVC.create(data: item, id: nil)
            self.push(vc)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !self.isLast && !self.isFetching && (indexPath.row % listLimit == 0) {
            switch self.selectedType {
            case .shipping:
                self.getShippingOrderDetails(page: self.currentPage)
            case .evaluation:
                self.getEvaluationOrderDetails(page: self.currentPage)
            case .purchaseOrder:
                self.getPurchaseOrderDetails(page: self.currentPage)
            case .summaryReport:
                self.getSummaryReportDetails(page: self.currentPage)
            case .afterSaleService:
                self.getAfterSaleServiceDetails(page: self.currentPage)
            }
        }
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension OrdersVC {
    
    private func getNotificationCount() {
        HomeRouter.notifyCount.send { [weak self] (response: APIGenericResponse<Int>) in
            guard let _ = self else {return}
            UserDefaults.notificationCount = response.data ?? 0
        }
    }
    
    private func getShippingOrderDetails(page: Int) {
        self.showIndicator()
        self.isFetching = true
        OrderRouter.shippingOrderDetails(page: page).send { [weak self] (response: APIGenericResponse<[ShippingOrderDetails]>) in
            guard let self = self else {return}
            self.shippingOrderDetails = response.data ?? []
            self.tableView.reloadData()
            self.currentPage += 1
            if self.shippingOrderDetails.isEmpty || (response.data ?? []).isEmpty || response.data?.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
    private func getEvaluationOrderDetails(page: Int) {
        self.showIndicator()
        self.isFetching = true
        OrderRouter.evaluationOrderDetails(page: page).send { [weak self] (response: APIGenericResponse<[EvaluationOrderDetails]>) in
            guard let self = self else {return}
            self.evaluationOrderDetails = response.data ?? []
            self.tableView.reloadData()
            self.currentPage += 1
            if self.evaluationOrderDetails.isEmpty || (response.data ?? []).isEmpty || response.data?.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
    private func getPurchaseOrderDetails(page: Int) {
        self.showIndicator()
        self.isFetching = true
        OrderRouter.purchaseOrderDetails(page: page).send { [weak self] (response: APIGenericResponse<[PurchaseOrderDetails]>) in
            guard let self = self else {return}
            self.purchaseOrderDetails = response.data ?? []
            self.tableView.reloadData()
            self.currentPage += 1
            if self.purchaseOrderDetails.isEmpty || (response.data ?? []).isEmpty || response.data?.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
    private func getSummaryReportDetails(page: Int) {
        self.showIndicator()
        self.isFetching = true
        OrderRouter.summaryReportDetails(page: page).send { [weak self] (response: APIGenericResponse<[SummaryReportDetails]>) in
            guard let self = self else {return}
            self.summaryReportDetails = response.data ?? []
            self.tableView.reloadData()
            self.currentPage += 1
            if self.summaryReportDetails.isEmpty || (response.data ?? []).isEmpty || response.data?.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
        }
    }
    private func getAfterSaleServiceDetails(page: Int) {
        self.showIndicator()
        self.isFetching = true
        OrderRouter.afterSaleServiceDetails(page: page).send { [weak self] (response: APIGenericResponse<[ShippingOrderDetails]>) in
            guard let self = self else {return}
            self.afterSaleServiceDetails = response.data ?? []
            self.tableView.reloadData()
            self.currentPage += 1
            if self.afterSaleServiceDetails.isEmpty || (response.data ?? []).isEmpty || response.data?.count != listLimit {
                self.isLast = true
            }
            self.isFetching = false
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
        self.refresh()
    }
}
