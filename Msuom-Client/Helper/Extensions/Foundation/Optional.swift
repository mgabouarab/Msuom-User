//
//  Optional.swift
//
//  Created by MGAbouarab®
//

import Foundation

extension Optional where Wrapped == Bool {
    mutating func toggleOptional() {
        guard let value = self else {
            self = true
            return
        }
        self = !value
    }
}
