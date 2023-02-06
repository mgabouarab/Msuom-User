//
//  CountryModel.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import Foundation

struct Country: Codable, CountryCodeItem {
    
    
    var id: Int? {
        return nil
    }
    var flag: String? {
        return nil
    }
    var countryCode: String? {
        return self.dialCode
    }
    
    let name: String
    let dialCode: String
    let code: String
    let emoji: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case dialCode = "dial_code"
        case code = "code"
        case emoji = "emoji"
    }
    
}
