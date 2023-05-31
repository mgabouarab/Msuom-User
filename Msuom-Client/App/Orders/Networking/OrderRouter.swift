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
    case afterSaleServiceDetails(page: Int)
    case detailsOrder(id: String)
    case acceptRejectOffer(id: String, status: String)
    case payOrder(id: String, paymentMethod: String, price: String)
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
        case .afterSaleServiceDetails:
            return .get
        case .detailsOrder:
            return .get
        case .acceptRejectOffer:
            return .put
        case .payOrder:
            return .put
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
        case .afterSaleServiceDetails:
            return "orders"
        case .detailsOrder:
            return "detailsOrder"
        case .acceptRejectOffer:
            return "acceptRejectOffer"
        case .payOrder:
            return "payOrder"
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
        case .afterSaleServiceDetails(let page):
            return [
                "type": "afterSaleService",
                "limit": listLimit,
                "page": page
            ]
        case .detailsOrder(let id):
            return [
                "id": id
            ]
        case .acceptRejectOffer(let id, let status):
            return [
                "id": id,
                "orderStatus": status
            ]
        case .payOrder(let id, let paymentMethod, let price):
            return [
                "id": id,
                "paymentMethod": paymentMethod,
                "price": price
            ]
        }
    }
    
}
