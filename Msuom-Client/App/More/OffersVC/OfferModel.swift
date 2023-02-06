//
//  OfferModel.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 31/01/2023.
//

import Foundation

struct Offers: Codable {
    let carBrands: [BrandModel]
    let providers: [OfferProvider]
    let offers: [OfferModel]
}

struct OfferModel: Codable {
    let offer: MyCarsModel
    let provider: OfferProvider
}

struct OfferProvider: Codable {
    let id: String?
    let name: String?
    let phoneNo: String?
    let image: String?
    let endDate: String?
    let cityName: String?
    let address: String?
    let latitude: String?
    let longitude: String?
    let carCount: String?
    let bio: String?
    let star: Bool?
    var isSelected: Bool?
}
