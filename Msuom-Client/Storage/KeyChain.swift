//
//  KeyChain.swift
//  
//
//  Created by MGAbouarab on 01/02/2023.
//

import Foundation
import Security

class KeyChain {
    fileprivate class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data] as [String: Any]
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }

    fileprivate class func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne] as [String: Any]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

    fileprivate class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
        let swiftString: String = cfStr as String
        return swiftString
    }
}

extension Data {
    init(from value: String) {
        let value = value
        let myData = value.data(using: .utf8)!
        self.init(myData)
    }

    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

@propertyWrapper
struct KeyChainData {
    typealias Value = String

    let key: String
    let defaultValue: Value
    var wrappedValue: Value {
        get {
            guard let data = KeyChain.load(key: key) else { return defaultValue }
            let result = data.toString()
            return result ?? ""
        }
        set {
            let status = KeyChain.save(key: key, data: Data(from: newValue))
            print("The status of saving the value of \(key) is: \(status)")
        }
    }
}

extension KeyChain {
    private enum Keys: String {
        case pikrosePhoneLoginKey
        case pikroseLoginPassword
    }

    @KeyChainData(key: Keys.pikrosePhoneLoginKey.rawValue, defaultValue: "")
    static var userLoginKey: String
    @KeyChainData(key: Keys.pikroseLoginPassword.rawValue, defaultValue: "")
    static var userLoginPassword: String
}
