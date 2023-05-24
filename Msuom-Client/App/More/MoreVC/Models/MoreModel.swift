//
//  MoreModel.swift
//  Msuom
//
//  Created by MGAbouarab on 28/10/2022.
//

import UIKit

struct MoreModel {
    let title: String?
    let items: [MoreItem]
    var headerHeight: CGFloat {
        title == nil ? 1 : 40
    }
}

struct MoreItem {
    let iconName: String
    let title: String
    let description: String?
    let enableArrow: Bool = false
    let action: (()->())?
    var color: UIColor = Theme.colors.whiteColor
    var hasArrow: Bool = true
}
