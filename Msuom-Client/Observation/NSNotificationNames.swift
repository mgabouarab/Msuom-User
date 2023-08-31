//
//  NSNotificationNames.swift
//
//  Created by MGAbouarab®
//

import Foundation

extension NSNotification.Name {
    
    /*
     Enum for Holding all strings keys as rawValues to avoid using Strings
     */
    private enum Names: String {
        case isLoginChanged
        case notificationNumberChanged
        case didEnterBackground
    }
    
    
    /*
     All Notification cases
     */
    static let isLoginChanged = Notification.Name(rawValue: Names.isLoginChanged.rawValue)
    static let notificationNumberChanged = Notification.Name(rawValue: Names.notificationNumberChanged.rawValue)
    static let didEnterBackground = Notification.Name(rawValue: Names.didEnterBackground.rawValue)
    
    
}
