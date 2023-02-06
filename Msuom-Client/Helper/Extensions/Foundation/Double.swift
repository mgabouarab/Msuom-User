//
//  Double.swift
//
//  Created by MGAbouarab®
//

import Foundation

extension Double {
    func toPrice() -> String {
        return String(format: "%.01f", self) + " " + appCurrency
    }
    func toKiloMeter() -> String {
        return String(format: "%.01f", self) + " " + appDistance
    }
    func toString() -> String {
        return String(self)
    }
}


extension Int {
    // isEven: -- self % 2 == 0
    var isEven: Bool { self.isMultiple(of: 2) }
}

