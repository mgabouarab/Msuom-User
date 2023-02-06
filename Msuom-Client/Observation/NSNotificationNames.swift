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
    }
    
    
    /*
     All Notification cases
     */
    static let isLoginChanged = Notification.Name(rawValue: Names.isLoginChanged.rawValue)
    
    
}
