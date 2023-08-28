//
//  LiveVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit
import OpenTok

protocol LiveDelegate: AnyObject {
    func fullScreenPressed()
    func addLiveView()
}

struct LiveStreamModel {
    let subscriber: OTSubscriber
    var isSelected: Bool = false
}

class LiveVC: BaseVC {
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var playView: LottieView!
    @IBOutlet weak private var fullScreenButton: UIButton!
    @IBOutlet weak private var actionButtonsView: UIView!
    @IBOutlet weak private var tableView: UITableView?
    @IBOutlet weak private var commentsContainerView: UIView!
    @IBOutlet weak private var replayContainerView: UIView!
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var selectedStreamView: UIView!
    @IBOutlet weak private var bidView: UIView!
    @IBOutlet weak private var bidContainerView: UIView!
    @IBOutlet weak private var increaseAmountTextField: UITextField!
    
    //MARK: - Properties -
    private var kApiKey: String = ""
    private var kSessionId: String = ""
    private var kToken: String = ""
    var subscribers: [LiveStreamModel] = []
    
    private var session: OTSession?
    var error: OTError?
    
    private var streamId: String?
    private var bidId: String?
    
    weak private var delegate: LiveDelegate?
    private var isFullScreen: Bool = false {
        didSet {
            self.commentsContainerView.isHidden = !isFullScreen
            self.bidView.isHidden = true
            self.bidContainerView.isHidden = !(isFullScreen && replayContainerView.isHidden == false)
            self.tableView?.reloadData()
        }
    }
    
    private var items: [FeedbackModel] = []
    private var currentPage: Int = 1
    private var isLast: Bool = false
    private var isFetching: Bool = false
    
    private let group = DispatchGroup()
    
    //MARK: - Creation -
    static func create(delegate: LiveDelegate?) -> LiveVC {
        let vc = AppStoryboards.auctions.instantiate(LiveVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = delegate
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialDesign()
        self.setupTableView()
        self.setupCollectionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: collectionView.bounds.size.width,
                                 height: collectionView.bounds.size.width)
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.commentsContainerView.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientMaskLayer.locations = [0, 0.2]
        self.commentsContainerView.layer.mask = gradientMaskLayer
    }
    override func addKeyboardDismiss() {
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.view.backgroundColor = .black
        self.resetView()
    }
    private func setupTableView() {
        self.tableView?.register(cellType: LiveCommentsCell.self)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
    }
    func resetView() {
        self.playView.isHidden = false
        self.actionButtonsView.isHidden = true
        self.commentsContainerView.isHidden = true
    }
    func showReplay(_ isSubscriber: Bool) {
        self.replayContainerView.isHidden = !isSubscriber
    }
    
    //MARK: - Logic -
    func set(kApiKey: String, kSessionId: String, kToken: String) {
        self.kApiKey = kApiKey
        self.kSessionId = kSessionId
        self.kToken = kToken
        
        self.doConnect()
    }
    func set(streamId: String?, bidId: String?) {
        self.streamId = streamId
        self.bidId = bidId
    }
    func resetList() {
        guard let streamId, let bidId else {return}
        self.items = []
        self.currentPage = 1
        self.isLast = false
        self.tableView?.reloadData()
        self.getComments(streamId: streamId, bidId: bidId)
    }
    func reloadCollectionView() {
        collectionView.isHidden = subscribers.filter({!$0.isSelected}).isEmpty || isFullScreen
        collectionView.reloadData()
    }
    
    
    
    //MARK: - Actions -
    @IBAction private func viewTapped() {
        
        guard UserDefaults.isLogin else {
            self.showLogoutAlert {
                self.presentLogin()
            }
            return
        }
        
        self.isFullScreen.toggle()
        self.fullScreenButton.isSelected = self.isFullScreen
        
        
        if isFullScreen {
            self.delegate?.fullScreenPressed()
            self.collectionView.isHidden = true
        } else {
            self.dismiss(animated: false) { [weak self] in
                self?.delegate?.addLiveView()
            }
            self.collectionView.isHidden = subscribers.count <= 1
        }
    }
    @IBAction private func sendButtonPressed() {
        guard let text = self.textView.text, !text.trimWhiteSpace().isEmpty else {return}
        guard let streamId = self.streamId, let bidId = self.bidId else {return}
        SocketConnection.sharedInstance.send(
            comment: text,
            streamId: streamId ,
            bidId: bidId) {
                self.items.append(
                    FeedbackModel(
                        avatar: UserDefaults.user?.avatar,
                        comment: text,
                        createAt: Date().toString(),
                        id: UUID().uuidString,
                        owner: true,
                        rating: nil,
                        streamId: streamId,
                        user_id: UserDefaults.user?.id,
                        userName: UserDefaults.user?.name,
                        name: UserDefaults.user?.name
                    )
                )
                self.tableView?.reloadData()
                self.tableView?.scrollToBottom(animated: false)
                self.textView.text = nil
            }
    }
    @IBAction private func sendBidButtonPressed() {
        if bidView.isHidden {
            self.bidView.isHidden = false
        } else {
            guard let price = self.increaseAmountTextField.text?.toDouble() else {return}
            guard let streamId = self.streamId else {return}
            guard let bidId = self.bidId else {return}
            
            self.showConfirmation(message: "Are you sure to continue?".localized) {
                SocketConnection.sharedInstance.sendBid(
                    streamId: streamId,
                    bidId: bidId,
                    viewerId: UserDefaults.user?.id ?? "",
                    price: "\(price)") {
                        print("🚦Socket:: suction Sent")
                        self.increaseAmountTextField.text = "1000"
                    }
            }
        }
    }
    @IBAction private func closeButtonPressed() {
        self.bidView.isHidden = true
    }
    
    
    @IBAction private func increaseButtonPressed() {
        
        let currentPrice = self.increaseAmountTextField.text?.toDouble() ?? 0
        let newPrice = currentPrice + 500
        
//        guard self.maxManualIncrease >= newPrice else {return}
        
        self.increaseAmountTextField.text = (newPrice).toString()
    }
    @IBAction private func decreaseButtonPressed() {
        
        let currentPrice = self.increaseAmountTextField.text?.toDouble() ?? 0
        let newPrice = currentPrice - 500
        
        guard newPrice >= 500 else {
            self.increaseAmountTextField.text = (500.0).toString()
            return
        }
        
        self.increaseAmountTextField.text = (newPrice).toString()
        
    }
    
    
}

//MARK: - OpenTok -
extension LiveVC {
    
    private func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        session?.connect(withToken: kToken, error: &error)
    }
    func doSubscribe(to stream: OTStream) {
        if let subscriber = OTSubscriber(stream: stream, delegate: self) {
            subscribers.append(LiveStreamModel(subscriber: subscriber, isSelected: subscribers.isEmpty ? true : false))
            session?.subscribe(subscriber, error: &error)
            
            reloadCollectionView()
        }
    }
    func findSubscriber(byStreamId id: String) -> (Int, OTSubscriber)? {
        for (index, entry) in subscribers.map({$0.subscriber}).enumerated() {
            if let stream = entry.stream, stream.streamId == id {
                return (index, entry)
            }
        }
        return nil
    }
    func findSubscriberCell(byStreamId id: String) -> LiveStreamCell? {
        for cell in collectionView.visibleCells {
            if let subscriberCell = cell as? LiveStreamCell,
                let subscriberOfCell = subscriberCell.subscriber,
                (subscriberOfCell.stream?.streamId ?? "") == id
            {
                return subscriberCell
            }
        }
        
        return nil
    }
    private func processError(_ error: OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}


// MARK: - OTSession delegate callbacks
extension LiveVC: OTSessionDelegate {
    
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
        subscribers.removeAll()
        reloadCollectionView()
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        doSubscribe(to: stream)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        
        guard let (index, subscriber) = findSubscriber(byStreamId: stream.streamId) else {
            return
        }
        subscriber.view?.removeFromSuperview()
        subscribers.remove(at: index)
        if subscribers.allSatisfy({!$0.isSelected}), !subscribers.isEmpty {
            subscribers[0].isSelected = true
        }
        reloadCollectionView()
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
}

// MARK: - OTSubscriber delegate callbacks
extension LiveVC: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        print("Subscriber connected")
        reloadCollectionView()
        self.actionButtonsView.isHidden = false
        self.playView.isHidden = true
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
}



//MARK: - UITableView -
extension LiveVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: LiveCommentsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.set(title: item.name, comment: item.comment, image: item.avatar)
        return cell
    }
}
extension LiveVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            guard let streamId, let bidId else {return}
            guard !self.isLast, !self.isFetching else {return}
            self.getComments(streamId: streamId, bidId: bidId)
        }
    }
}

//MARK: - Start Of CollectionView -
extension LiveVC {
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: LiveStreamCell.self)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension LiveVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let sessionView = self.subscribers.first(where: {$0.isSelected})?.subscriber.view {
            
            for view in self.selectedStreamView.subviews {
                view.removeFromSuperview()
            }
            self.selectedStreamView.addSubview(sessionView)
            sessionView.translatesAutoresizingMaskIntoConstraints = false
            sessionView.topAnchor.constraint(equalTo: selectedStreamView.topAnchor).isActive = true
            sessionView.bottomAnchor.constraint(equalTo: selectedStreamView.bottomAnchor).isActive = true
            sessionView.leadingAnchor.constraint(equalTo: selectedStreamView.leadingAnchor).isActive = true
            sessionView.trailingAnchor.constraint(equalTo: selectedStreamView.trailingAnchor).isActive = true
        }
        self.collectionView.isHidden = subscribers.filter({!$0.isSelected}).isEmpty || isFullScreen
        return subscribers.filter({!$0.isSelected}).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: LiveStreamCell.self, for: indexPath)
        cell.subscriber = subscribers.filter({!$0.isSelected}).map({$0.subscriber})[indexPath.row]
        return cell
    }
}
extension LiveVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if var currentSelectedItem = self.subscribers.first(where: { $0.isSelected }) {
            
            var filteredItems = self.subscribers.filter({!$0.isSelected})
            filteredItems[indexPath.row].isSelected = true
            currentSelectedItem.isSelected = false
            filteredItems.append(currentSelectedItem)
            self.subscribers = filteredItems
            reloadCollectionView()
        }
    }
}



//MARK: - Socket -
extension LiveVC {
    func gotMessage(value:[Any]){
        guard let dict = value[0] as? [String: Any] else{
            print("🚦Socket:: can not decode the new message as [String:Any]")
            return
        }
        print("New Socket Message🚦::\n\(dict)\nNew Socket Message::🚦")
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else {return}
            
            let avatar = dict["avatar"] as? String
            let name = dict["name"] as? String
            let id = dict["id"] as? String
            let viewerId = dict["viewerId"] as? String
            let comment = dict["comment"] as? String
            let streamId = dict["streamId"] as? String
            let createAt = dict["createAt"] as? String
            let owner = dict["owner"] as? Bool ?? false
            
            guard !self.items.contains(where: {$0.id == id}) else {return}
            
            let newMessage = FeedbackModel(
                avatar: avatar,
                comment: comment,
                createAt: createAt,
                id: id,
                owner: owner,
                streamId: streamId,
                user_id: viewerId,
                userName: name,
                name: name
            )
            self.items.append(newMessage)
            
            self.tableView?.reloadData()
            self.tableView?.scrollToBottom(animated: false)
        }
    }
}

//MARK: - Networking -
extension LiveVC {
    private func getComments(streamId: String, bidId: String) {
        self.isFetching = true
        AuctionRouter.commentsLiveStream(streamId: streamId, bidId: bidId, page: self.currentPage).send { [weak self] (response: APIGenericResponse<[FeedbackModel]>) in
            guard let self = self else {return}
            self.items = (response.data ?? []).reversed() + self.items
            isLast = response.paginate?.currentPage == response.paginate?.lastPage
            self.currentPage += 1
            self.tableView?.reloadData()
            self.isFetching = false
        }
    }
}
