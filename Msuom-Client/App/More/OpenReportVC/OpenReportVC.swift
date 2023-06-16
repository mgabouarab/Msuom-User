//
//  OpenReportVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 25/05/2023.
//
//  Template by MGAbouarab®


import UIKit

class OpenReportVC: BaseVC {
    
    struct DisputeQuestions: Codable {
        let question: String
        let id: String
    }
    
    struct Reason: Codable {
        let name: String
        let id: String
        var isSelected = false
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var adNumberLabel: UILabel!
    @IBOutlet weak private var textView: AppTextView!
    @IBOutlet weak private var selectImageView: SelectImageView!
    
    //MARK: - Properties -
    private var items: [Reason] = []
    private var data: BidDetails.HomeSoonAuction?
    
    
    //MARK: - Creation -
    static func create(data: BidDetails.HomeSoonAuction?) -> OpenReportVC {
        let vc = AppStoryboards.auctions.instantiate(OpenReportVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.data = data
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.getQuestions()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Open Dispute".localized)
        self.imageView.setWith(string: self.data?.image)
        self.nameLabel.text = self.data?.name
        self.descriptionLabel.text = self.data?.description
        self.adNumberLabel.text = "Auction Number".localized + " " + (self.data?.number ?? "")
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func sendButtonPressed() {
        do {
            guard let bidId = self.data?.id else {return}
            let reasonId = self.items.first(where: {$0.isSelected})?.id
            let reason = try ValidationService.validate(description: self.textView.textValue())
            let images = self.selectImageView.getImagesData()
            
            let uploadData = images.map({UploadData(data: $0, fileName: Date().toString(), mimeType: .jpeg, name: "images")})
            self.dispute(bidId: bidId, questionId: reasonId, description: reason, images: uploadData.isEmpty ? nil : uploadData)
            
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
    
}


//MARK: - Networking -
extension OpenReportVC {
    private func dispute(bidId: String, questionId: String?, description: String, images: [UploadData]?) {
        self.showIndicator()
        AuctionRouter.dispute(bidId: bidId, questionId: questionId, description: description).send(data: images) { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.pop()
        }
    }
    private func getQuestions() {
        self.showIndicator()
        AuctionRouter.disputeQuestions.send { [weak self] (response: APIGenericResponse<[DisputeQuestions]>) in
            guard let self = self else {return}
            self.items = response.data?.map({Reason(name: $0.question, id: $0.id)}) ?? []
            if !self.items.isEmpty {
                self.items[0].isSelected = true
            }
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension OpenReportVC {
    
}

//MARK: - Start Of TableView -
extension OpenReportVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: AfterSaleCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension OpenReportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = self.items[indexPath.row]
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(named: item.isSelected ? "radioButton" : "radioButtonUnSelected")
        cell.textLabel?.text = item.name
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 13)
        return cell
    }
}
extension OpenReportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in self.items.indices {
            self.items[index].isSelected = false
        }
        self.items[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 30
//    }
}
//MARK: - End Of TableView -
