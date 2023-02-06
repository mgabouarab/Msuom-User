//
//  OrderRouter.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 05/02/2023.
//

import Alamofire

enum OrderRouter {
    case shippingOrderDetails(page: Int)
    case evaluationOrderDetails(page: Int)
    case purchaseOrderDetails(page: Int)
    case summaryReportDetails(page: Int)
}

extension OrderRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
            
        case .shippingOrderDetails:
            return .get
        case .evaluationOrderDetails:
            return .get
        case .purchaseOrderDetails:
            return .get
        case .summaryReportDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
            
        case .shippingOrderDetails:
            return "orders"
        case .evaluationOrderDetails:
            return "orders"
        case .purchaseOrderDetails:
            return "orders"
        case .summaryReportDetails:
            return "orders"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
            
        case .shippingOrderDetails(let page):
            return [
                "type": "shipping",
                "limit": listLimit,
                "page": page
            ]
        case .evaluationOrderDetails(let page):
            return [
                "type": "evaluation",
                "limit": listLimit,
                "page": page
            ]
        case .purchaseOrderDetails(let page):
            return [
                "type": "purchaseOrder",
                "limit": listLimit,
                "page": page
            ]
        case .summaryReportDetails(let page):
            return [
                "type": "summaryReport",
                "limit": listLimit,
                "page": page
            ]
        }
    }
    
}
