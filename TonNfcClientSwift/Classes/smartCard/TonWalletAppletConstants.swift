/*
* Copyright 2018-2020 TON DEV SOLUTIONS LTD.
*
* Licensed under the SOFTWARE EVALUATION License (the "License"); you may not use
* this file except in compliance with the License.
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific TON DEV software governing permissions and
* limitations under the License.
*/

import Foundation

public class TonWalletAppletConstants {
    public static let APP_INSTALLED: UInt8 = 0x07
    public static let APP_PERSONALIZED: UInt8 =  0x17
    public static let APP_WAITE_AUTHENTICATION_MODE: UInt8 = 0x27
    public static let APP_DELETE_KEY_FROM_KEYCHAIN_MODE: UInt8 = 0x37
    public static let APP_BLOCKED_MODE: UInt8 =  0x47
    
    public static let APPLET_STATES = [ APP_PERSONALIZED : "TonWalletApplet is personalized.",
                                 APP_BLOCKED_MODE : "TonWalletApplet is blocked.",
                                 APP_WAITE_AUTHENTICATION_MODE : "TonWalletApplet waits two-factor authentication.",
                                 APP_DELETE_KEY_FROM_KEYCHAIN_MODE : "TonWalletApplet is personalized and waits finishing key deleting from keychain.",
                                 APP_INSTALLED : "TonWalletApplet is invalid (is not personalized)"  ]
    
    static let ALL_APPLET_STATES = [APP_INSTALLED, APP_PERSONALIZED, APP_WAITE_AUTHENTICATION_MODE, APP_DELETE_KEY_FROM_KEYCHAIN_MODE, APP_BLOCKED_MODE]
    static let INSTALLED_STATE = [APP_INSTALLED]
    static let PERSONALIZED_STATE = [APP_PERSONALIZED]
    static let WAITE_AUTHENTICATION_STATE = [APP_WAITE_AUTHENTICATION_MODE]
    static let PERSONALIZED_AND_DELETE_STATE = [APP_PERSONALIZED, APP_DELETE_KEY_FROM_KEYCHAIN_MODE]
    
    public static let PK_LEN = 0x20
    public static let SIG_LEN = 0x40
    public static let HMAC_SHA_SIG_SIZE = 32
    public static let SHA_HASH_SIZE = 32
    public static let SAULT_LENGTH = 32
    public static let TRANSACTION_HASH_SIZE = 32
    
    public static let MAX_PIN_TRIES_NUM: UInt8 = 10
    public static let DATA_FOR_SIGNING_MAX_SIZE: UInt16 = 189
    public static let APDU_DATA_MAX_SIZE: UInt16 = 255
    public static let DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH: UInt16 = 178
    public static let DATA_PORTION_MAX_SIZE: Int = 128
    
    public static let PASSWORD_SIZE: UInt16 = 128
    public static let IV_SIZE: UInt16 = 16
    public static let MAX_NUMBER_OF_KEYS_IN_KEYCHAIN: UInt16 = 1023
    public static let MAX_KEY_SIZE_IN_KEYCHAIN: UInt16 = 8192
    public static let KEY_CHAIN_SIZE: UInt16 = 32767
    public static let MAX_IND_SIZE: UInt16 = 10
    public static let COMMON_SECRET_SIZE: UInt16 = 32
    public static let MAX_HMAC_FAIL_TRIES: UInt16 = 20
    public static let KEYCHAIN_KEY_INDEX_LEN = 2
    
    public static let DATA_RECOVERY_PORTION_MAX_SIZE: Int = 250
    public static let RECOVERY_DATA_MAX_SIZE: Int = 2048
    
    public static let START_POS_LEN = 2
    public static let KEY_SIZE_BYTES_LEN = 2
    
    public static let SERIAL_NUMBER_SIZE: Int = 24
    
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
    static let GET_HMAC_LE: Int = Int(TonWalletAppletConstants.HMAC_SHA_SIG_SIZE + 2)
    
    public static let DEFAULT_SERIAL_NUMBER: String = "504394802433901126813236"
    
    public static let EMPTY_SERIAL_NUMBER: String = "empty"
    
    public static let DEFAULT_PIN = "5555"
    
}
