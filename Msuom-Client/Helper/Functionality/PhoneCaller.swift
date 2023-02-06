//
//  PhoneCaller.swift
//
//  Created by MGAbouarab®
//


import UIKit

class PhoneAction: NSObject {
    class func call(number: String?) {
        guard let stringNumber = number, let number = URL(string: "tel://" + stringNumber) else { return }
        UIApplication.shared.open(number)
    }
    class func open(whatsApp: String) {
        /*
         don't forget to add this to info.plist
         
         <key>LSApplicationQueriesSchemes</key>
         <array>
             <string>whatsapp</string>
         </array>
         
         */
        let appURL = URL(string: "https://wa.me/\(whatsApp)")!
        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        
    }
}
