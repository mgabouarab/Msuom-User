//
//  Date.swift
//
//  Created by MGAbouarab®
//

import Foundation

extension Date {
    @available(iOS 13.0, *)
    func toTimeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    func nextHour() -> Date {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = 60 - minute
        return Calendar.current.date(byAdding: components, to: self) ?? Date()
    }
    func toString() -> String {
        return String(describing: self)
    }
    func isBeforeNow() -> Bool {
        return Date() < self
    }
    func isAfterNow() -> Bool {
        return Date() > self
    }
    func apiString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }
    func displayedText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: Language.isRTL() ? "ar" : "en")
        let date = dateFormatter.string(from: self)
        return date
    }
    func short() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: self)
        return dateFormatter.date(from: date)!
    }
}

