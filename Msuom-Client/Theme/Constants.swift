//
//  Constants.swift
//
//  Created by MGAbouarab®
//

import UIKit

final class ViewConstants {
    
    static let shared: ViewConstants = ViewConstants()
    
    private init() {}
    
    let smallCornerRadius: CGFloat = 8
    let mediumCornerRadius: CGFloat = 16
    let largeCornerRadius: CGFloat = 24
    
    let smallAnimationTime: CGFloat = 0.2
    let mediumAnimationTime: CGFloat = 0.5
    let largeAnimationTime: CGFloat = 1
    
}

enum SFSymbol: String {
    case eyeFill = "eye.fill"
    case eyeSlashFill = "eye.slash.fill"
    case starFill = "star.fill"
    case starLeadingHalfFilled = "star.leadinghalf.filled"
    case star = "star"
}
