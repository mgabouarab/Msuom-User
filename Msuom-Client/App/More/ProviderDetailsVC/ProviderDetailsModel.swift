//
//  ProviderDetailsModel.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 01/02/2023.
//

import Foundation

struct ProviderDetailsModel: Codable {
    let provider: OfferProvider
    let cars: [MyCarsModel]
}
