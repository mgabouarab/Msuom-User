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
    private let number: String?
    private let startDate: String?
    
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
            guard let number = self.number else {return ""}
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
    static let auctions = [
        Auction(
            id: "",
            number: "123456",
            startDate: "22 Dec 2022 11:00 PM"
        ),
        Auction(
            id: "",
            number: "76543",
            startDate: "27 Dec 2022 06:00 PM"
        ),
        Auction(
            id: "",
            number: "98765",
            startDate: "31 Dec 2022 03:00 PM"
        ),
    ]
}
