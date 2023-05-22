//
//  CompleteAuctionInfoVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 13/05/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class CompleteAuctionInfoVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var reportPickerView: SelectFileView!
    @IBOutlet weak private var notRefundableButton: UIButton!
    @IBOutlet weak private var refundableButton: UIButton!
    @IBOutlet weak private var notRefundableView: UIView!
    @IBOutlet weak private var refundableView: UIView!
    @IBOutlet weak private var evaluationView: EvaluationView!
    @IBOutlet weak private var lowestPriceTextFieldView: NormalTextFieldView!
    
    //MARK: - Properties -
    private lazy var items: [AdvantageAndDisadvantageModel] = [
        AdvantageAndDisadvantageModel()
    ]
    private lazy var isRefundable: Bool = false
    private var addAuctionModel: AddAuctionModel!
    private var type: AuctionTypeSelectionVC.AuctionTypes!
    
    //MARK: - Creation -
    static func create(type: AuctionTypeSelectionVC.AuctionTypes, addAuctionModel: AddAuctionModel) -> CompleteAuctionInfoVC {
        let vc = AppStoryboards.auctions.instantiate(CompleteAuctionInfoVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.addAuctionModel = addAuctionModel
        vc.type = type
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
        self.addBackButtonWith(title: "Add Auction".localized)
        
        self.lowestPriceTextFieldView.isHidden = self.type == .normal
        
        let notRefundableTap = UITapGestureRecognizer(target: self, action: #selector(self.notRefundableTapped))
        self.notRefundableView.addGestureRecognizer(notRefundableTap)
        let refundableTap = UITapGestureRecognizer(target: self, action: #selector(self.refundableTapped))
        self.refundableView.addGestureRecognizer(refundableTap)
        self.refundableView.isHidden = !(UserDefaults.user?.canRefundableCar ?? false)
        
        self.evaluationView.set(data:
                                    [
                                        EvaluationModel(degree: "A", color: Theme.colors.a, isSelected: true),
                                        EvaluationModel(degree: "B", color: Theme.colors.b),
                                        EvaluationModel(degree: "C", color: Theme.colors.c),
                                        EvaluationModel(degree: "D", color: Theme.colors.d),
                                        EvaluationModel(degree: "F", color: Theme.colors.f)
                                    ]
        )
        
        
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc private func notRefundableTapped() {
        self.notRefundableButton.isSelected = true
        self.refundableButton.isSelected = false
        self.isRefundable = false
    }
    @objc private func refundableTapped() {
        self.notRefundableButton.isSelected = false
        self.refundableButton.isSelected = true
        self.isRefundable = true
    }
    @IBAction private func addNewAdditionButtonPressed() {
        self.items.append(AdvantageAndDisadvantageModel())
        self.tableView.reloadData()
    }
    @IBAction private func addButtonPressed() {
        do {
            let file = try ValidationService.validate(attachment: self.reportPickerView.value())
            let checkReport = UploadData(
                data: file,
                fileName: Date().description,
                mimeType: .pdf,
                name: "checkReport"
            )
            guard self.items.allSatisfy({$0.isValid}) else {
                throw NSError(domain: "Please enter all required fields".localized, code: 0)
            }
            
            struct Advantage: Codable {
                let title: AdvantageLanguage
                let description: AdvantageLanguage
            }
            struct AdvantageLanguage: Codable {
                let ar: String
                let en: String
            }
            
            let advantages = self.items.map({Advantage(title: AdvantageLanguage(ar: $0.arabicName!, en: $0.englishName!), description: AdvantageLanguage(ar: $0.arabicDescription!, en: $0.englishDescription!))}).toString()
            
            guard let rating = self.evaluationView.selectedEvaluation else {
                throw NSError(domain: "Please select car evaluation".localized, code: 0)
            }
            
            
            
            switch self.type! {
            case .normal:
                self.addAuctionWith(
                    addAuctionModel: self.addAuctionModel,
                    checkReport: checkReport,
                    advantages: advantages,
                    rating: rating,
                    limitPrice: nil
                )
            case .live:
                let limitPrice = try CarValidationService.validate(startPrice: self.lowestPriceTextFieldView.textValue())
                self.addAuctionWith(
                    addAuctionModel: self.addAuctionModel,
                    checkReport: checkReport,
                    advantages: advantages,
                    rating: rating,
                    limitPrice: limitPrice
                )
            }
            
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    
}


//MARK: - Start Of TableView -
extension CompleteAuctionInfoVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: AdvantageAndDisadvantageCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension CompleteAuctionInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: AdvantageAndDisadvantageCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item, hideDeleteAction: indexPath.row == 0)
        cell.onArabicNameTextChanged = { [weak self] text in
            guard let self = self else {return}
            self.items[indexPath.row].arabicName = text
        }
        cell.onEnglishNameTextChanged = { [weak self] text in
            guard let self = self else {return}
            self.items[indexPath.row].englishName = text
            }
        cell.onArabicDescriptionChanged = { [weak self] text in
            guard let self = self else {return}
            self.items[indexPath.row].arabicDescription = text
                }
        cell.onEnglishDescriptionChanged = { [weak self] text in
            guard let self = self else {return}
            self.items[indexPath.row].englishDescription = text
                    }
        cell.deleteAction = {[weak self] in
            guard let self = self else {return}
            self.items.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        return cell
    }
}
extension CompleteAuctionInfoVC: UITableViewDelegate {
    private func addAuctionWith(
        addAuctionModel: AddAuctionModel,
        checkReport: UploadData,
        advantages: String,
        rating: String,
        limitPrice: String?
    ) {
        
        let uploadedData: [UploadData] = addAuctionModel.images + [checkReport]
        
        self.showIndicator()
        
        AuctionRouter.bid(
            price: addAuctionModel.price,
            brandId: addAuctionModel.brandId,
            typeId: addAuctionModel.typeId,
            categoryId: addAuctionModel.classId,
            year: addAuctionModel.year,
            specificationId: addAuctionModel.specificationsId,
            importedCarId: addAuctionModel.incomingId,
            colorId: addAuctionModel.colorId,
            vehicleTypeId: addAuctionModel.driveId,
            fuelTypeId: addAuctionModel.fuelId,
            transmissionGearId: addAuctionModel.asphaltId,
            statusId: addAuctionModel.statusId,
            cylinders: addAuctionModel.cylinders,
            engineSize: addAuctionModel.engineId,
            sellTypeId: addAuctionModel.howToSellId,
            walkway: addAuctionModel.walkway,
            cityId: addAuctionModel.cityId,
            isRefundable: isRefundable,
            type: addAuctionModel.type,
            rating: rating,
            advantages: advantages,
            startDate: addAuctionModel.startDate,
            endDate: addAuctionModel.endDate,
            startTime: addAuctionModel.startTime,
            endTime: addAuctionModel.endTime,
            limitPrice: limitPrice
        ).send(data: uploadedData) { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.popToRoot()
        }
        
        
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension CompleteAuctionInfoVC {
    
}

//MARK: - Routes -
extension CompleteAuctionInfoVC {
    
}
