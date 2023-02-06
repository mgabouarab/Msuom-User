//
//  EmailValidationService.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import Foundation

struct EmailValidationService {
    
    static func validate(email: String?) throws -> String {
        guard let email = email, !email.trimWhiteSpace().isEmpty else {
            throw EmailValidationError.empty
        }
        guard email.isValidEmail() else{
            throw EmailValidationError.wrong
        }
        return email
    }
    
}
