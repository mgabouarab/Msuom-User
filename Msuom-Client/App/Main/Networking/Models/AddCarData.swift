//
//  AddCarData.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 12/12/2022.
//

import Foundation

struct AddCarData: Codable {
    var carBrands: [CarBrandModel]
    var colors: [IdName]
    var carCategories: [IdName]
    var importedCars: [IdName]
    var specifications: [IdName]
    var fuelTypes: [IdName]
    var vehicleTypes: [IdName]
    var transmissionGears: [IdName]
    var carStatus: [IdName]
    var sellTypes: [IdName]
    var cities: [IdName]
}

struct CarBrandModel: Codable, DropDownItem {
    let id: String
    let name: String
    let carTypes: [IdName]
}

struct IdName: Codable, DropDownItem {
    let id: String
    let name: String
}
