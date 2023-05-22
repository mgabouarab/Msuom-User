//
//  Constant.swift
//
//  Created by MGAbouarab®
//

import Foundation

//MARK: - Request Enums -
enum Server: String {
    case baseURL = "https://mseomtest.4hoste.com/api/"
    case socketURL = "https://mseomtest.4hoste.com"
    case socketPort = "30040"
}
enum HTTPHeaderKeys {
    static let authentication = "Authorization"
    static let contentType = "Content-Type"
    static let acceptType = "Accept"
    static let acceptEncoding = "Accept-Encoding"
    static let lang = "lang"
}
enum HTTPHeaderValues {
    static let applicationJson = "application/json"
    static let tokenBearer = "Bearer "
}

//MARK: - Response Enums -
enum APIServerResponseKey: String, Codable {
    case success
    case fail
    case unauthenticated = "unauthorized"
    case needActive
    case exception
    case blocked
}
enum UserStatus: String, Codable {
    case unauthenticated
    case pending
    case active
    case empty = ""
}
//MARK: - Errors -
enum APIErrors: String {
    case connectionError
    case canNotDecodeData
}

enum DeviceTypes {
    static let IOS = "ios"
}
