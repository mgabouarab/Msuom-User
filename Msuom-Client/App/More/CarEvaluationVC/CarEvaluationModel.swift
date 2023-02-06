//
//  CarEvaluationModel.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/01/2023.
//

import Foundation

struct CarEvaluationModel: Codable {
    let carPreview: String?
    let shippingServices: String?
    let phoneNoWhats: String?
    let phoneNo: String?
    let email: String?
}

struct CarEvaluationResultModel: Codable {
    let carsLike: [MyCarsModel]?
    let result: CarEvaluationResult?
}

struct CarEvaluationResult: Codable {
    let brandName: String
    let categoryName: String
    let id: String
    let noteCarEvaluation: String
    let price: String
    let statusName: String
    let typeName: String
    let walkway: String
}

