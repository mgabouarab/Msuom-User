//
//  AuctionDetailsVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 14/05/2023.
//
//  Template by MGAbouarab®

import UIKit
import FirebaseDynamicLinks

class AuctionDetailsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var containerStackView: UIStackView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var liveContainerView: UIView!
    @IBOutlet weak private var priceView: AuctionPricesView!
    @IBOutlet weak private var sellIndicator: SellIndicatorView!
    @IBOutlet weak private var auctionInfoView: AuctionInfoView!
    @IBOutlet weak private var carInfoView: CarInfoView!
    @IBOutlet weak private var autoBidView: AutoBidView!
    @IBOutlet weak private var lastBidsView: LastBidsView!
    @IBOutlet weak private var sellerInfoView: SellerInfoView!
    @IBOutlet weak private var termsAndConditionView: ExpandableDetailsView!
    @IBOutlet weak private var auctionAdvantagesView: AuctionAdvantagesView!
    @IBOutlet weak private var nextAuctionsView: NextAuctionsView!
    @IBOutlet weak private var feedbacksView: FeedbacksView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var numberLabel: UILabel!
    @IBOutlet weak private var refundableView: UILabel!
    @IBOutlet weak private var sliderView: SliderView!
    @IBOutlet weak private var actionContainerView: UIView!
    @IBOutlet weak private var subscribeActionButton: UIButton!
    @IBOutlet weak private var sellActionButton: UIButton!
    
    //MARK: - Properties -
    private var id: String!
    private var currentBidId: String?
    private var nextBidId: String?
    private let group = DispatchGroup()
    private var isFromHome: Bool!
    private var isFinished: Bool = false
    private var isRunning: Bool = false
    private var timer: Timer?
    private var fullStartDate: String?
    private var fullEndDate: String?
    private var details: AuctionDetails? {
        didSet {
            guard let details else {return}
            self.updateViewWith(details: details)
        }
    }
    lazy private var liveView: LiveVC = LiveVC.create(delegate: self)
    private var type: String = "live"
    private var firstImageLinkForDeepLink: String?
    private var isFav: Bool? {
        didSet {
            self.favButton.image = UIImage(named: (isFav == true) ? "favFill" : "unFav")
        }
    }
    lazy private var favButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "unFav"), landscapeImagePhone: UIImage(named: "unFav"), style: .plain, target: self, action: #selector(self.toggleAuctionFav))
    
    //MARK: - Creation -
    static func create(id: String, isFromHome: Bool = false) -> AuctionDetailsVC {
        let vc = AppStoryboards.auctions.instantiate(AuctionDetailsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.id = id
        vc.isFromHome = isFromHome
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.getDetails(id: self.id)
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Auction Details".localized)
        self.containerStackView.alpha = 0
        if UserDefaults.isLogin {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "shareButton"), style: .plain, target: self, action: #selector(self.openShareSheet)), favButton]
        } else {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "shareButton"), style: .plain, target: self, action: #selector(self.openShareSheet))]
        }
        self.actionContainerView.isHidden = true
        self.scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    private func updateViewWith(details data: AuctionDetails) {
        self.id = data.stream?.id
        self.currentBidId = data.currentBid?.id
        self.nextBidId = data.nextBids?.first?.id
        self.isFinished = data.currentBid?.isFinished == "finished"
        self.isRunning = data.currentBid?.isRunning ?? false
        self.firstImageLinkForDeepLink = data.currentBid?.image
        self.autoBidView.isHidden = !(data.currentBid?.hasSubscription ?? false)
        self.lastBidsView.lastBidder = { [weak self] userId in
            guard let self = self else {return}
            self.autoBidView.isMyLastBid = userId == UserDefaults.user?.id
        }
        
        
        self.subscribeActionButton.isHidden = data.currentBid?.hasSubscription ?? false
        self.sellActionButton.isHidden = !(data.currentBid?.hasSubscription == true && (data.currentBid?.hasSell == true))
        self.actionContainerView.isHidden = (self.subscribeActionButton.isHidden && self.sellActionButton.isHidden)
        
        self.isFav = data.currentBid?.isFav
        
        if let type = data.currentBid?.type {
            self.type = type
        }
        if data.currentBid?.type == "live" {
            self.liveContainerView.isHidden = false
            self.sliderView.isHidden = true
            self.liveView.removeFromParent()
            self.liveView = LiveVC.create(delegate: self)
            self.addLiveView()
            
//            self.liveView.resetView()
            if let kApiKey = data.stream?.credentials?.apiKey, let kSessionId = data.stream?.credentials?.sessionId, let kToken = data.stream?.credentials?.token, isRunning {
                self.liveView.set(kApiKey: kApiKey, kSessionId: kSessionId, kToken: kToken)
                self.liveView.set(streamId: data.stream?.id, bidId: data.currentBid?.id)
            }
            self.liveView.showReplay(data.currentBid?.hasSubscription ?? false)
            
            if SocketConnection.sharedInstance.socket.status == .connected {
                self.liveView.resetList()
            }
            
            
            
            
        } else {
            self.liveContainerView.isHidden = true
            self.sliderView.isHidden = false
            self.sliderView.set(images: data.currentBid?.arrImage ?? [])
        }
        
        self.nameLabel.text = details?.currentBid?.name
        self.numberLabel.text = "Ad Number:".localized +  String(Int(details?.currentBid?.adNumber?.doubleValue ?? 0))
        self.priceView.set(
            startPrice: data.currentBid?.startPrice?.stringValue?.toPrice(),
            currentPrice: data.currentBid?.lastBidPrice?.stringValue?.toPrice(),
            numberOfBidding: String(data.currentBid?.countBids?.stringValue?.toInt() ?? 0)
        )
        self.sellIndicator.isHidden = true
        self.sellIndicator.set(progress: data.currentBid?.soldProgress)
        self.sellIndicator.setDetailsButton(isHidden: true)
        self.auctionInfoView.set(
            date: data.currentBid?.startDate,
            time: data.currentBid?.startTime,
            evaluationLetter: data.currentBid?.rating,
            isLive: data.currentBid?.type == "live"
        )
        if let currentBid = data.currentBid {
            self.carInfoView.set(info: currentBid)
        }
        
        if let startDate = data.currentBid?.startDate, let startTime = data.currentBid?.startTime {
            self.fullStartDate = startDate + " " + startTime
        }
        if let endDate = data.currentBid?.endDate, let endTime = data.currentBid?.endTime {
            self.fullEndDate = endDate + " " + endTime
        }
        if let streamId = self.id, let currentBidId = currentBidId, let price = data.currentBid?.lastBidPrice?.doubleValue {
            self.autoBidView.set(
                isAutoEnabled: data.currentBid?.autoBid ?? false,
                maxManualIncrease: data.bidPrice?.doubleValue ?? 500,
                streamId: streamId,
                bidId: currentBidId,
                max: data.currentBid?.maxPrice?.doubleValue
            )
            self.autoBidView.currentHighBid = price
        }
        self.refundableView.text = data.currentBid?.refundable
        self.sellerInfoView.set(
            name: data.provider?.name,
            address: data.provider?.cityName,
            image: data.provider?.image,
            pdfLink: data.currentBid?.checkReport,
            bidId: data.currentBid?.id,
            providerId: data.provider?.id
        )
        self.auctionAdvantagesView.set(items: details?.currentBid?.advantages ?? [])
        if let currentBidId = data.currentBid?.id {
            self.feedbacksView.enableAddComment = data.currentBid?.hasSubscription ?? false
            self.lastBidsView.set(bidId: currentBidId)
            self.feedbacksView.set(bidId: currentBidId, streamId: self.id)
        }
        self.termsAndConditionView.set(title: "Terms and Conditions".localized, description: details?.terms?.htmlToAttributedString?.string)
        self.nextAuctionsView.set(items: details?.nextBids ?? [])
        self.nextAuctionsView.tapAction = { [weak self] selectedId in
            guard let self = self else {return}
            self.isFromHome = false
            self.currentBidId = selectedId
            self.getDetails(id: selectedId)
        }
        self.isFromHome = false
        if SocketConnection.sharedInstance.socket.status != .connected {
            self.enterSocket()
        }
        
        if data.currentBid?.isFinished != "finished" {
            self.startTimer()
        } else {
            self.autoBidView.isHidden = true
            self.feedbacksView.enableAddComment = false
            self.actionContainerView.isHidden = true
            self.autoBidView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.containerStackView.alpha = 1
        }
    }
    
    //MARK: - Logic Methods -
    private func startTimer() {
        self.timer?.invalidate()
        self.timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else {return}
            if isRunning {
                guard let fullDate = self.fullEndDate else {return}
                if let _ = fullDate.toTimeRemain() {
//                    print("Time remain to end is\n \(time)\n")
                } else {
                    guard let currentBidId, !isFinished else {
                        self.timer?.invalidate()
                        self.timer = nil
                        return
                    }
                    SocketConnection.sharedInstance.finishAuction(streamId: self.id, bidId: currentBidId, type: self.type) {
                        print("🚦Socket:: finishedAuction")
                    }
                }
            } else {
                guard let fullDate = self.fullStartDate else {return}
                if let _ = fullDate.toTimeRemain() {
//                    print("Time remain to start is\n \(time)\n")
                } else {
                    if let currentBidId = self.currentBidId {
                        self.timer?.invalidate()
                        self.timer = nil
                        self.getDetails(id: currentBidId)
                    }
                }
            }
        })
        
    }
    
    //MARK: - Actions -
    @objc private func toggleAuctionFav() {
        
        guard UserDefaults.isLogin else {
            self.showLogoutAlert { [weak self] in
                self?.presentLogin()
            }
            return
        }
        
        guard let bidId = self.currentBidId else {return}
        self.showIndicator()
        CarRouter.toggleAuctionFav(id: bidId, streamId: self.id).send { [weak self] (response: APIGenericResponse<Bool>) in
            guard let self = self else {return}
            self.isFav = response.data
        }
    }
    @objc private func openShareSheet() {
        guard let currentBidId = self.currentBidId else {return}
        guard let link = URL(string: "https://maseom.page.link/auction/\(type)/\(currentBidId)") else { return }

        let dynamicLinksDomainURIPrefix = "https://maseom.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.aait.Msuom-Client")
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.aait.mseom_user")
        let socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()

        socialMetaTagParameters.title = self.nameLabel.text
        socialMetaTagParameters.descriptionText = "Join the auction now".localized
        socialMetaTagParameters.imageURL = URL(string: firstImageLinkForDeepLink ?? "")

        linkBuilder?.socialMetaTagParameters = socialMetaTagParameters
        linkBuilder?.shorten(completion: { shorten, _, _ in
            guard let shorten = shorten else {return}
            let activityController = UIActivityViewController(activityItems: [shorten], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        })
    }
    @IBAction private func subscribeButtonPressed() {
        guard UserDefaults.isLogin else {
            self.showLogoutAlert { [weak self] in
                self?.presentLogin()
            }
            return
        }
        self.makeAction(isSell: false)
    }
    @IBAction private func sellButtonPressed() {
        guard UserDefaults.isLogin else {
            self.showLogoutAlert { [weak self] in
                self?.presentLogin()
            }
            return
        }
        self.makeAction(isSell: true)
    }
    
    
    //MARK: - Deinit -
    deinit {
        print("ChatVC is AuctionDetailsVC, No memory leak found")
        self.exitAuction()
    }
    
}

//MARK: - Networking -
extension AuctionDetailsVC {
    private func getDetails(id: String) {
        self.showIndicator()
        let request = self.isFromHome ? AuctionRouter.bidDetailsFromHome(id: id) : AuctionRouter.bidDetails(id: id)
        request.send { [weak self] (response: APIGenericResponse<AuctionDetails>) in
            guard let self = self else {return}
            self.details = response.data
        }
    }
    private func makeAction(isSell: Bool) {
        guard let currentBidId = self.currentBidId else {return}
        self.showIndicator()
        let request = !isSell ? AuctionRouter.subscription(streamId: self.id, bidId: currentBidId) : AuctionRouter.sellCar(streamId: self.id, bidId: currentBidId)
        request.send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.getDetails(id: currentBidId)
        }
    }
}

//MARK: - Routes -
extension AuctionDetailsVC {
    
}

//MARK: - Delegation -
extension AuctionDetailsVC: LiveDelegate {
    func fullScreenPressed() {
        let vc = LiveContainerVC.create(liveView: self.liveView)
        self.present(vc, animated: true)
    }
    func addLiveView() {
        self.addChild(liveView)
        liveView.view.frame = self.liveContainerView.bounds
        self.liveContainerView.addSubview(liveView.view)
        liveView.didMove(toParent: self)
    }
}

//MARK: - Socket -
extension AuctionDetailsVC {
    private func enterSocket() {
        SocketConnection.sharedInstance.isExitingChat = false
        self.group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.connection()
            }
        }
        self.checkSocket()
    }
    private func exitAuction() {
        SocketConnection.sharedInstance.exitAuction(
            streamId: self.id,
            bidId: self.currentBidId ?? ""
        ) {
            SocketConnection.sharedInstance.isExitingChat = true
            SocketConnection.sharedInstance.socket.off(clientEvent: .connect)
            SocketConnection.sharedInstance.socket.off(clientEvent: .reconnect)
            SocketConnection.sharedInstance.socket.disconnect()
        }
    }
    private func checkSocket() {
        let socketConnectionStatus = SocketConnection.sharedInstance.socket.status
        print("🚦Socket:: connection status",socketConnectionStatus)
    }
    private func connection(){
        SocketConnection.sharedInstance.socket.on(clientEvent: .connect) { [weak self] (data, ack) in
            guard let self = self else {return}
            SocketConnection.sharedInstance.enterAuction(
                streamId: self.id,
                bidId: self.currentBidId ?? "",
                viewerId: UserDefaults.user?.id ?? "",
                type: self.type) { [weak self] in
                    guard let _ = self else {return}
                    print("🚦Socket:: enterAuction")
                    self?.liveView.resetList()
                    SocketConnection.sharedInstance.socket.on(SocketConnection.ChannelTypes.newBid) { [weak self] (value, ack) in
                        guard let self = self else {return}
                        self.gotBid(value: value)
                    }
                    SocketConnection.sharedInstance.socket.on(SocketConnection.ChannelTypes.onBidFinished) { [weak self] (value, ack) in
                        guard let self = self else {return}
                        if let nextBidId = self.nextBidId {
                            self.showSuccessAlert(message: "Auction Finished".localized)
                            self.getDetails(id: nextBidId)
                        } else {
                            self.showSuccessAlert(message: "Auction Finished".localized)
                            self.pop()
                        }
                    }
                }
            
//            SocketConnection.sharedInstance.socket.on(SocketConnection.ChannelTypes.newComment) { [weak self] (value, ack) in
//                guard let self = self else {return}
//                self.liveView.gotMessage(value: value)
//            }
            
            
        }
        SocketConnection.sharedInstance.socket.on(clientEvent: .connect) { [weak self] (data, ack) in
            guard let self = self else {return}
            SocketConnection.sharedInstance.socket.on(SocketConnection.ChannelTypes.newComment) { [weak self] (value, ack) in
                guard let self = self else {return}
                self.liveView.gotMessage(value: value)
            }
        }
        
        SocketConnection.sharedInstance.socket.on(clientEvent: .reconnect) { [weak self] (data, ack) in
            guard let _ = self else { return }
            SocketConnection.sharedInstance.checkCurrentStatus()
        }
        
        SocketConnection.sharedInstance.checkCurrentStatus()
        
    }
    private func gotBid(value:[Any]){
        guard let dict = value[0] as? [String: Any] else{
            print("🚦Socket:: can not decode the new Bid as [String:Any]")
            return
        }
        print("New Socket Bid🚦::\n\(dict)\nNew Socket Bid::🚦")
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else {return}
            
            let _ = dict["currency"] as? String
            let soldProgress = dict["soldProgress"] as? String
            let countBids = dict["countBids"] as? Int
            let lastBidPrice = dict["lastBidPrice"] as? Double
            
            let newBidding = dict["newBidding"] as? [String: Any]
            
            let avatar = newBidding?["avatar"] as? String
            let createAt = newBidding?["createAt"] as? String
            let currency = newBidding?["currency"] as? String
            let id = newBidding?["viewerId"] as? String
            let name = newBidding?["name"] as? String
            let price = newBidding?["price"] as? Double
            
            
            if let lastBidPrice = lastBidPrice, let userId = id {
                self.autoBidView.currentHighBid = lastBidPrice
                self.autoBidView.isMyLastBid = UserDefaults.user?.id == userId
            }
            self.priceView.update(currentPrice: lastBidPrice?.toPrice())
            self.priceView.update(numberOfBidding: "\(countBids ?? 0)")
            self.sellIndicator.set(progress: soldProgress)
            self.priceView.playSound()
            self.lastBidsView.add(bid:LastBidModel(viewerId: id, currency: currency, price: .double(price ?? 0), name: name, avatar: avatar, createAt: createAt)
            )
        }
    }
}
