//
//  NotificationModel.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/11/2022.
//

import Foundation

struct NotificationModel: Codable {
    
    let adminId: String?
    let bidId: String?
    let carId: String?
    let commentId: String?
    let disputeId: String?
    let key: String?
    let message: String?
    let nextBidId: String?
    let notificationId: String?
    let notifyId: String?
    let orderId: String?
    let streamId: String?
    let timeAdd: String?
    let title: String?
    let userId: String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case adminId
        case bidId
        case carId
        case commentId
        case disputeId
        case key
        case message
        case nextBidId
        case notificationId
        case notifyId
        case orderId
        case streamId
        case timeAdd
        case title
        case userId = "user_id"
        
        
    }
    
}
