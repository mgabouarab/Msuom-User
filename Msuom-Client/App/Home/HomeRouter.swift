//
//  HomeRouter.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 09/02/2023.
//

import Alamofire

enum HomeRouter {
    case home
    case browseByBrand(id: String)
    case browseByCategory(id: String)
    case notifications(page: Int)
    case search(keyword: String)
    case notifyCount
}

extension HomeRouter: APIRouter {
    var method: HTTPMethod {
        switch self {
        case .home: return .get
        case .browseByBrand: return .get
        case .browseByCategory: return .get
        case .notifications: return .get
        case .search: return .get
        case .notifyCount: return .get
        }
    }
    
    var path: String {
        switch self {
        case .home: return "home"
        case .browseByBrand: return "browse"
        case .browseByCategory: return "browse"
        case .notifications: return "notifications"
        case .search: return "search"
        case .notifyCount: return "notifyCount"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
        case .home: return nil
        case .browseByBrand(let brandId): return ["brandId":brandId]
        case .browseByCategory(let structureId): return ["structureId":structureId]
        case .notifications(let page): return ["page": page, "limit": listLimit]
        case .search(let keyword): return ["keyword": keyword]
        case .notifyCount: return nil
        }
    }
}
