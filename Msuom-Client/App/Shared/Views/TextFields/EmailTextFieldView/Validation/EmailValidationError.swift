//
//  EmailValidationError.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import Foundation

enum EmailValidationError: Error {
    case empty
    case wrong
}

extension EmailValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Please enter email field.".validationLocalized
        case .wrong:
            return "Please enter correct email address.".validationLocalized
        }
    }
}
