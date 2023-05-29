//
//  AuctionModel.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/11/2022.
//

import Foundation

struct Auction: Codable {
    
    //MARK: - properties -
    let id: String
    private let adNumber: Int?
    private let startDate: String?
    
    
    private let currency: String?
    private let endDate: String?
    private let endTime: String?
    private let hasSell: Bool?
    private let image: String?
    private let name: String?
    private let startPrice: String?
    private let startTime: String?
    private let type: String?
    private let isRunning: Bool?
    
}

extension Auction {
    
    //MARK: - SubStructs -
    struct CellData {
        let title: String
        let startDate: String
    }
    
    //MARK: - Views Data -
    func cellViewData() -> CellData {
        
        var displayedTitle: String {
            guard let number = self.adNumber else {return ""}
            return "Auction Number".localized + " (\(number))"
        }
        var displayedStartTime: String {
            guard let startDate = self.startDate else {return ""}
            return "Start at".localized + " \(startDate)"
        }
        
        return CellData(
            title: displayedTitle,
            startDate: displayedStartTime
        )
        
    }
    
}


extension Auction {
    
    //MARK: - SubStructs -
    struct HomeSoonAuction {
        let id: String
        let image: String
        let name: String
        let startPrice: String
        let fullStartDate: String
        let fullEndDate: String
        let isLive: Bool
        let isStart: Bool
    }
    
    //MARK: - Views Data -
    func homeComingSoonCellData() -> HomeSoonAuction {
        
        var displayedImage: String {
            guard let image = self.image else {
                print("The Auction with id: \(self.id) has no image")
                return ""
            }
            return image
        }
        var displayedName: String {
            guard let name = self.name else {
                print("The Auction with id: \(self.id) has no name")
                return ""
            }
            return name
        }
        var displayedStartPrice: String {
            guard let startPrice = self.startPrice else {
                print("The Auction with id: \(self.id) has no startPrice")
                return ""
            }
            return startPrice
        }
        var displayedFullDate: String {
            guard let startDate = self.startDate else {
                print("The Auction with id: \(self.id) has no startDate")
                return ""
            }
            guard let startTime = self.startTime else {
                print("The Auction with id: \(self.id) has no startTime")
                return ""
            }
            return "\(startDate) \(startTime)"
        }
        var displayedFullEndDate: String {
            guard let endDate = self.endDate else {
                print("The Auction with id: \(self.id) has no endDate")
                return ""
            }
            guard let endTime = self.endTime else {
                print("The Auction with id: \(self.id) has no endTime")
                return ""
            }
            return "\(endDate) \(endTime)"
        }
        
        var isLive: Bool {
            guard let type = self.type, type == "live" else {
                return false
            }
            return true
        }
        var isStart: Bool {
            guard self.isRunning == true else {
                return false
            }
            return true
        }
        
        return  HomeSoonAuction(
            id: self.id,
            image: displayedImage,
            name: displayedName,
            startPrice: displayedStartPrice,
            fullStartDate: displayedFullDate,
            fullEndDate: displayedFullEndDate,
            isLive: isLive,
            isStart: isStart
        )
        
    }
    
    
}



extension Auction {
    static let auctions: [Auction] = []
}

enum Numerical: Codable {
    
    case double(Double), string(String)
    
    init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(value)
            return
        }
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(value)
            return
        }
        throw NumericalError.missingValue
    }
    
    enum NumericalError:Error {
        case missingValue
    }
}
extension Numerical {
    
    var doubleValue: Double? {
        switch self {
        case .double(let value): return value
        case .string(let value): return Double(value)
        }
    }
    var stringValue: String? {
        switch self {
        case .string(let value): return value
        case .double(let value): return String(Int(value))
        }
    }
    
}
