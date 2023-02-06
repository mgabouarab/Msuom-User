//
//  PasswordValidationError.swift
//  Msuom
//
//  Created by MGAbouarab on 24/10/2022.
//

import Foundation

enum PasswordValidationError: Error {
    case emptyPassword
    case shortPassword
    case emptyNewPassword
    case shortNewPassword
    case emptyOldPassword
    case shortOldPassword
    case emptyConfirmNewPassword
    case emptyConfirmPassword
    case notMatchPasswords
}

extension PasswordValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyPassword:
            return "Please enter password field.".passwordLocalizable
        case .shortPassword:
            return "Password is too short, it should be 6 characters at least.".passwordLocalizable
        case .emptyNewPassword:
            return "Please enter new password field.".passwordLocalizable
        case .shortNewPassword:
            return "New password is too short, it should be 6 characters at least.".passwordLocalizable
        case .emptyOldPassword:
            return "Please enter old password field.".passwordLocalizable
        case .shortOldPassword:
            return "Old password is too short, it should be 6 characters at least.".passwordLocalizable
        case .emptyConfirmNewPassword:
            return "Please enter confirm new password field.".passwordLocalizable
        case .emptyConfirmPassword:
            return "Please enter confirm password field.".passwordLocalizable
        case .notMatchPasswords:
            return "Passwords not match.".passwordLocalizable
        }
    }
}
