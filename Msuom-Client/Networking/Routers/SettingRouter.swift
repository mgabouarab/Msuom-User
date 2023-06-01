//
//  SettingRouter.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 12/12/2022.
//

import Alamofire

enum SettingRouter {
    case terms
    case setting
    case about
    case famousQuestionsAnswer
    case cities
    case policy
    case intro
    case fqs
    case paymentMethods
}

extension SettingRouter: APIRouter {
    var method: HTTPMethod {
        return .get
    }
    var path: String {
        switch self {
            
        case .terms:
            return "terms"
        case .setting:
            return "setting"
        case .about:
            return "about"
        case .famousQuestionsAnswer:
            return "fqs"
        case .cities:
            return "cities"
        case .policy:
            return "policy"
        case .intro:
            return "intros"
        case .fqs:
            return "fqs"
        case .paymentMethods:
            return "paymentMethods"
            
        }
    }
    var parameters: APIParameters? {
        return nil
    }
}
