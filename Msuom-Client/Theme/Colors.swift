//
//  Colors.swift
//
//  Created by MGAbouarab®
//


import UIKit

final class AppColors {
    
    static let shared: AppColors = AppColors()
    
    private init() {}
    
    private func createColor(named: ColorNames) -> UIColor {
        guard let color = UIColor(named: named.rawValue) else {
            fatalError("No color found in assetes with the name \(named.rawValue) please add the color with this name to it")
        }
        return color
    }
    
    //MARK: - Names -
    private enum ColorNames: String {
        case mainDarkFontColor
        case secondaryDarkFontColor
        case mainLightFontColor
        case secondaryLightFontColor
        
        case errorColor
        case successColor
        case warningColor
        
        case mainColor
        case mainWithAlph
        case secondaryColor
        case secondaryColorWithAlph
        
        case mainBackgroundColor
        case secondaryBackgroundColor
        case separatorColor
        
        case whiteColor
        case blackColor
        
        case shadowColor
        case borderColor
        
    }
    
    //MARK: - Font -
    var mainDarkFontColor: UIColor {
        return createColor(named: .mainDarkFontColor)
    }
    var secondryDarkFontColor: UIColor  {
        return createColor(named: .secondaryDarkFontColor)
    }
    var mainLightFontColor: UIColor {
        return createColor(named: .mainLightFontColor)
    }
    var secondryLightFontColor: UIColor  {
        return createColor(named: .secondaryLightFontColor)
    }
    
    //MARK: - Alerts -
    var errorColor: UIColor {
        return createColor(named: .errorColor)
    }
    var successColor: UIColor {
        return createColor(named: .successColor)
    }
    var warningColor: UIColor {
        return createColor(named: .warningColor)
    }
    
    //MARK: - Views -
    var whiteColor: UIColor {
        return createColor(named: .whiteColor)
    }
    var blackColor: UIColor {
        return createColor(named: .blackColor)
    }
    
    var mainColor: UIColor {
        return createColor(named: .mainColor)
    }
    var mainWithAlph: UIColor {
        return createColor(named: .mainWithAlph)
    }
    var secondaryColor: UIColor {
        return createColor(named: .secondaryColor)
    }
    var secondaryColorWithAlph: UIColor {
        return createColor(named: .secondaryColorWithAlph)
    }
    
    var mainBackgroundColor: UIColor {
        return createColor(named: .mainBackgroundColor)
    }
    var secondaryBackgroundColor: UIColor {
        return createColor(named: .secondaryBackgroundColor)
    }
    var separatorColor: UIColor {
        return createColor(named: .separatorColor)
    }
    
    //MARK: - Layers -
    var shadowColor: CGColor {
        return createColor(named: .shadowColor).cgColor
    }
    var borderColor: CGColor {
        return createColor(named: .borderColor).cgColor
    }
    
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor+"FF")
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
