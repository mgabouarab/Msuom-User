//
//  UserModel.swift
//
//  Created by MGAbouarab®
//

import Foundation

struct User: Codable {
    
    let id: String
    let name: String
    let rating: Double
    let email: String?
    let userType: String
    let status: String
    let activationCode: String
    let active: Bool
    let phoneNo: String
//    let countryKey: String
    let avatar: String
    let notifyCount: Int
    let balance: Double
    let language: String
    let isNotify: Bool
    let birthday: String
    let cityId: String
    let cityName: String
    let createAt: String
    let token: String
    let canRateCar: Bool?
    let canRefundableCar: Bool?
    var permissions: [String]?
    let providerId: String?
    
}
