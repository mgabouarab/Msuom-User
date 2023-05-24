//
//  SocketConstans.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 17/05/2023.
//

import Foundation
import SocketIO

open class SocketConnection {
    
    //MARK: - Constants -
    enum EmitTypes: String {
        case enterAuction = "enterAuction"
        case exitAuction = "exitAuction"
        case sendBid = "sendBid"
        case finishedAuction = "finishedAuction"
        case addComment = "addComment"
    }
    enum DataSocketKeys {
        static let bidId = "bidId"
        static let streamId = "streamId"
        static let viewerId = "viewerId"
        static let type = "type"
        static let viewerType = "viewerType"
        static let viewerPath = "viewerPath"
        static let price = "price"
        static let comment = "comment"
        static let lang = "lang"
        static let autoBid = "autoBid"
    }
    enum ChannelTypes {
        static let newBid = "newBid"
        static let onBidFinished = "onBidFinished"
        static let newComment = "newComment"
    }
    
    //MARK: - Properties -
    public static let sharedInstance = SocketConnection()
    let manager: SocketManager
    public var socket: SocketIOClient
    public var isExitingChat: Bool = false
    private let url = Server.socketURL.rawValue + ":" + Server.socketPort.rawValue
    
    //MARK: - Init -
    private init() {
        manager = SocketManager(socketURL: URL(string: url)!, config: [.log(false), .compress])
        socket = manager.defaultSocket
        self.handleEvents()
    }
    
    //MARK: - Lifecycle -
    private func handleEvents() {
        self.socket.on(clientEvent: .error) { [weak self] (data, ack) in
            guard let self = self else { return }
            print("🚦Socket:: Error")
            print("🚦Socket:: \(data)")
            self.checkCurrentStatus()
        }
        self.socket.on(clientEvent: .disconnect) { [weak self] (data, ack) in
            guard let self = self else { return }
            self.checkCurrentStatus()
        }
        self.socket.on(clientEvent: .ping) { [weak self] (data, ack) in
            guard let _ = self else { return }
            print("🚦Socket:: Ping")
        }
        self.socket.on(clientEvent: .reconnect) { [weak self] (data, ack) in
            guard let self = self else { return }
            self.checkCurrentStatus()
        }
    }
    func checkCurrentStatus() {
        if self.socket.status == .notConnected {
            print("🚦Socket:: Not connected")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }
        if self.socket.status == .disconnected {
            print("🚦Socket:: Disconnected")
            guard !self.isExitingChat else {return}
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }
        if self.socket.status == .connecting {
            print("🚦Socket:: Trying To Connect...")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }
        if self.socket.status == .connected {
            print("🚦Socket:: Connected")
        }
    }
    
    private func emit(for type: EmitTypes, data: [String: Any], completion: (() -> ())?) {
        
        print("🚦Socket:: Socket Action is \(type.rawValue) \n data is: \(data)/n🚦Socket::")
        
        SocketConnection.sharedInstance.socket.emit(
            type.rawValue,
            with: [data],
            completion: completion
        )
    }


    func enterAuction(
        streamId: String,
        bidId: String,
        viewerId: String,
        type: String,
        completion: (() -> ())?
    ) {
        var data = [String: Any]()
        data[DataSocketKeys.streamId] = streamId
        data[DataSocketKeys.bidId] = bidId
        data[DataSocketKeys.viewerId] = viewerId
        data[DataSocketKeys.type] = type
        emit(for: EmitTypes.enterAuction, data: data, completion: completion)
    }
    func exitAuction(
        streamId: String,
        bidId: String,
        completion: (() -> ())?
    ) {
        var data = [String: Any]()
        data[DataSocketKeys.streamId] = streamId
        data[DataSocketKeys.bidId] = bidId
        emit(for: EmitTypes.exitAuction, data: data, completion: completion)
    }
    func sendBid(
        streamId: String,
        bidId: String,
        viewerId: String,
        price: String,
        completion: (() -> ())?
    ) {
        var data = [String: Any]()
        data[DataSocketKeys.streamId] = streamId
        data[DataSocketKeys.bidId] = bidId
        data[DataSocketKeys.viewerId] = viewerId
        data[DataSocketKeys.viewerType] = "user"
        data[DataSocketKeys.price] = price
        data[DataSocketKeys.lang] = Language.apiLanguage()
        emit(for: EmitTypes.sendBid, data: data, completion: completion)
    }
    func finishAuction(
        streamId: String,
        bidId: String,
        type: String,
        completion: (() -> ())?
    ) {
        var data = [String: Any]()
        data[DataSocketKeys.streamId] = streamId
        data[DataSocketKeys.bidId] = bidId
        data[DataSocketKeys.lang] = Language.apiLanguage()
        data[DataSocketKeys.type] = type
        emit(for: EmitTypes.finishedAuction, data: data, completion: completion)
    }
    
    func send(
        comment: String,
        streamId: String,
        bidId: String,
        completion: (() -> ())?
    ) {
        var data = [String: Any]()
        data[DataSocketKeys.streamId] = streamId
        data[DataSocketKeys.bidId] = bidId
        data[DataSocketKeys.comment] = comment
        data[DataSocketKeys.viewerId] = UserDefaults.user?.id ?? ""
        data[DataSocketKeys.viewerPath] = "user"
        data[DataSocketKeys.lang] = Language.apiLanguage()
        emit(for: EmitTypes.addComment, data: data, completion: completion)
    }
    
}
