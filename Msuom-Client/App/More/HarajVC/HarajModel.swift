//
//  HarajModel.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 30/01/2023.
//

import Foundation

struct HarajModel: Codable {
    let carBrands: [BrandModel]
    let cars: [MyCarsModel]
}

struct BrandModel: Codable {
    let id: String
    let image: String
    let name: String
    var isSelected: Bool?
}
