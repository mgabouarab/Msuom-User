//
//  PhoneValidationService.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import Foundation

struct PhoneValidationService {
    static func validate(phone: String?) throws -> String {
        guard let phone = phone, !phone.trimWhiteSpace().isEmpty else {
            throw PhoneValidationErrors.emptyPhone
        }
        guard phone.isValidPhoneNumber(pattern: RegularExpression.saudiArabiaPhone.value) else {
            throw PhoneValidationErrors.inValidPhone
        }
        return phone
    }
    static func validate(countryCode: String?) throws -> String {
        guard let countryCode = countryCode, !countryCode.trimWhiteSpace().isEmpty else {
            throw PhoneValidationErrors.emptyCountryCode
        }
        return countryCode
    }
}
