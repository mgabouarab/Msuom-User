//
//  MoreRouter.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/01/2023.
//

import Alamofire

enum MoreRouter {
    case wallet
    case advertises(page: Int)
    case favs(type: String)
    case dataUsedForEvaluation
    case carEvaluation(brandId: String, typeId: String, categoryId: String, statusId: String, walkway: String, type: String, address: String, isDelivery: Bool, year: String)
    case chargeWallet(price: String)
    case setting
}

extension MoreRouter: APIRouter {
    var method: HTTPMethod {
        switch self {
        case .wallet: return .get
        case .advertises: return .get
        case .favs: return .get
        case .dataUsedForEvaluation: return .get
        case .carEvaluation: return .post
        case .chargeWallet: return .patch
        case .setting: return .get
        }
    }
    
    var path: String {
        switch self {
        case .wallet: return "wallet"
        case .advertises: return "advertises"
        case .favs: return "favs"
        case .dataUsedForEvaluation: return "dataUsedForEvaluation"
        case .carEvaluation: return "carEvaluation"
        case .chargeWallet: return "chargeWallet"
        case .setting: return "setting"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
        case .wallet: return nil
        case .advertises(let page): return ["page": page, "limit": listLimit]
        case .favs(let type): return ["type": type]
        case .dataUsedForEvaluation: return nil
        case .carEvaluation(let brandId, let typeId, let categoryId, let statusId, let walkway, let type, let address, let isDelivery, let year):
            return [
                "brandId": brandId,
                "typeId": typeId,
                "categoryId": categoryId,
                "statusId": statusId,
                "walkway": walkway,
                "type": type,
                "address": address,
                "isDelivery": isDelivery,
                "year": year
            ]
        case .chargeWallet(let price):
            return [
                "price": price
            ]
        case .setting:
            return nil
        }
    }
}

