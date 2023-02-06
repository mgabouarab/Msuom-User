//
//  EmailNumberTextFieldView+Localization.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import Foundation

extension String {
    var emailLocalizable: String {
        return NSLocalizedString(self, tableName: "EmailLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
}
