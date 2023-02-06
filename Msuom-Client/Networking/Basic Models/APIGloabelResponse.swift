//
//  APIGloabelResponse.swift
//
//  Created by MGAbouarab®
//

import Foundation


class APIGlobalResponse: Codable {
    var key: APIServerResponseKey
    var message: String
    var paginate: Paginate?
    
    enum CodingKeys: String, CodingKey {
        case key
        case message
        case paginate
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decode(APIServerResponseKey.self, forKey: .key)
        message = try values.decode(String.self, forKey: .message)
        paginate = try values.decodeIfPresent(Paginate.self, forKey: .paginate)
    }
    
}

class APIGenericResponse<T: Codable>: APIGlobalResponse {
    
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case data
        case key
        case message
        case paginate
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decode(APIServerResponseKey.self, forKey: .key)
        message = try values.decode(String.self, forKey: .message)
        paginate = try values.decodeIfPresent(Paginate.self, forKey: .paginate)
        data = try values.decodeIfPresent(T.self, forKey: .data)
    }
    
}

struct Paginate: Codable {
    let currentPage: Int
    let lastPage: Int
    let perPage: Int
    let total: Int
}
