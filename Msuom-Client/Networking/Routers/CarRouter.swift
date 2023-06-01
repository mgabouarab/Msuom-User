//
//  CarRouter.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 12/12/2022.
//

import Alamofire

enum CarRouter {
    case addCarData
    case addCar(
        price: String,
        brandId: String,
        typeId: String,
        classId: String,
        year: String,
        specificationsId: String,
        incomingId: String,
        colorId: String,
        driveId: String,
        fuelId: String,
        asphaltId: String,
        statusId: String,
        cylinders: String,
        engineId: String,
        howToSellId: String,
        walkway: String,
        cityId: String,
        description: String,
        descriptionAr: String,
        type: String,
        isRefundable: Bool
    )
    case editCar(
        id: String,
        price: String?,
        brandId: String?,
        typeId: String?,
        classId: String?,
        year: String?,
        specificationsId: String?,
        incomingId: String?,
        colorId: String?,
        driveId: String?,
        fuelId: String?,
        asphaltId: String?,
        statusId: String?,
        cylinders: String?,
        engineId: String?,
        howToSellId: String?,
        walkway: String?,
        cityId: String?,
        description: String?,
        descriptionAr: String?,
        type: String?,
        isRefundable: Bool?
    )
    case carDetails(id: String)
    case deleteCar(id: String)
    case toggleAdFav(id: String)
    case toggleAuctionFav(id: String, streamId: String)
    case haraj(brandId: String?, page: Int)
    case harajFilter(brandId: String?, typeId: String?, cityId: String?, statusId: String?)
    case offers(page: Int, type: String)
    case offerFilter(brandId: String?, providerId: String?, page: Int)
    case offerDetails(id: String)
    case providers(page: Int)
    case providerFilter(name: String?, brandId: String?, cityId: String?, page: Int)
    case providerDetails(id: String, page: Int)
    case purchaseOrders(
        carId: String,
        providerId: String,
        isDelivery: Bool,
        latitude: Double?,
        longitude: Double?,
        address: String?,
        paymentMethod: String,
        price: String
    )
}

extension CarRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .addCarData:
            return .get
        case .addCar:
            return .post
        case .editCar:
            return .post
        case .carDetails:
            return .get
        case .deleteCar:
            return .delete
        case .toggleAdFav, .toggleAuctionFav:
            return .post
        case .haraj:
            return .get
        case .harajFilter:
            return .get
        case .offers:
            return .get
        case .offerFilter:
            return .get
        case .offerDetails:
            return .get
        case .providers:
            return .get
        case .providerFilter:
            return .get
        case .providerDetails:
            return .get
        case .purchaseOrders:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .addCarData:
            return "dataUsedForConfirmCar"
        case .addCar:
            return "addCar"
        case .editCar:
            return "editCar"
        case .carDetails:
            return "detailsCar"
        case .deleteCar:
            return "deleteCar"
        case .toggleAdFav, .toggleAuctionFav:
            return "fav_unFav"
        case .haraj:
            return "haraj"
        case .harajFilter:
            return "haraj"
        case .offers:
            return "offers"
        case .offerFilter:
            return "offerFilter"
        case .offerDetails:
            return "offerDetails"
        case .providers:
            return "providerFilter"
        case .providerFilter:
            return "providerFilter"
        case .providerDetails:
            return "providerDetails"
        case .purchaseOrders:
            return "purchaseOrders"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
        case .addCarData:
            return nil
        case .addCar(
            let price,
            let brandId,
            let typeId,
            let classId,
            let year,
            let specificationsId,
            let incomingId,
            let colorId,
            let driveId,
            let fuelId,
            let asphaltId,
            let statusId,
            let cylinders,
            let engineId,
            let howToSellId,
            let walkway,
            let cityId,
            let description,
            let descriptionAr,
            let type,
            let isRefundable
        ):
            return [
                "price": price,
                "brandId": brandId,
                "typeId": typeId,
                "categoryId": classId,
                "year": year,
                "specificationId": specificationsId,
                "importedCarId": incomingId,
                "colorId": colorId,
                "vehicleTypeId": driveId,
                "fuelTypeId": fuelId,
                "transmissionGearId": asphaltId,
                "statusId": statusId,
                "cylinders": cylinders,
                "engineSize": engineId,
                "sellTypeId": howToSellId,
                "walkway": walkway,
                "cityId": cityId,
                "description.ar": descriptionAr,
                "description.en": description,
                "type": type,
                "isRefundable": isRefundable
            ]
        case .editCar(
            let id,
            let price,
            let brandId,
            let typeId,
            let classId,
            let year,
            let specificationsId,
            let incomingId,
            let colorId,
            let driveId,
            let fuelId,
            let asphaltId,
            let statusId,
            let cylinders,
            let engineId,
            let howToSellId,
            let walkway,
            let cityId,
            let description,
            let descriptionAr,
            let type,
            let isRefundable
        ):
            return [
                "id": id,
                "price": price,
                "brandId": brandId,
                "typeId": typeId,
                "categoryId": classId,
                "year": year,
                "specificationId": specificationsId,
                "importedCarId": incomingId,
                "colorId": colorId,
                "vehicleTypeId": driveId,
                "fuelTypeId": fuelId,
                "transmissionGearId": asphaltId,
                "statusId": statusId,
                "cylinders": cylinders,
                "engineSize": engineId,
                "sellTypeId": howToSellId,
                "walkway": walkway,
                "cityId": cityId,
                "description.ar": descriptionAr,
                "description.en": description,
                "type": type,
                "isRefundable": isRefundable
            ]
        case .carDetails(let id):
            return [
                "id": id
            ]
        case .deleteCar(let id):
            return [
                "id": id
            ]
        case .toggleAdFav(let id):
            return [
                "type": "advertise",
                "carId": id
            ]
        case .toggleAuctionFav(let id, let streamId):
            return [
                "type": "bid",
                "bidId": id,
                "streamId": streamId
            ]
        case .haraj(let brandId, let page):
            return [
                "brandId": brandId,
                "page": page,
                "limit": listLimit
            ]
        case .harajFilter(let brandId, let typeId, let cityId, let statusId):
            return [
                "brandId": brandId,
                "typeId": typeId,
                "cityId": cityId,
                "statusId": statusId
            ]
        case .offers(let page, let type):
            return [
                "type": type,
                "page": page,
                "limit": listLimit
            ]
        case .offerFilter(let brandId, let providerId, let page):
            return [
                "brandId": brandId,
                "providerId": providerId,
                "page": page,
                "limit": listLimit
            ]
        case .offerDetails(let id):
            return [
                "id": id
            ]
        case .providers(let page):
            return [
                "page": page,
                "limit": listLimit
            ]
        case .providerFilter(let name, let brandId, let cityId, let page):
            return [
                "name": name,
                "brandId": brandId,
                "cityId": cityId,
                "page": page
            ]
        case .providerDetails(let id, let page):
            return [
                "id": id,
                "page": page,
                "limit": listLimit
            ]
        case .purchaseOrders(
            let carId,
            let providerId,
            let isDelivery,
            let latitude,
            let longitude,
            let address,
            let paymentMethod,
            let price
        ):
            return [
                "carId": carId,
                "providerId": providerId,
                "isDelivery": isDelivery,
                "latitude": latitude,
                "longitude": longitude,
                "address": address,
                "paymentMethod": paymentMethod,
                "price": price
            ]
            
        }
    }
    
}
