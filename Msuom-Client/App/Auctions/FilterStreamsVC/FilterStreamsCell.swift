//
//  FilterStreamsCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/05/2023.
//
//  Template by MGAbouarab®

//MARK:- Cell
import UIKit
import OpenTok

//MARK: - UITableViewCell -
class FilterStreamsCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var containerStack: UIStackView!
    @IBOutlet weak private var videoContainerStack: UIStackView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var liveView: UIView!
    
    //MARK: - properties -
    private var kApiKey: String = ""
    private var kSessionId: String = ""
    private var kToken: String = ""
    private var subscriber: OTSubscriber? {
        didSet {
            for view in videoContainerStack.arrangedSubviews {
                view.removeFromSuperview()
            }
            if let streamView = subscriber?.view {
                self.videoContainerStack.addArrangedSubview(streamView)
            }
        }
    }
    
    private var session: OTSession?
    var error: OTError?
    
    var detailsActions: (()->())?
    
    
    
    //MARK: - Overriden Methods-
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDesign()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCellData()
    }
    
    //MARK: - Design Methods -
    private func setupDesign() {
        self.selectionStyle = .none
        self.containerStack.addShadow()
    }
    private func resetCellData() {
        for view in videoContainerStack.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    //MARK: - Configure Data -
    private func configureVideo(kApiKey: String, kSessionId: String, kToken: String) {
        self.kApiKey = kApiKey
        self.kSessionId = kSessionId
        self.kToken = kToken
    }
    func configureWith(data: BidStream) {
        self.nameLabel.text = data.name
        self.priceLabel.text = data.lastBidPrice?.stringValue
        self.liveView.isHidden = !(data.type == "live")
        self.containerStack.addBorder(
            with: (data.isPlaying == true) ? Theme.colors.secondaryColor.cgColor: UIColor.clear.cgColor
        )
        self.containerStack.layer.borderWidth = 3
        if let kApiKey = data.credentials?.apiKey, let kSessionId = data.credentials?.sessionId, let kToken = data.credentials?.token {
            configureVideo(kApiKey: kApiKey, kSessionId: kSessionId, kToken: kToken)
        }
        if data.isPlaying == true {
            self.doConnect()
        }
    }
    
    //MARK: - Actions -
    @IBAction func fullScreenButtonPressed() {
        self.detailsActions?()
    }
    
    
}

//MARK: - OpenTok -
extension FilterStreamsCell {
    
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
            self.subscriber = subscriber
            session?.subscribe(subscriber, error: &error)
        }
    }
    private func processError(_ error: OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.parentContainerViewController?.present(controller, animated: true, completion: nil)
            }
        }
    }
}


// MARK: - OTSession delegate callbacks
extension FilterStreamsCell: OTSessionDelegate {
    
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
        subscriber = nil
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        doSubscribe(to: stream)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
        
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
}

// MARK: - OTSubscriber delegate callbacks
extension FilterStreamsCell: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        print("Subscriber connected")
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
}
