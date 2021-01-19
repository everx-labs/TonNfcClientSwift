//
//  DictionaryHelper.swift
//  react-native-new-ton-nfc-card-lib
//
//  Created by Alina Alinovna on 11.01.2021.
//

import Foundation

class KeychainQueryHelper {
    static let HMAC_ACCOUNT : String = "hmac_key_alias_"
    static let HMAC_LABEL : String = "ton_nfc"
    static let HMAC_SERVICE : String = /*Bundle.main.bundleIdentifier ??*/ HMAC_LABEL
    
    static var keychainQueryHelper : KeychainQueryHelper?
    
    static func getInstance() -> KeychainQueryHelper {
        if (keychainQueryHelper == nil) {
            keychainQueryHelper = KeychainQueryHelper()
        }
        return keychainQueryHelper!
    }
    
    func createBasicQuery(serialNumber : String) -> [String : AnyObject] {
        var dict = [String : AnyObject]()
        let account = KeychainQueryHelper.HMAC_ACCOUNT + serialNumber
        dict[kSecClass as String] = kSecClassGenericPassword
        dict[kSecAttrAccount as String] = account as CFString
        dict[kSecAttrService as String] = KeychainQueryHelper.HMAC_SERVICE as CFString
        return dict
    }
    
    func createQueryToAddKey(serialNumber : String, keyForHmac : Data) -> [String : AnyObject] {
        var dict = createBasicQuery(serialNumber : serialNumber)
        //dict[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        dict[kSecValueData as String] = keyForHmac as CFData
        dict[kSecReturnAttributes as String] = kCFBooleanTrue
        dict[kSecAttrLabel as String] = KeychainQueryHelper.HMAC_LABEL as CFString
        return dict
    }
    
    func createQueryToGetKey(serialNumber : String) -> [String : AnyObject] {
        var dict = createBasicQuery(serialNumber : serialNumber)
        dict[kSecReturnData as String] = kCFBooleanTrue
        dict[kSecMatchLimit as String] = kSecMatchLimitOne
        return dict
    }
    
    func createQueryToCheckKeyExist(serialNumber : String) -> [String : AnyObject] {
        var dict = createBasicQuery(serialNumber : serialNumber)
        dict[kSecReturnData as String] = kCFBooleanFalse
        dict[kSecReturnAttributes as String] = kCFBooleanTrue
        dict[kSecMatchLimit as String] = kSecMatchLimitOne
        return dict
    }

    func createDictionaryToGetAllKeysFromKeychain() -> [String : AnyObject] {
        var dict = [String : AnyObject]()
        dict[kSecClass as String] = kSecClassGenericPassword
        dict[kSecAttrService as String] = KeychainQueryHelper.HMAC_SERVICE as CFString
        dict[kSecAttrLabel as String] = KeychainQueryHelper.HMAC_LABEL as CFString
        dict[kSecReturnData as String] = kCFBooleanFalse
        dict[kSecReturnAttributes as String] = kCFBooleanTrue
        dict[kSecMatchLimit as String] = kSecMatchLimitAll
        return dict
    }

}
