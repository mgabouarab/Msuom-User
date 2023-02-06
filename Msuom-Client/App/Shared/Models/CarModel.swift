//
//  CarModel.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/11/2022.
//

import Foundation

struct CarDetails: Codable {
    let id: String
    let type: String?
    let frontSideCar: String?
    let backSideCar: String?
    let rightSideCar: String?
    let leftSideCar: String?
    let insideCar: String?
    let price: Double?
    let currency: String?
    let brandId: String?
    let brandName: String?
    let typeId: String?
    let typeName: String?
    let categoryId: String?
    let categoryName: String?
    let specificationId: String?
    let specificationName: String?
    let importedCarId: String?
    let importedCarName: String?
    let colorId: String?
    let colorName: String?
    let vehicleTypeId: String?
    let vehicleTypeName: String?
    let fuelTypeId: String?
    let fuelTypeName: String?
    let transmissionGearId: String?
    let transmissionGearName: String?
    let statusId: String?
    let statusName: String?
    let sellTypeId: String?
    let sellTypeName: String?
    let cityId: String?
    let cityName: String?
    let year: String?
    let cylinders: String?
    let engineSize: String?
    let walkway: String?
    let km: String?
    let description: String?
    let description_ar: String?
    let description_en: String?
    let isRefundable: Bool?
    let isFinancing: Bool?
    let refundable: String?
    let hasOwner: Bool?
    let owner: String?
    let isFav: Bool?
    let arrImage: [String]?
    
    /*
    "type": "advertise",
    "isRefundable": true,
    "isFinancing": false,
    "owner": "user",
    */

    
    
    
}
struct CarOwner: Codable {
    let id: String?
    let name: String?
    let phoneNo: String?
    let avatar: String?
    let cityName: String?
    let address: String?
    let latitude: String?
    let longitude: String?
}

struct Car: Codable {
    
    //MARK: - properties -
    let details: CarDetails
    let owner: CarOwner
    
    enum CodingKeys: String, CodingKey {
        case details = "car"
        case owner = "user"
    }
    
}

///Extension for cell data
extension Car {
    
    //MARK: - SubStructs -
    struct CellData: CarCellViewData {
        let image: String?
        let name: String?
        let price: String
        let sellType: String
    }
    
    //MARK: - Views Data -
    func cellViewData() -> CellData {
        
        var displayedPrice: String {
            guard let price = self.details.price else {return ""}
            return "Cash price:".localized + " \(price) \(details.currency ?? appCurrency)"
        }
        var displayedSellType: String {
            guard let type = self.details.sellTypeName else {return ""}
            return "How to sell:".localized + " \(type)"
        }
        var displayedName: String {
            let names = [
                details.brandName,
                details.typeName,
                details.year
            ].compactMap({$0})
            return names.joined(separator: " ")
            
        }
        
        return CellData(
            image: self.details.arrImage?.first,
            name: displayedName,
            price: displayedPrice,
            sellType: displayedSellType
        )
        
    }
    
}

///Extension for details data
extension Car {
    
    //MARK: - SubStructs -
    struct Details {
        let images: [String]
        let name: String
        let sellerName: String
        let sellerImage: String
        let sellerAddress: String
        let price: String
        let sellType: String
        let sellTypeDescription: String
        let mark: String
        let type: String
        let incoming: String
        let category: String
        let gearType: String
        let pushType: String
        let cylinderCount: String
        let status: String
        let walked: String
        let city: String
        let year: String
        let fuelType: String
        let engineSize: String
        let color: String
        let hexColor: String
        let specification: String
        let description: String
        let latitude: String
        let longitude: String
        let shareLink: String
        let isMyCar: Bool
        let isFav: Bool
    }
    
    //MARK: - Views Data -
    func detailsData() -> Details {
        
        var displayedImages: [String] {
            guard let image = self.details.arrImage else {
                print("Car with id: \(self.details.id) has no images")
                return []
            }
            return image
        }
        var displayedName: String {
            let names = [
                details.brandName,
                details.typeName,
                details.year
            ].compactMap({$0})
            return names.joined(separator: " ")
            
        }
        var displayedPrice: String {
            guard let price = self.details.price else {
                print("Car with id: \(self.details.id) has no price")
                return ""
            }
            return "\(price)"
        }
        var displayedSellType: String {
            guard let type = self.details.sellTypeName else {
                print("Car with id: \(self.details.id) has no sell type")
                return ""
            }
            return "\(type)"
        }
        var displayedSellTypeDescription: String {
            guard let sellTypeDescription = self.details.refundable else {
                print("Car with id: \(self.details.id) has no sell type description")
                return ""
            }
            return "\(sellTypeDescription)"
        }
        var displayedSellerName: String {
            guard let sellerName = self.owner.name else {
                print("Car with id: \(self.details.id) has no sellerName value")
                return ""
            }
            return sellerName
        }
        var displayedSellerImage: String {
            guard let sellerImage = self.owner.avatar else {
                print("Car with id: \(self.details.id) has no sellerImage value")
                return ""
            }
            return sellerImage
        }
        var displayedSellerAddress: String {
            guard let sellerAddress = self.owner.address else {
                print("Car with id: \(self.details.id) has no sellerAddress value")
                return ""
            }
            return sellerAddress
        }
        var displayedMark: String {
            guard let mark = self.details.brandName else {
                print("Car with id: \(self.details.id) has no mark value")
                return ""
            }
            return mark
        }
        var displayedType: String {
            guard let type = self.details.typeName else {
                print("Car with id: \(self.details.id) has no type value")
                return ""
            }
            return type
        }
        var displayedIncoming: String {
            guard let incoming = self.details.importedCarName else {
                print("Car with id: \(self.details.id) has no incoming value")
                return ""
            }
            return incoming
        }
        var displayedCategory: String {
            guard let category = self.details.categoryName else {
                print("Car with id: \(self.details.id) has no category value")
                return ""
            }
            return category
        }
        var displayedGearType: String {
            guard let category = self.details.transmissionGearName else {
                print("Car with id: \(self.details.id) has no Gear type value")
                return ""
            }
            return category
        }
        var displayedPushType: String {
            guard let category = self.details.vehicleTypeName else {
                print("Car with id: \(self.details.id) has no push type value")
                return ""
            }
            return category
        }
        var displayedCylinderCount: String {
            guard let cylinderCount = self.details.cylinders else {
                print("Car with id: \(self.details.id) has no cylinderCount value")
                return ""
            }
            return cylinderCount
        }
        var displayedStatus: String {
            guard let status = self.details.statusName else {
                print("Car with id: \(self.details.id) has no status value")
                return ""
            }
            return status
        }
        var displayedWalked: String {
            guard let walked = self.details.walkway else {
                print("Car with id: \(self.details.id) has no walked value")
                return ""
            }
            return walked.toKiloMeter()
        }
        var displayedCity: String {
            guard let city = self.details.cityName else {
                print("Car with id: \(self.details.id) has no city value")
                return ""
            }
            return city
        }
        var displayedYear: String {
            guard let year = self.details.year else {
                print("Car with id: \(self.details.id) has no year value")
                return ""
            }
            return year
        }
        var displayedFuelType: String {
            guard let fuelType = self.details.fuelTypeName else {
                print("Car with id: \(self.details.id) has no fuleType value")
                return ""
            }
            return fuelType
        }
        var displayedEngineSize: String {
            guard let engineSize = self.details.engineSize else {
                print("Car with id: \(self.details.id) has no engineSize value")
                return ""
            }
            return engineSize
        }
        var displayedColor: String {
            guard let color = self.details.colorName else {
                print("Car with id: \(self.details.id) has no color value")
                return ""
            }
            return color
        }
        var displayedHexColor: String {
//            guard let hexColor = self.hexColor else {
//                print("Car with id: \(self.details.id) has no hexColor value")
                return "#00000000"
//            }
//            return hexColor
        }
        var displayedSpecification: String {
            guard let specification = self.details.specificationName else {
                print("Car with id: \(self.details.id) has no specification value")
                return ""
            }
            return specification
        }
        var displayedDescription: String {
            guard let description = self.details.description else {
                print("Car with id: \(self.details.id) has no description value")
                return ""
            }
            return description
        }
        var displayedLatitude: String {
            guard let latitude = self.owner.latitude else {
                print("Car with id: \(self.details.id) has no latitude value")
                return ""
            }
            return latitude
        }
        var displayedLongitude: String {
            guard let longitude = self.owner.longitude else {
                print("Car with id: \(self.details.id) has no longitude value")
                return ""
            }
            return longitude
        }
        var displayedShareLink: String {
            return self.details.id
        }
        var displayActions: Bool {
            guard let isMyCar = self.details.hasOwner else {
                print("Car with id: \(self.details.id) has no hasOwner value")
                return false
            }
            return isMyCar
        }
        var isFav: Bool {
            guard let isMyCar = self.details.isFav else {
                print("Car with id: \(self.details.id) has no isFav value")
                return false
            }
            return isMyCar
        }
        return Details(
            images: displayedImages,
            name: displayedName,
            sellerName: displayedSellerName,
            sellerImage: displayedSellerImage,
            sellerAddress: displayedSellerAddress,
            price: displayedPrice,
            sellType: displayedSellType,
            sellTypeDescription: displayedSellTypeDescription,
            mark: displayedMark,
            type: displayedType,
            incoming: displayedIncoming,
            category: displayedCategory,
            gearType: displayedGearType,
            pushType: displayedPushType,
            cylinderCount: displayedCylinderCount,
            status: displayedStatus,
            walked: displayedWalked,
            city: displayedCity,
            year: displayedYear,
            fuelType: displayedFuelType,
            engineSize: displayedEngineSize,
            color: displayedColor,
            hexColor: displayedHexColor,
            specification: displayedSpecification,
            description: displayedDescription,
            latitude: displayedLatitude,
            longitude: displayedLongitude,
            shareLink: displayedShareLink,
            isMyCar: displayActions,
            isFav: isFav
        )
        
    }
    
}

