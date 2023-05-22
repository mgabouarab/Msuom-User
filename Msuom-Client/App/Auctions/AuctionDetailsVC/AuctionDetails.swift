//
//  AuctionDetails.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 14/05/2023.
//

import Foundation

struct AuctionDetails: Codable {
    
    let bidPrice : Numerical?
    let cities : [Cities]
    let currentBid : BidDetails?
    let nextBids : [BidDetails]?
    let provider : Provider?
    let stream : BidStream?
    let terms : String?
    
}

struct BidDetails: Codable {
    let adNumber : Numerical?
    let advantages : [Advantages]?
    let arrImage : [String]?
    let autoBid : Bool?
    let backSideCar : String?
    let brandName : String?
    let categoryName : String?
    let checkReport : String?
    let cityName : String?
    let colorName : String?
    let countBids : Numerical?
    let createAt : String?
    let currency : String?
    let cylinders : String?
    let endDate : String?
    let endedAt : String?
    let endTime : String?
    let engineSize : String?
    let frontSideCar : String?
    let fuelTypeName : String?
    let hasSecurityDeposit : Bool?
    let hasSell : Bool?
    let hasSubscription : Bool?
    let id : String?
    let image : String?
    let importedCarName : String?
    let insideCar : String?
    let isFav : Bool?
    let isFinished : String?
    let isRefundable : Bool?
    let isRunning : Bool?
    let isTrySell : Bool?
    let km : String?
    let lastBidPrice : Numerical?
    let leftSideCar : String?
    let name : String?
    let qrcode : String?
    let rating : String?
    let refundable : String?
    let rightSideCar : String?
    let sellTypeName : String?
    let showDecisionToSell : Bool?
    let soldProgress : String?
    let specificationName : String?
    let startDate : String?
    let startPrice : Numerical?
    let startTime : String?
    let statusName : String?
    let transmissionGearName : String?
    let type : String?
    let typeName : String?
    let vehicleTypeName : String?
    let walkway : String?
    let year : String?
}

extension BidDetails {
    
    //MARK: - SubStructs -
    struct HomeSoonAuction {
        let image: String
        let name: String
        let startPrice: String
        let fullStartDate: String
        let fullEndDate: String
        let isLive: Bool
    }
    
    //MARK: - Views Data -
    func homeComingSoonCellData() -> HomeSoonAuction {
        
        var displayedImage: String {
            guard let image = self.image else {
                print("The Auction with id: \(self.id ?? "0") has no image")
                return ""
            }
            return image
        }
        var displayedName: String {
            guard let name = self.name else {
                print("The Auction with id: \(self.id ?? "0") has no name")
                return ""
            }
            return name
        }
        var displayedStartPrice: String {
            guard let startPrice = self.startPrice?.stringValue else {
                print("The Auction with id: \(self.id ?? "0") has no startPrice")
                return ""
            }
            return startPrice
        }
        var displayedFullDate: String {
            guard let startDate = self.startDate else {
                print("The Auction with id: \(self.id ?? "0") has no startDate")
                return ""
            }
            guard let startTime = self.startTime else {
                print("The Auction with id: \(self.id ?? "0") has no startTime")
                return ""
            }
            return "\(startDate) \(startTime)"
        }
        var displayedFullEndDate: String {
            guard let endDate = self.endDate else {
                print("The Auction with id: \(self.id ?? "0") has no endDate")
                return ""
            }
            guard let endTime = self.endTime else {
                print("The Auction with id: \(self.id ?? "0") has no endTime")
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
        
        return  HomeSoonAuction(
            image: displayedImage,
            name: displayedName,
            startPrice: displayedStartPrice,
            fullStartDate: displayedFullDate,
            fullEndDate: displayedFullEndDate,
            isLive: isLive
        )
        
    }
    
    
}


struct Advantages : Codable {
    let description : String?
    let title : String?
    var isSelected: Bool?
}

struct Cities : Codable {
    let address : String?
    let id : String?
    let latitude : Numerical?
    let longitude : Numerical?
    let name : String?
}

struct Provider : Codable {
    let address : String?
    let bio : String?
    let carCount : String?
    let cityName : String?
    let id : String?
    let image : String?
    let latitude : String?
    let longitude : String?
    let name : String?
    let phoneNo : String?
    let star : Bool?
}

struct BidStream: Codable {
    let createAt : String?
    let credentials : Credentials?
    let duration : String?
    let endDate : String?
    let endedAt : String?
    let endTime : String?
    let id : String?
    let isFinished : String?
    let isOwner : Bool?
    let isRunning : Bool?
    let name : String?
    let providerId : String?
    let startDate : String?
    let startedAt : String?
    let startTime : String?
    let status : String?
    let type : String?
}

struct Credentials : Codable {
    let apiKey : String?
    let sessionId : String?
    let token : String?
}
