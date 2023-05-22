//
//  OrderDetailsModels.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 05/02/2023.
//

import Foundation

struct ShippingOrderDetails: Codable {
    let brandName: String?
    let currency: String?
    let deliveryPrice: Double?
    let description: String?
    let id: String
    let image: String?
    let orderNo: Int?
    let orderStatus: String?
    let paymentMethod: String?
    let price: Double?
    let type: String?
    let typeName: String?
    let year: String?
    let orderStatusTxt: String?
}

struct EvaluationOrderDetails: Codable {
    let attach: String?
    let brandName: String?
    let categoryName: String?
    let currency: String?
    let id: String
    let notes: String?
    let orderNo: Int?
    let orderStatus: String?
    let paymentMethod: String?
    let price: Double?
    let statusName: String?
    let type: String?
    let typeName: String?
    let walkway: String?
    let orderStatusTxt: String?
}

struct PurchaseOrderDetails: Codable {
    
    let brandName: String?
    let carId: String?
    let currency: String?
    let deliveryPrice: Double?
    let id: String
    let image: String?
    let isDelivery: Bool?
    let isFinancing: String?
    let orderNo: Int?
    let orderStatus: String?
    let paymentMethod: String?
    let price: Double?
    let priceText: String?
    let receiptMethod: String?
    let type: String?
    let typeName: String?
    let year: String?
    let orderStatusTxt: String?
    
    
    
}

struct SummaryReportDetails: Codable {
    
    let attach: String?
    let brandName: String?
    let currency: String?
    let description: String?
    let id: String
    let image: String?
    let orderNo: Int?
    let orderStatus: String?
    let paymentMethod: String?
    let price: Double?
    let type: String?
    let typeName: String?
    let year: String?
    let orderStatusTxt: String?
    
    
}
