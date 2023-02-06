//
//  PasswordValidationService.swift
//  Msuom
//
//  Created by MGAbouarab on 24/10/2022.
//

import Foundation

struct PasswordValidationService {
    
    //MARK: - Passwords -
    static func validate(password: String?) throws -> String {
        guard let password = password, !password.isEmpty else {
            throw PasswordValidationError.emptyPassword
        }
        guard password.count > 5 else {
            throw PasswordValidationError.shortPassword
        }
        return password
    }
    static func validate(newPassword: String?) throws -> String {
        guard let newPassword = newPassword, !newPassword.isEmpty else {
            throw PasswordValidationError.emptyNewPassword
        }
        guard newPassword.count > 5 else {
            throw PasswordValidationError.shortNewPassword
        }
        return newPassword
    }
    static func validate(oldPassword: String?) throws -> String {
        guard let oldPassword = oldPassword, !oldPassword.isEmpty else {
            throw PasswordValidationError.emptyOldPassword
        }
        guard oldPassword.count > 5 else {
            throw PasswordValidationError.shortOldPassword
        }
        return oldPassword
    }
    static func validate(newPassword: String, confirmNewPassword: String?) throws -> String {
        guard let confirmNewPassword = confirmNewPassword, !confirmNewPassword.isEmpty else {
            throw PasswordValidationError.emptyConfirmNewPassword
        }
        guard newPassword == confirmNewPassword else {
            throw PasswordValidationError.notMatchPasswords
        }
        return newPassword
    }
    static func validate(newPassword: String, confirmPassword: String?) throws -> String {
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            throw PasswordValidationError.emptyConfirmPassword
        }
        guard newPassword == confirmPassword else {
            throw PasswordValidationError.notMatchPasswords
        }
        return newPassword
    }
    
}
