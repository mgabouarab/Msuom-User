//
//  CarValidationService.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 04/12/2022.
//

import Foundation

struct CarValidationService {
    static func validate(price: String?) throws -> String {
        guard let price, !price.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyPrice
        }
        return price
    }
    static func validate(startPrice price: String?) throws -> String {
        guard let price, !price.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyStartAuctionPrice
        }
        return price
    }
    
    static func validate(startDate: Date?) throws -> String {
        guard let startDate else {
            throw CarValidationError.emptyAuctionStartDate
        }
        return startDate.apiDateString()
    }
    static func validate(startTime: Date?) throws -> String {
        guard let startTime else {
            throw CarValidationError.emptyAuctionStartTime
        }
        return startTime.apiTimeString()
    }
    
    static func validate(endDate: Date?) throws -> String {
        guard let endDate else {
            throw CarValidationError.emptyAuctionEndDate
        }
        return endDate.apiDateString()
    }
    static func validate(endTime: Date?) throws -> String {
        guard let endTime else {
            throw CarValidationError.emptyAuctionEndTime
        }
        return endTime.apiTimeString()
    }
    static func validate(brandId: String?) throws -> String {
        guard let brandId, !brandId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyBrand
        }
        return brandId
    }
    static func validate(typeId: String?) throws -> String {
        guard let typeId, !typeId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyType
        }
        return typeId
    }
    static func validate(classId: String?) throws -> String {
        guard let classId, !classId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyClass
        }
        return classId
    }
    static func validate(year: String?) throws -> String {
        guard let year, !year.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyYear
        }
        return year
    }
    static func validate(specificationsId: String?) throws -> String {
        guard let specificationsId, !specificationsId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptySpecifications
        }
        return specificationsId
    }
    static func validate(incomingId: String?) throws -> String {
        guard let incomingId, !incomingId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyIncoming
        }
        return incomingId
    }
    static func validate(colorId: String?) throws -> String {
        guard let colorId, !colorId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyColor
        }
        return colorId
    }
    static func validate(driveId: String?) throws -> String {
        guard let driveId, !driveId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyDrive
        }
        return driveId
    }
    static func validate(fuelId: String?) throws -> String {
        guard let fuelId, !fuelId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyFuel
        }
        return fuelId
    }
    static func validate(asphaltId: String?) throws -> String {
        guard let asphaltId, !asphaltId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyAsphalt
        }
        return asphaltId
    }
    static func validate(statusId: String?) throws -> String {
        guard let statusId, !statusId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyStatus
        }
        return statusId
    }
    static func validate(cylinders: String?) throws -> String {
        guard let cylinders, !cylinders.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyCylinders
        }
        return cylinders
    }
    static func validate(engineId: String?) throws -> String {
        guard let engineId, !engineId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyEngine
        }
        return engineId
    }
    static func validate(howToSellId: String?) throws -> String {
        guard let howToSellId, !howToSellId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyHowToSell
        }
        return howToSellId
    }
    static func validate(walkway: String?) throws -> String {
        guard let walkway, !walkway.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyWalkway
        }
        return walkway
    }
    static func validate(cityId: String?) throws -> String {
        guard let cityId, !cityId.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyCity
        }
        return cityId
    }
    static func validate(description: String?) throws -> String {
        guard let description, !description.trimWhiteSpace().isEmpty else {
            throw CarValidationError.emptyDescription
        }
        return description
    }
}
