//
//  onWalletAppletConstants.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 02.09.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

class TonWalletAppletConstants {
    static let APP_INSTALLED: UInt8 = 0x07
    static let APP_PERSONALIZED: UInt8 =  0x17
    static let APP_WAITE_AUTHORIZATION_MODE: UInt8 = 0x27
    static let APP_DELETE_KEY_FROM_KEYCHAIN_MODE: UInt8 = 0x37
    static let APP_BLOCKED_MODE: UInt8 =  0x47
    
    static let APPLET_STATES = [ APP_PERSONALIZED : "TonWalletApplet is personalized.",
                                 APP_BLOCKED_MODE : "TonWalletApplet is blocked.",
                                 APP_WAITE_AUTHORIZATION_MODE : "TonWalletApplet waits two-factor authorization.",
                                 APP_DELETE_KEY_FROM_KEYCHAIN_MODE : "TonWalletApplet is personalized and waits finishing key deleting from keychain.",
                                 APP_INSTALLED : "TonWalletApplet is invalid (is not personalized)"  ]
    
    static let ALL_APPLET_STATES = [APP_INSTALLED, APP_PERSONALIZED, APP_WAITE_AUTHORIZATION_MODE, APP_DELETE_KEY_FROM_KEYCHAIN_MODE, APP_BLOCKED_MODE]
    static let INSTALLED_STATE = [APP_INSTALLED]
    static let PERSONALIZED_STATE = [APP_PERSONALIZED]
    static let WAITE_AUTHORIZATION_STATE = [APP_WAITE_AUTHORIZATION_MODE]
    static let PERSONALIZED_AND_DELETE_STATE = [APP_PERSONALIZED, APP_DELETE_KEY_FROM_KEYCHAIN_MODE]
    
    static let DEFAULT_PIN:[UInt8] = [0x35, 0x35, 0x35, 0x35]
    
    static let PK_LEN = 0x20
    static let SIG_LEN = 0x40
    static let HMAC_SHA_SIG_SIZE = 32
    static let SHA_HASH_SIZE = 32
    static let SAULT_LENGTH = 32
    static let TRANSACTION_HASH_SIZE = 32
    static let PIN_SIZE = 4
    
    static let MAX_PIN_TRIES_NUM: UInt8 = 10
    static let DATA_FOR_SIGNING_MAX_SIZE: UInt16 = 189
    static let APDU_DATA_MAX_SIZE: UInt16 = 255
    static let DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH: UInt16 = 178
    static let DATA_PORTION_MAX_SIZE: Int = 128
    
    static let PASSWORD_SIZE: UInt16 = 128
    static let IV_SIZE: UInt16 = 16
    static let MAX_NUMBER_OF_KEYS_IN_KEYCHAIN: UInt16 = 1023
    static let MAX_KEY_SIZE_IN_KEYCHAIN: UInt16 = 8192
    static let KEY_CHAIN_SIZE: UInt16 = 32767
    static let MAX_IND_SIZE: UInt16 = 10
    static let COMMON_SECRET_SIZE: UInt16 = 32
    static let MAX_HMAC_FAIL_TRIES: UInt16 = 20
    static let KEYCHAIN_KEY_INDEX_LEN = 2
    
    static let DATA_RECOVERY_PORTION_MAX_SIZE: Int = 250
    static let RECOVERY_DATA_MAX_SIZE: Int = 2048
    
    static let SERIAL_NUMBER_SIZE: Int = 24
    
    static let GET_RECOVERY_DATA_LEN_LE: Int = 0x02
    static let GET_APP_INFO_LE: Int = 0x01
    static let IS_RECOVERY_DATA_SET_LE: Int = 0x01
    static let GET_NUMBER_OF_KEYS_LE: Int = 0x02
    static let GET_KEY_INDEX_IN_STORAGE_AND_LEN_LE: Int = 0x04
    static let INITIATE_DELETE_KEY_LE: Int = 0x02
    static let GET_FREE_SIZE_LE: Int = 0x02
    static let GET_OCCUPIED_SIZE_LE: Int = 0x02
    static let SEND_CHUNK_LE: Int = 0x02
    static let DELETE_KEY_CHUNK_LE: Int = 0x01
    static let DELETE_KEY_RECORD_LE: Int = 0x01
    static let GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_LE: Int = 0x02
    static let GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_LE: Int = 0x02
    static let GET_SERIAL_NUMBER_LE: Int = 0x18
    
    static let DEFAULT_SERIAL_NUMBER: String = "504394802433901126813236"
    
    static let EMPTY_SERIAL_NUMBER: String = "empty"
    
}
