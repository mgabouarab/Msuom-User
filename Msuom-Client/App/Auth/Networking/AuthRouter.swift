//
//  AuthRouter.swift
//
//  Created by MGAbouarab®.
//

import Alamofire

enum AuthRouter {
    case login(credential: String, password: String, countryKey: String?)
    case registerWith(name: String, phone: String, email: String, password: String, countryKey: String?, cityId: String, birthday: String?)
    case verify(code: String, credential: String, countryKey: String?)
    case forgetPassword(credential: String, countryKey: String)
    case forgetPasswordCode(_ code: String, credential: String, countryKey: String?)
    case resetPassword(code: String, credential: String, password: String, countryKey: String?)
    case codeResend(credential: String, countryKey: String?)
    case contactUs(name: String, phone: String, message: String, countryKey: String)
    case signOut
    case deleteAccount
    case profile
    case updatePassword(password: String, oldPassword: String)
    case updateProfile(name: String?, phone: String?, email: String?, countryCode: String?, cityId: String?, birthday: String?)
}

extension AuthRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
            
        case .login:
            return .post
            
        case .registerWith:
            return .post
            
        case .verify:
            return .post
            
        case .forgetPassword:
            return .post
            
        case .forgetPasswordCode:
            return .post
            
        case .resetPassword:
            return .post
            
        case .codeResend:
            return .patch
            
        case .contactUs:
            return .post
            
        case .signOut:
            return .delete
            
        case .deleteAccount:
            return .delete
            
        case .profile:
            return .get
            
        case .updatePassword:
            return .post
            
        case .updateProfile:
            return .patch
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "sign-in"
        case .registerWith:
            return "user-sign-up"
        case .verify:
            return "activate"
        case .forgetPassword:
            return "forget-password"
        case .forgetPasswordCode:
            return "checkForgetCode"
        case .resetPassword:
            return "reset-password"
        case .codeResend:
            return "resend-code"
        case .contactUs:
            return "contactus"
        case .signOut:
            return "sign-out"
        case .deleteAccount:
            return "delete-account"
        case .profile:
            return "profile"
        case .updatePassword:
            return "update-passward"
        case .updateProfile:
            return "update-profile"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
            
            
        case .login(let credential, let password, let countryKey):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.loginKey.rawValue: credential,
                AuthParameterKeys.password.rawValue: password,
                AuthParameterKeys.userType.rawValue: userType,
                AuthParameterKeys.deviceId.rawValue: deviceId,
                AuthParameterKeys.deviceType.rawValue: DeviceTypes.IOS
            ]
            
        case .registerWith(let name, let phone, let email, let password, let countryKey, let cityId, let birthday):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.phone.rawValue: phone,
                AuthParameterKeys.name.rawValue: name,
                AuthParameterKeys.email.rawValue: email,
                AuthParameterKeys.password.rawValue: password,
                AuthParameterKeys.cityId.rawValue: cityId,
                AuthParameterKeys.birthday.rawValue: birthday,
                AuthParameterKeys.userType.rawValue: userType,
                AuthParameterKeys.deviceId.rawValue: deviceId,
                AuthParameterKeys.deviceType.rawValue: DeviceTypes.IOS
            ]
            
        case .verify(let code, let credential, let countryKey):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.code.rawValue: code,
                AuthParameterKeys.loginKey.rawValue: credential,
                AuthParameterKeys.userType.rawValue: userType,
                AuthParameterKeys.deviceId.rawValue: deviceId,
                AuthParameterKeys.deviceType.rawValue: DeviceTypes.IOS
            ]
            
            
        case .forgetPassword(let credential, let countryKey):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.phone.rawValue: credential,
                AuthParameterKeys.userType.rawValue: userType
            ]
            
            
        case .forgetPasswordCode(let code, let credential, let countryKey):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.code.rawValue: code,
                AuthParameterKeys.phone.rawValue: credential,
                AuthParameterKeys.userType.rawValue: userType
            ]
            
            
        case .resetPassword(let code, let credential, let password, let countryKey):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.code.rawValue: code,
                AuthParameterKeys.phone.rawValue: credential,
                AuthParameterKeys.password.rawValue: password,
                AuthParameterKeys.passwordConfirmation.rawValue: password,
                AuthParameterKeys.userType.rawValue: userType
            ]
            
        case .codeResend(let credential, let countryKey):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.phone.rawValue: credential,
                AuthParameterKeys.userType.rawValue: userType
            ]
        case .contactUs(let name, let phone, let message, let countryKey):
            return [
                AuthParameterKeys.countryKey.rawValue: countryKey,
                AuthParameterKeys.phone.rawValue: phone,
                AuthParameterKeys.message.rawValue: message,
                AuthParameterKeys.userType.rawValue: userType,
                AuthParameterKeys.name.rawValue: name
            ]
        case .signOut:
            return [
                AuthParameterKeys.deviceId.rawValue: deviceId,
                AuthParameterKeys.deviceType.rawValue: DeviceTypes.IOS
            ]
        case .deleteAccount:
            return [
                AuthParameterKeys.deviceId.rawValue: deviceId,
                AuthParameterKeys.deviceType.rawValue: DeviceTypes.IOS
            ]
        case .profile:
            return nil
        case .updatePassword(let password, let oldPassword):
            return [
                AuthParameterKeys.password.rawValue: password,
                AuthParameterKeys.oldPassword.rawValue: oldPassword
            ]
        case .updateProfile(let name, let phone, let email, let countryCode, let cityId, let birthday):
            return [
                AuthParameterKeys.name.rawValue: name,
                AuthParameterKeys.phone.rawValue: phone,
                AuthParameterKeys.email.rawValue: email,
                AuthParameterKeys.countryKey.rawValue: countryCode,
                AuthParameterKeys.cityId.rawValue: cityId,
                AuthParameterKeys.birthday.rawValue: birthday,
            ]
        }
    }
    
}
