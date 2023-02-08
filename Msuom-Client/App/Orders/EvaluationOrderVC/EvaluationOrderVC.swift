//
//  EvaluationOrderVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 08/02/2023.
//
//  Template by MGAbouarab®


import UIKit

class EvaluationOrderVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var brandLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var walkwayLabel: UILabel!
    @IBOutlet weak private var orderNumberLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var notesLabel: UILabel!
    
    //MARK: - Properties -
    private var data: EvaluationOrderDetails?
    private var id: String?
    
    //MARK: - Creation -
    static func create(data: EvaluationOrderDetails?, id: String?) -> EvaluationOrderVC {
        let vc = AppStoryboards.orders.instantiate(EvaluationOrderVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.data = data
        vc.id = id
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        if let data = self.data {
            self.setViewWith(data: data)
        } else if let id = self.id {
            self.getDetailsFor(order: id)
        }
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Order Details".localized)
    }
    
    //MARK: - Logic Methods -
    func setViewWith(data: EvaluationOrderDetails) {
        self.brandLabel.text = data.brandName
        self.typeLabel.text = data.type
        self.categoryLabel.text = data.categoryName
        self.statusLabel.text = data.statusName
        self.walkwayLabel.text = data.walkway
        self.orderNumberLabel.text = "Order Number:".localized + " " + "\(data.orderNo ?? 0)"
        self.priceLabel.text = "\(data.price ?? 0) \(data.currency ?? appCurrency)"
        self.notesLabel.text = data.notes
    }
    
    //MARK: - Actions -
    @IBAction private func pdfButtonPressed() {
        guard let pdfLink = self.data?.attach else {return}
        AppHelper.openUrl(pdfLink)
    }
    
}


//MARK: - Networking -
extension EvaluationOrderVC {
    private func getDetailsFor(order id: String) {
        self.showIndicator()
        OrderRouter.detailsOrder(id: id).send { [weak self] (response: APIGenericResponse<EvaluationOrderDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
}

//MARK: - Routes -
extension EvaluationOrderVC {
    
}
