//
//  HomeModel.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 14/02/2023.
//

import Foundation

struct HomeSliderModel: Codable {
    let id: String
    let name: String
    let image: String
    let title: String?
    let description: String?
}

struct HomeModel: Codable {
    
    let key: HomeKeys
    let rotation: ScrollDirection
    
    
    let sliders: [HomeSliderModel]
    let carBrands: [IdName]
    let carStructures: [IdName]
    var bidsComingSoon: [Auction]
    let haraj: [MyCarsModel]
    let providers: [OfferProvider]
    var streams: [Auction]
    
    
    let title: String?
    let value: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decode(HomeKeys.self, forKey: .key)
        self.rotation = try container.decode(ScrollDirection.self, forKey: .rotation)
        self.sliders = try container.decodeIfPresent([HomeSliderModel].self, forKey: .sliders) ?? []
        self.carBrands = try container.decodeIfPresent([IdName].self, forKey: .carBrands) ?? []
        self.carStructures = try container.decodeIfPresent([IdName].self, forKey: .carStructures) ?? []
        self.bidsComingSoon = try container.decodeIfPresent([Auction].self, forKey: .bidsComingSoon) ?? []
        self.streams = try container.decodeIfPresent([Auction].self, forKey: .streams) ?? []
        self.haraj = try container.decodeIfPresent([MyCarsModel].self, forKey: .haraj) ?? []
        self.providers = try container.decodeIfPresent([OfferProvider].self, forKey: .providers) ?? []
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.value = try container.decode(Bool.self, forKey: .value)
    }
    
    
}
enum HomeKeys: String, Codable {
    case sliders
    case carBrands
    case carStructures
    case bidsComingSoon
    case haraj
    case providers
    case streams
}
enum ScrollDirection: String, Codable {
    case horizontal
    case vertical
}

