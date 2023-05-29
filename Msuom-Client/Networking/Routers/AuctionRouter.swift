//
//  AuctionRouter.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 14/05/2023.
//

import Alamofire

enum AuctionRouter {
    case bid(
        price: String?,
        brandId: String,
        typeId: String,
        categoryId: String,
        year: String,
        specificationId: String,
        importedCarId: String,
        colorId: String,
        vehicleTypeId: String,
        fuelTypeId: String,
        transmissionGearId: String,
        statusId: String,
        cylinders: String,
        engineSize: String,
        sellTypeId: String,
        walkway: String,
        cityId: String,
        isRefundable: Bool,
        type: String,
        rating: String,
        advantages: String,
        startDate: String?,
        endDate: String?,
        startTime: String?,
        endTime: String?,
        limitPrice: String?
    )
    case bidDetailsFromHome(id: String)
    case bidDetails(id: String)
    case customersBid(bidId: String, page: Int)
    case commentsStream(streamId: String, page: Int)
    case add(bidId: String, comment: String, rate: Int, streamId: String)
    case edit(comment: String, rate: Int, commentId: String)
    case delete(commentId: String)
    case summaryReport(bidId: String, providerId: String)
    case commentsLiveStream(streamId: String, bidId: String, page: Int)
    case subscription(streamId: String, bidId: String)
    case sellCar(streamId: String, bidId: String)
    case checkAutoBid(bidId: String, maxPrice: String)
    case subscribeWinnerBids(type: String)
    case afterSaleServices(bidId: String)
    case afterSaleServiceOrder(bidId: String, latitude: Double, longitude: Double, address: String, serviceId: String)
    case shippingOrders(bidId: String, latitude: Double?, longitude: Double?, address: String?, isDelivery: Bool)
    
    case dispute(bidId: String, questionId: String?, description: String)
    case disputeQuestions
    case disputesUser
    case disputeDetails(disputeId: String)
    case listOfComingOrCurrentBids(type: String, cityId: String?)
    case showAllProviders(type: String)
    case providerStreams(type: String, providerId: String)
    case filterStreams(streamIds: String)
}

extension AuctionRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .bid: return .post
        case .bidDetailsFromHome: return .get
        case .bidDetails: return .get
        case .customersBid: return .get
        case .commentsStream: return .get
        case .add: return .post
        case .edit: return .patch
        case .delete: return .delete
        case .summaryReport: return .post
        case .commentsLiveStream: return .get
        case .subscription: return .patch
        case .sellCar: return .patch
        case .checkAutoBid: return .put
        case .subscribeWinnerBids: return .get
        case .afterSaleServices: return .get
        case .afterSaleServiceOrder: return .post
        case .shippingOrders: return .post
        case .dispute: return .post
        case .disputeQuestions: return .get
        case .disputeDetails: return .get
        case .disputesUser: return .get
        case .listOfComingOrCurrentBids: return .get
        case .showAllProviders: return .get
        case .providerStreams: return .get
        case .filterStreams: return .get
        }
    }
    
    var path: String {
        switch self {
        case .bid: return "bid"
        case .bidDetailsFromHome: return "details"
        case .bidDetails: return "nextBidDetails"
        case .customersBid: return "customersBid"
        case .commentsStream: return "commentsStream"
        case .add: return "comment"
        case .edit: return "comment"
        case .delete: return "comment"
        case .summaryReport: return "summaryReport"
        case .commentsLiveStream: return "commentsLiveStream"
        case .subscription: return "subscription"
        case .sellCar: return "sell-car"
        case .checkAutoBid: return "checkAutoBid"
        case .subscribeWinnerBids: return "subscribe-winner-bids"
        case .afterSaleServices: return "afterSaleServices"
        case .afterSaleServiceOrder: return "afterSaleServiceOrder"
        case .shippingOrders: return "shippingOrders"
        case .dispute: return "dispute"
        case .disputeQuestions: return "dispute-questions"
        case .disputeDetails: return "dispute-details"
        case .disputesUser: return "disputes-user"
        case .listOfComingOrCurrentBids: return "listOfComingOrCurrentBids"
        case .showAllProviders: return "showAllProviders"
        case .providerStreams: return "providerStreams"
        case .filterStreams: return "filterStreams"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
            
        case .bid(price: let price, brandId: let brandId, typeId: let typeId, categoryId: let categoryId, year: let year, specificationId: let specificationId, importedCarId: let importedCarId, colorId: let colorId, vehicleTypeId: let vehicleTypeId, fuelTypeId: let fuelTypeId, transmissionGearId: let transmissionGearId, statusId: let statusId, cylinders: let cylinders, engineSize: let engineSize, sellTypeId: let sellTypeId, walkway: let walkway, cityId: let cityId, isRefundable: let isRefundable, type: let type, rating: let rating, advantages: let advantages, startDate: let startDate, endDate: let endDate, startTime: let startTime, endTime: let endTime, limitPrice: let limitPrice):
            
            return [
                "startPrice": price,
                "brandId": brandId,
                "typeId": typeId,
                "categoryId": categoryId,
                "year": year,
                "specificationId": specificationId,
                "importedCarId": importedCarId,
                "colorId": colorId,
                "vehicleTypeId": vehicleTypeId,
                "fuelTypeId": fuelTypeId,
                "transmissionGearId": transmissionGearId,
                "statusId": statusId,
                "cylinders": cylinders,
                "engineSize": engineSize,
                "sellTypeId": sellTypeId,
                "walkway": walkway,
                "cityId": cityId,
                "isRefundable": isRefundable,
                "type": type,
                "rating": rating,
                "advantages": advantages,
                "startDate": startDate,
                "endDate": endDate,
                "startTime": startTime,
                "endTime": endTime,
                "limitPrice": limitPrice
            ]
            
            
        case .bidDetailsFromHome(let id):
            return [
                "streamId": id
            ]
            
        case .bidDetails(let id):
            return [
                "bidId": id
            ]
            
        case .customersBid(let bidId, let page):
            return [
                "bidId": bidId,
                "page": page,
                "limit": listLimit
            ]
            
        case .commentsStream(let streamId, let page):
            return [
                "streamId": streamId,
                "page": page,
                "limit": listLimit
            ]
        case .add(let bidId, let comment, let rate, let streamId):
            return [
                "bidId": bidId,
                "streamId": streamId,
                "comment": comment,
                "rating": rate
            ]
        case .edit(let comment, let rate, let commentId):
            return [
                "comment": comment,
                "rating": rate,
                "commentId": commentId
            ]
        case .delete(let commentId):
            return [
                "commentId": commentId
            ]
        case .summaryReport(let bidId, let providerId):
            return [
                "bidId": bidId,
                "providerId": providerId
            ]
        case .commentsLiveStream(let streamId, let bidId, let page):
            return [
                "streamId": streamId,
                "bidId": bidId,
                "page": page,
                "limit": listLimit
            ]
            
        case .subscription(let streamId, let bidId):
            return [
                "bidId": bidId,
                "streamId": streamId
            ]
        case .sellCar(let streamId, let bidId):
            return [
                "bidId": bidId,
                "streamId": streamId
            ]
        case .checkAutoBid(let bidId, let maxPrice):
            return [
                "bidId": bidId,
                "maxPrice": maxPrice
            ]
        case .subscribeWinnerBids(let type):
            return [
                "type": type
            ]
        case .afterSaleServices(let bidId):
            return [
                "bidId": bidId
            ]
        case .afterSaleServiceOrder(let bidId, let latitude, let longitude, let address, let serviceId):
            return [
                "bidId": bidId,
                "latitude": latitude,
                "longitude": longitude,
                "address": address,
                "serviceId": serviceId
            ]
        case .shippingOrders(let bidId, let latitude, let longitude, let address, let isDelivery):
            return [
                "bidId": bidId,
                "latitude": latitude,
                "longitude": longitude,
                "address": address,
                "isDelivery": isDelivery
            ]
        case .dispute(let bidId, let questionId, let description):
            return [
                "bidId": bidId,
                "questionId": questionId,
                "description": description
            ]
        case .disputeQuestions:
            return nil
        case .disputesUser:
            return nil
        case .disputeDetails(let disputeId):
            return [
                "disputeId": disputeId
            ]
        case .listOfComingOrCurrentBids(let type, let cityId):
            return [
                "type": type,
                "cityId": cityId
            ]
        case .showAllProviders(let type):
            return [
                "type": type
            ]
        case .providerStreams(let type, let providerId):
            return [
                "type": type,
                "providerId": providerId
            ]
        case .filterStreams(let streamIds):
            return [
                "streamIds": streamIds
            ]
        }
    }
    
    
}
