//
//  CarValidationError.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 04/12/2022.
//

import Foundation

enum CarValidationError: Error {
    
    case emptyImages
    case emptyPrice
    case emptyBrand
    case emptyType
    case emptyClass
    case emptyYear
    case emptySpecifications
    case emptyIncoming
    case emptyColor
    case emptyDrive
    case emptyFuel
    case emptyAsphalt
    case emptyStatus
    case emptyCylinders
    case emptyEngine
    case emptyHowToSell
    case emptyWalkway
    case emptyCity
    case emptyDescription
    
}
extension CarValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyImages:
            return "Select all images".localized
        case .emptyPrice:
            return "Please enter the purchase price".localized
        case .emptyBrand:
            return "Choose the brand".localized
        case .emptyType:
            return "Choose the type of vehicle".localized
        case .emptyClass:
            return "Choose the vehicle class".localized
        case .emptyYear:
            return "Choose the year".localized
        case .emptySpecifications:
            return "Choose specifications".localized
        case .emptyIncoming:
            return "Choose incoming".localized
        case .emptyColor:
            return "Choose the color".localized
        case .emptyDrive:
            return "Choose the type of vehicle drive".localized
        case .emptyFuel:
            return "Choose the type of vehicle drive".localized
        case .emptyAsphalt:
            return "Choose the type of asphalt".localized
        case .emptyStatus:
            return "Choose status".localized
        case .emptyCylinders:
            return "Enter the number of cylinders".localized
        case .emptyEngine:
            return "Choose the engine size".localized
        case .emptyHowToSell:
            return "Choose how to sell".localized
        case .emptyWalkway:
            return "Enter the walkway".localized
        case .emptyCity:
            return "Choose the city".localized
        case .emptyDescription:
            return "Enter Vehicle description".localized
        }
    }
}
