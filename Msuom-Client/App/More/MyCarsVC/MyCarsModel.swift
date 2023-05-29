//
//  MyCarsModel.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/01/2023.
//

import Foundation

struct MyCarsModel: Codable {
    
    let id: String
    let image: String?
    let isFinancing: String?
    let name: String?
    let owner: String?
    let price: String
    let sellTypeName: String?
    let type: String?
    let typeName: String?
    let available: String?
    let title: String?
    let description: String?
    let faceBook: String?
    let twitter: String?
    let whats: String?
    
    let endDate: String?
    let endedAt: String?
    let endTime: String?
    let isRunning: Bool?
    let startDate: String?
    let startedAt: String?
    let startPrice: String?
    let startTime: String?
    let streamId: String?
    
    
    
    var fullStartDate: String {
        guard let startDate = self.startDate else {
            print("The Auction with id: \(self.id) has no startDate")
            return ""
        }
        guard let startTime = self.startTime else {
            print("The Auction with id: \(self.id) has no startTime")
            return ""
        }
        return "\(startDate) \(startTime)"
    }
    var fullEndDate: String {
        guard let endDate = self.endDate else {
            print("The Auction with id: \(self.id) has no endDate")
            return ""
        }
        guard let endTime = self.endTime else {
            print("The Auction with id: \(self.id) has no endTime")
            return ""
        }
        return "\(endDate) \(endTime)"
    }
    
    var isLive: Bool {
        guard let type = self.type, type == "live" else {
            return false
        }
        return true
    }
    var isStart: Bool {
        guard self.isRunning == true else {
            return false
        }
        return true
    }
    
    
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.isFinancing = try container.decodeIfPresent(String.self, forKey: .isFinancing)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.owner = try container.decodeIfPresent(String.self, forKey: .owner)
        self.price = try container.decodeIfPresent(String.self, forKey: .price) ?? ""
        self.sellTypeName = try container.decodeIfPresent(String.self, forKey: .sellTypeName)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.typeName = try container.decodeIfPresent(String.self, forKey: .typeName)
        self.available = try container.decodeIfPresent(String.self, forKey: .available)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.faceBook = try container.decodeIfPresent(String.self, forKey: .faceBook)
        self.twitter = try container.decodeIfPresent(String.self, forKey: .twitter)
        self.whats = try container.decodeIfPresent(String.self, forKey: .whats)
        
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.endedAt = try container.decodeIfPresent(String.self, forKey: .endedAt)
        self.endTime = try container.decodeIfPresent(String.self, forKey: .endTime)
        self.isRunning = try container.decodeIfPresent(Bool.self, forKey: .isRunning)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        self.startedAt = try container.decodeIfPresent(String.self, forKey: .startedAt)
        self.startPrice = try container.decodeIfPresent(String.self, forKey: .startPrice)
        self.startTime = try container.decodeIfPresent(String.self, forKey: .startTime)
        self.streamId = try container.decodeIfPresent(String.self, forKey: .streamId)
        
        
    }
    
    
}


extension MyCarsModel: CarCellViewData {
    var sellType: String {
        return self.sellTypeName ?? ""
    }
}
