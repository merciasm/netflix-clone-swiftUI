//
//  KeychainHelper.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation

enum KeychainKeys: String {
    case authToken
    case user
}

enum KeychainStatus: Int32 {
    case success = 0
    case unknownError
}

final class KeychainHelper {

    static func save(data: Data, forKey key: KeychainKeys) -> KeychainStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
            ] as [String: Any]
        SecItemDelete(query as CFDictionary)
        let value = SecItemAdd(query as CFDictionary, nil)
        return KeychainStatus(rawValue: value) ?? .unknownError
    }

    static func loadData(forKey key: KeychainKeys) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue ,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
            ] as [String: Any]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == noErr else { return nil }
        return dataTypeRef as? Data
    }

    static func clearKeychain() {
        let secItemClasses = [kSecClassGenericPassword,
                              kSecClassInternetPassword,
                              kSecClassCertificate,
                              kSecClassKey,
                              kSecClassIdentity
        ]
        secItemClasses.forEach {
            let dictionary = [kSecClass as String: $0]
            SecItemDelete(dictionary as CFDictionary)
        }
    }
}
