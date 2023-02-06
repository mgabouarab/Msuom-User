//
//  ProfileRouter.swift
//  Msuom
//
//  Created by MGAbouarab on 03/11/2022.
//

import Alamofire

enum ProfileRouter {
    case wallet
    case showProfile
    case updateProfile(name: String?, email: String?, phone: String?, countryKey: String?)
    case updatePassword(oldPassword: String, password: String, passwordConfirmation: String)
    case updateAvailability
    case changedPhoneActivation(code: String)
}

extension ProfileRouter: APIRouter {
    var method: HTTPMethod {
        switch self {
            
        case .wallet:
            return .get
        case .showProfile:
            return .get
        case .updateProfile:
            return .post
        case .updatePassword:
            return .post
        case .updateAvailability:
            return .post
        case .changedPhoneActivation:
            return .post
        }
    }
    var path: String {
        switch self {
        case .wallet:
            return "wallet"
        case .showProfile:
            return "profile/show"
        case .updateProfile:
            return "profile/update"
        case .updatePassword:
            return "profile/update-password"
        case .updateAvailability:
            return "profile/update-availability"
        case .changedPhoneActivation:
            return "profile/changed-phone-activation"
        }
    }
    var parameters: APIParameters? {
        switch self {
        case .wallet:
            return nil
        case .showProfile:
            return nil
        case .updateProfile(let name, let email, let phone, let countryKey):
            return [
                "name": name,
                "email": email,
                "phone": phone,
                "country_key": countryKey
            ]
        case .updatePassword(let oldPassword, let password, let passwordConfirmation):
            return [
                "old_password": oldPassword,
                "password": password,
                "password_confirmation": passwordConfirmation
            ]
        case .updateAvailability:
            fatalError()
        case .changedPhoneActivation(let code):
            return [
                "code": code
            ]
        }
    }
}

