//
//  Utilities.swift
//
//  Created by MGAbouarab®
//


import UIKit

var deviceId: String { UserDefaults.pushNotificationToken ?? "no device id for firebase for this device and this is an ios device" }

let uuid = UIDevice.current.identifierForVendor?.uuidString ?? String()

let defaultLat = "23.8859"
let defaultLong = "45.0792"
let userType = "user"//"delegate"
