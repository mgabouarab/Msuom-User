//
//  CountryProtocols.swift
//  Msuom
//
//  Created by MGAbouarab on 23/10/2022.
//

import Foundation

protocol CountryCodeItem {
    var id: Int? {get}
    var name: String {get}
    var flag: String? {get}
    var emoji: String? {get}
    var countryCode: String? {get}
}
protocol CountryCodeDelegate {
    func didSelectCountry(_ item: CountryCodeItem)
}
