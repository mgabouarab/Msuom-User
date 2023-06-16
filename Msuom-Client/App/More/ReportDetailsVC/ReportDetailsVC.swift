//
//  ReportDetailsVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 25/05/2023.
//
//  Template by MGAbouarab®


import UIKit

class ReportDetailsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var adNumberLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var reasonLabel: UILabel!
    @IBOutlet weak private var descriptionProblemLabel: UILabel!
    @IBOutlet weak private var selectImageView: SelectImageView!
    @IBOutlet weak private var responseLabel: UILabel!
    @IBOutlet weak private var responseView: UIView!
    
    
    //MARK: - Properties -
    private var id: String!
    private var bidId: String?
    
    //MARK: - Creation -
    static func create(id: String) -> ReportDetailsVC {
        let vc = AppStoryboards.auctions.instantiate(ReportDetailsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.id = id
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.getData()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Dispute Details".localized)
    }
    
    //MARK: - Logic Methods -
    
    
    
    //MARK: - Actions -
    @IBAction private func toMangerButtonPressed() {
        let vc = ContactUsVC.create(bidId: self.bidId, disputeId: self.id)
        self.push(vc)
    }
}


//MARK: - Networking -
extension ReportDetailsVC {
    private func getData() {
        self.scrollView.isHidden = true
        self.showIndicator()
        AuctionRouter.disputeDetails(disputeId: self.id).send { [weak self] (response: APIGenericResponse<ReportDetails>) in
            guard let self = self else {return}
            self.imageView.setWith(string: response.data?.carImage)
            self.nameLabel.text = response.data?.carName
            self.descriptionLabel.text = response.data?.descriptionBid
            self.adNumberLabel.text = "Number:".localized + " " + "\(response.data?.adNumber ?? 0)"
            self.statusLabel.text = response.data?.status
            self.reasonLabel.text = response.data?.question
            self.descriptionProblemLabel.text = response.data?.description
            self.bidId = response.data?.bidId
            if let attachedImages = response.data?.attachedImages, !attachedImages.isEmpty {
                self.selectImageView.isHidden = false
                self.selectImageView.set(images: attachedImages.map({SelectImageView.ImageModel(url: $0, id: "")}), enableDelete: false)
            } else {
                self.selectImageView.isHidden = true
            }
            if let reply = response.data?.reply, !reply.trimWhiteSpace().isEmpty {
                self.responseView.isHidden = false
                self.responseLabel.text = reply
            } else {
                self.responseView.isHidden = true
            }
            self.scrollView.isHidden = false
        }
    }
}

//MARK: - Routes -
extension ReportDetailsVC {
    
    
}

struct ReportDetails: Codable {
    let adNumber: Int
    let attachedImages: [String]
    let bidId: String
    let carImage: String
    let carName: String
    let description: String
    let descriptionBid: String
    let id: String
    let question: String
    let reply: String
    let status: String
}
