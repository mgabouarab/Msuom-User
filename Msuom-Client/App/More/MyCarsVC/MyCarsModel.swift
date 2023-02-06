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
        
    }
    
    
}


extension MyCarsModel: CarCellViewData {
    var sellType: String {
        return self.sellTypeName ?? ""
    }
}



