//
//  NotificationModel.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/11/2022.
//

import Foundation

struct NotificationModel: Codable {
    let id: String
    let title: String?
}

extension NotificationModel {
    static let notifications: [NotificationModel] = [
        NotificationModel(id: "", title: "kdsnlknsdlkj jsdk vjsd kjlds ljvcs dljvh dsl"),
        NotificationModel(id: "", title: "kdsk je vkj ewivju ewijv eijv eij"),
        NotificationModel(id: "", title: "j wcvjwe bvlkj.ewnv; kwej v;jkew vkjw evkdsk je vkj ewivju ewijv eijv eij"),
    ]
}
