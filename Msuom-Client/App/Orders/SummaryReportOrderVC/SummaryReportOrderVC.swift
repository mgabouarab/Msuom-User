//
//  SummaryReportOrderVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 08/02/2023.
//
//  Template by MGAbouarab®


import UIKit

class SummaryReportOrderVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    @IBOutlet weak private var orderNumberLabel: UILabel!
    
    //MARK: - Properties -
    private var data: SummaryReportDetails?
    private var id: String?
    
    //MARK: - Creation -
    static func create(data: SummaryReportDetails?, id: String?) -> SummaryReportOrderVC {
        let vc = AppStoryboards.orders.instantiate(SummaryReportOrderVC.self)
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
    func setViewWith(data: SummaryReportDetails) {
        self.imageView.setWith(string: data.image)
        let items = [data.typeName, data.brandName, data.year].compactMap({$0})
        self.titleLabel.text = items.joined(separator: " ")
        self.bodyLabel.text = data.description
        self.orderNumberLabel.text = "Ad Number:".localized + " " + "\(data.orderNo ?? 0)"
    }
    
    //MARK: - Actions -
    @IBAction private func pdfButtonPressed() {
       guard let pdfLink = self.data?.attach else {return}
       AppHelper.openUrl(pdfLink)
   }
}


//MARK: - Networking -
extension SummaryReportOrderVC {
    private func getDetailsFor(order id: String) {
        self.showIndicator()
        OrderRouter.detailsOrder(id: id).send { [weak self] (response: APIGenericResponse<SummaryReportDetails>) in
            guard let self = self, let data = response.data else {return}
            self.data = data
            self.setViewWith(data: data)
        }
    }
}

//MARK: - Routes -
extension SummaryReportOrderVC {
    
}
