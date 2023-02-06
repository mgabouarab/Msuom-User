//
//  Extensions+UICollectionView.swift
//
//  Created by MGAbouarab®
//

import UIKit

extension UICollectionViewFlowLayout {
    
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return Language.isRTL() ? true : false
    }
    
}
