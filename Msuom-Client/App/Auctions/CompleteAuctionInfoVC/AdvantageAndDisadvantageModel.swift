//
//  AdvantageAndDisadvantageModel.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 13/05/2023.
//

import Foundation

struct AdvantageAndDisadvantageModel {
    var arabicName: String?
    var englishName: String?
    var arabicDescription: String?
    var englishDescription: String?
    
    var isValid: Bool {
        guard
            let arabicName,
            let englishName,
            let arabicDescription,
            let englishDescription,
            !arabicName.trimWhiteSpace().isEmpty,
            !englishName.trimWhiteSpace().isEmpty,
            !arabicDescription.trimWhiteSpace().isEmpty,
            !englishDescription.trimWhiteSpace().isEmpty
        else {return false}
        return true
    }
    
}
