//
//  PhoneNumberTextFieldView+Localization.swift
//  Msuom
//
//  Created by MGAbouarab on 22/10/2022.
//

import Foundation

extension String {
    var phoneNumberLocalizable: String {
        return NSLocalizedString(self, tableName: "PhoneNumberLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
}
