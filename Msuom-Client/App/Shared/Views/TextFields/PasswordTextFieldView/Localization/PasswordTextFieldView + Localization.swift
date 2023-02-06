//
//  PasswordTextFieldView + Localization.swift
//  Msuom
//
//  Created by MGAbouarab on 24/10/2022.
//

import Foundation

extension String {
    var passwordLocalizable: String {
        return NSLocalizedString(self, tableName: "PasswordLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
}
