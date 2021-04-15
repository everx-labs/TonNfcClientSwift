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
import CoreNFC

@available(iOS 13.0, *)
class TonWalletAppletApduCommands {
    static let hmacHelper = HmacHelper.getInstance()
    
    static let WALLET_APPLET_CLA:UInt8 = 0xB0
    /****************************************
     * Instruction codes *
     ****************************************
     */
    //Personalization
    static let INS_FINISH_PERS:UInt8 = 0x90;
    static let INS_SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION:UInt8 = 0x91
    static let INS_SET_ENCRYPTED_COMMON_SECRET:UInt8 = 0x94
    static let INS_SET_SERIAL_NUMBER:UInt8 = 0x96
    
    //Waite for authentication mode
    static let INS_VERIFY_PASSWORD:UInt8 = 0x92
    static let INS_GET_HASH_OF_ENCRYPTED_PASSWORD:UInt8 = 0x93
    static let INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET:UInt8 = 0x95
    
    // Main mode
    static let INS_GET_PUBLIC_KEY:UInt8 = 0xA0
    static let INS_GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH:UInt8 = 0xA7
    static let INS_VERIFY_PIN:UInt8 = 0xA2
    static let INS_SIGN_SHORT_MESSAGE:UInt8 = 0xA3
    static let INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH:UInt8 = 0xA5
    
    static let INS_CHECK_KEY_HMAC_CONSISTENCY:UInt8 = 0xB0
    static let INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN:UInt8 = 0xB1
    static let INS_GET_KEY_CHUNK:UInt8 = 0xB2
    static let INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY:UInt8 = 0xB3
    static let INS_ADD_KEY_CHUNK:UInt8 = 0xB4
    static let INS_INITIATE_CHANGE_OF_KEY:UInt8 = 0xB5
    static let INS_CHANGE_KEY_CHUNK:UInt8 = 0xB6
    static let INS_INITIATE_DELETE_KEY:UInt8 = 0xB7
    
    static let INS_GET_NUMBER_OF_KEYS:UInt8 = 0xB8
    static let INS_GET_FREE_STORAGE_SIZE:UInt8 = 0xB9
    static let INS_GET_OCCUPIED_STORAGE_SIZE:UInt8 = 0xBA
    static let INS_GET_HMAC:UInt8 = 0xBB
    static let INS_RESET_KEYCHAIN:UInt8 = 0xBC
    
    static let INS_DELETE_KEY_CHUNK:UInt8 = 0xBE
    static let INS_DELETE_KEY_RECORD:UInt8 = 0xBF
    static let INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS:UInt8 = 0xE1
    static let INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS:UInt8 = 0xE2
    
    static let INS_GET_SAULT:UInt8 = 0xBD
    static let INS_GET_APP_INFO:UInt8 = 0xC1
    static let INS_GET_SERIAL_NUMBER:UInt8 = 0xC2
    
    static let INS_ADD_RECOVERY_DATA_PART:UInt8 = 0xD1
    static let INS_GET_RECOVERY_DATA_PART:UInt8 = 0xD2
    static let INS_GET_RECOVERY_DATA_HASH:UInt8 = 0xD3
    static let INS_GET_RECOVERY_DATA_LEN:UInt8 = 0xD4
    static let INS_RESET_RECOVERY_DATA:UInt8 = 0xD5
    static let INS_IS_RECOVERY_DATA_SET:UInt8 = 0xD6
    
    
    
    static let APDU_COMMAND_NAMES = [CommonConstants.INS_SELECT: "SELECT_TON_APPLET",
                                     INS_FINISH_PERS : "FINISH_PERS",
                                     INS_SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION : "SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION",
                                     INS_SET_SERIAL_NUMBER : "SET_SERIAL_NUMBER",
                                     INS_SET_ENCRYPTED_COMMON_SECRET : "SET_ENCRYPTED_COMMON_SECRET",
                                     INS_VERIFY_PASSWORD : "VERIFY_PASSWORD",
                                     INS_GET_HASH_OF_ENCRYPTED_PASSWORD :  "GET_HASH_OF_ENCRYPTED_PASSWORD",
                                     INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET : "GET_HASH_OF_ENCRYPTED_COMMON_SECRET",
                                     INS_VERIFY_PIN : "VERIFY_PIN",
                                     INS_GET_PUBLIC_KEY : "GET_PUBLIC_KEY",
                                     INS_GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH : "GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH",
                                     INS_SIGN_SHORT_MESSAGE: "SIGN_SHORT_MESSAGE",
                                     INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH : "SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH",
                                     INS_GET_APP_INFO: "GET_APP_INFO",
                                     INS_GET_SERIAL_NUMBER : "GET_SERIAL_NUMBER",
                                     INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN :  "GET_KEY_INDEX_IN_STORAGE_AND_LEN",
                                     INS_GET_KEY_CHUNK : "GET_KEY_CHUNK",
                                     INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY : "CHECK_AVAILABLE_VOL_FOR_NEW_KEY",
                                     INS_ADD_KEY_CHUNK : "ADD_KEY_CHUNK",
                                     INS_CHANGE_KEY_CHUNK : "CHANGE_KEY_CHUNK",
                                     INS_DELETE_KEY_CHUNK : "DELETE_KEY_CHUNK",
                                     INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS : "GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS",
                                     INS_INITIATE_DELETE_KEY : "INITIATE_DELETE_KEY",
                                     INS_DELETE_KEY_RECORD : "DELETE_KEY_RECORD",
                                     INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS : "GET_DELETE_KEY_RECORD_NUM_OF_PACKETS",
                                     INS_GET_NUMBER_OF_KEYS : "GET_NUMBER_OF_KEYS",
                                     INS_GET_FREE_STORAGE_SIZE : "GET_FREE_STORAGE_SIZE",
                                     INS_GET_OCCUPIED_STORAGE_SIZE : "GET_OCCUPIED_STORAGE_SIZE",
                                     INS_GET_HMAC : "GET_HMAC",
                                     INS_RESET_KEYCHAIN : "RESET_KEYCHAIN",
                                     INS_GET_SAULT : "GET_SAULT",
                                     INS_CHECK_KEY_HMAC_CONSISTENCY : "CHECK_KEY_HMAC_CONSISTENCY",
                                     INS_ADD_RECOVERY_DATA_PART :
        "ADD_RECOVERY_DATA_PART",
                                     INS_GET_RECOVERY_DATA_PART :
        "GET_RECOVERY_DATA_PART",
                                     INS_GET_RECOVERY_DATA_HASH :
        "GET_RECOVERY_DATA_HASH",
                                     INS_GET_RECOVERY_DATA_LEN :
        "GET_RECOVERY_DATA_LEN",
                                     INS_RESET_RECOVERY_DATA :
        "RESET_RECOVERY_DATA",
                                     INS_IS_RECOVERY_DATA_SET :
        "IS_RECOVERY_DATA_SET"
    ]
    
    static func getApduCommandName(ins : UInt8) -> String? {
        return APDU_COMMAND_NAMES[ins]
        
    }
    
    static let APPLET_COMMAND_STATE_MAPPING = [
        INS_FINISH_PERS : TonWalletAppletConstants.INSTALLED_STATE,
        INS_SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION: TonWalletAppletConstants.INSTALLED_STATE,
        INS_SET_SERIAL_NUMBER : TonWalletAppletConstants.INSTALLED_STATE,
        INS_SET_ENCRYPTED_COMMON_SECRET : TonWalletAppletConstants.INSTALLED_STATE,
        INS_VERIFY_PASSWORD : TonWalletAppletConstants.WAITE_AUTHORIZATION_STATE,
        INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET : TonWalletAppletConstants.WAITE_AUTHORIZATION_STATE,
        INS_GET_HASH_OF_ENCRYPTED_PASSWORD : TonWalletAppletConstants.WAITE_AUTHORIZATION_STATE,
        INS_VERIFY_PIN : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_PUBLIC_KEY : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_SIGN_SHORT_MESSAGE : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_KEY_CHUNK : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_DELETE_KEY_CHUNK : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS :  TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS :  TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_DELETE_KEY_RECORD : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_INITIATE_DELETE_KEY : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_NUMBER_OF_KEYS : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_FREE_STORAGE_SIZE : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_OCCUPIED_STORAGE_SIZE : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_HMAC : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_RESET_KEYCHAIN : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_SAULT : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_CHECK_KEY_HMAC_CONSISTENCY : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY : TonWalletAppletConstants.PERSONALIZED_STATE,
        INS_ADD_KEY_CHUNK : TonWalletAppletConstants.PERSONALIZED_STATE,
        INS_INITIATE_CHANGE_OF_KEY : TonWalletAppletConstants.PERSONALIZED_STATE,
        INS_CHANGE_KEY_CHUNK : TonWalletAppletConstants.PERSONALIZED_STATE,
        INS_GET_APP_INFO : TonWalletAppletConstants.ALL_APPLET_STATES,
        INS_GET_SERIAL_NUMBER : TonWalletAppletConstants.ALL_APPLET_STATES,
        INS_ADD_RECOVERY_DATA_PART : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_RECOVERY_DATA_PART : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_RECOVERY_DATA_HASH : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_GET_RECOVERY_DATA_LEN : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_RESET_RECOVERY_DATA : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE,
        INS_IS_RECOVERY_DATA_SET : TonWalletAppletConstants.PERSONALIZED_AND_DELETE_STATE
    ]
    
    static let SELECT_TON_WALLET_APPLET_APDU = NFCISO7816APDU(instructionClass:0x00, instructionCode:0xA4, p1Parameter:0x04, p2Parameter:0x00, data: Data(_ :  CommonConstants.TON_WALLET_APPLET_AID),expectedResponseLength:-1)
    
    static let GET_APP_INFO_APDU =  NFCISO7816APDU(instructionClass: WALLET_APPLET_CLA, instructionCode: INS_GET_APP_INFO, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength: TonWalletAppletConstants.GET_APP_INFO_LE)
    
    static let GET_SERIAL_NUMBER_APDU =  NFCISO7816APDU(instructionClass: WALLET_APPLET_CLA, instructionCode: INS_GET_SERIAL_NUMBER, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength: TonWalletAppletConstants.GET_SERIAL_NUMBER_LE)
    
    static let GET_HASH_OF_ENCRYPTED_PASSWORD_APDU = NFCISO7816APDU(instructionClass: WALLET_APPLET_CLA, instructionCode: INS_GET_HASH_OF_ENCRYPTED_PASSWORD, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength: TonWalletAppletConstants.SHA_HASH_SIZE)
    
    static let GET_HASH_OF_ENCRYPTED_COMMON_SECRET_APDU = NFCISO7816APDU(instructionClass: WALLET_APPLET_CLA, instructionCode: INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength: TonWalletAppletConstants.SHA_HASH_SIZE)
    
    static let GET_PUB_KEY_WITH_DEFAULT_PATH_APDU =  NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength:TonWalletAppletConstants.PK_LEN)
    
    static let GET_SAULT_APDU = NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_SAULT, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength:TonWalletAppletConstants.SAULT_LENGTH)
    
    static let GET_RECOVERY_DATA_HASH_APDU = NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_RECOVERY_DATA_HASH, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength:TonWalletAppletConstants.SHA_HASH_SIZE)
    
    static let GET_RECOVERY_DATA_LEN_APDU = NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_RECOVERY_DATA_LEN, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength:0x02)
    
    static let IS_RECOVERY_DATA_SET_APDU = NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_IS_RECOVERY_DATA_SET, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength:0x01)
    
    static let RESET_RECOVERY_DATA_APDU = NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_RESET_RECOVERY_DATA, p1Parameter:0x00, p2Parameter:0x00, data: Data(), expectedResponseLength:-1)

    static func getGetRecoveryDataPartApdu(startPositionBytes : [UInt8], le : Int) throws -> NFCISO7816APDU {
        if startPositionBytes.count != 2 {
            throw ResponsesConstants.ERROR_MSG_START_POS_BYTE_REPRESENTATION_SIZE_INCORRECT
        }
        if le <= -1 || le > 256 {
            throw ResponsesConstants.ERROR_MSG_LE_INCORRECT
        }
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_RECOVERY_DATA_PART, p1Parameter:0x00, p2Parameter:0x00, data: Data(_ : startPositionBytes), expectedResponseLength:le)
    }
    
    static func getAddRecoveryDataPartApdu(p1: UInt8, data : [UInt8]) throws -> NFCISO7816APDU {
        if p1 < 0 || p1 > 2 {
            throw ResponsesConstants.ERROR_MSG_APDU_P1_INCORRECT
        }
        if data.count == 0 || data.count > TonWalletAppletConstants.APDU_DATA_MAX_SIZE {
            throw ResponsesConstants.ERROR_MSG_APDU_DATA_FIELD_SIZE_INCORRECT
        }
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_ADD_RECOVERY_DATA_PART, p1Parameter:p1, p2Parameter:0x00, data: Data(_ : data), expectedResponseLength:-1)
    }

    static func getVerifyPasswordApdu(password: [UInt8], initialVector : [UInt8]) throws -> NFCISO7816APDU {
        if password.count != TonWalletAppletConstants.PASSWORD_SIZE {
            throw ResponsesConstants.ERROR_MSG_ACTIVATION_PASSWORD_BYTES_SIZE_INCORRECT
        }
        if initialVector.count != TonWalletAppletConstants.IV_SIZE {
            throw ResponsesConstants.ERROR_MSG_INITIAL_VECTOR_BYTES_SIZE_INCORRECT
        }
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_VERIFY_PASSWORD, p1Parameter:0x00, p2Parameter:0x00, data: Data(_ : password + initialVector), expectedResponseLength:-1)
    }
    
    static func getVerifyPinApdu(pinBytes: [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        if pinBytes.count != CommonConstants.PIN_SIZE {
            throw ResponsesConstants.ERROR_MSG_PIN_BYTES_SIZE_INCORRECT
        }
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : pinBytes + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_VERIFY_PIN, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:-1)
    }
    
    static func getSignShortMessageWithDefaultPathApdu(dataForSigning: [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        if (dataForSigning.count == 0 || dataForSigning.count > TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE ) {
            throw ResponsesConstants.ERROR_MSG_DATA_BYTES_SIZE_INCORRECT
        }
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : [0x00, UInt8(dataForSigning.count)] + dataForSigning + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.SIG_LEN)
    }
    
    static func getSignShortMessageApdu(dataForSigning: [UInt8], ind: [UInt8], sault: [UInt8]) throws -> NFCISO7816APDU {
        if (dataForSigning.count == 0 ||
            dataForSigning.count > TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH) {
            throw ResponsesConstants.ERROR_MSG_DATA_WITH_HD_PATH_BYTES_SIZE_INCORRECT
        }
        try checkHdIndex(ind: ind)
        try checkSault(sault: sault)
        let indAndSault = ind + sault
        let dataChunk = [0x00, UInt8(dataForSigning.count)] + dataForSigning + [UInt8(ind.count)] + indAndSault
        let data = try prepareApduData( dataChunk : dataChunk)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_SIGN_SHORT_MESSAGE, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.SIG_LEN)
    }
    
    static func getPublicKeyApdu(ind: [UInt8]) throws -> NFCISO7816APDU {
        try checkHdIndex(ind: ind)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_PUBLIC_KEY, p1Parameter:0x00, p2Parameter:0x00, data: Data(_ : ind), expectedResponseLength:TonWalletAppletConstants.PK_LEN)
    }
    
    static func getResetKeyChainApdu(sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_RESET_KEYCHAIN, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:-1)
    }
    
    static func getNumberOfKeysApdu(sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_NUMBER_OF_KEYS, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.GET_NUMBER_OF_KEYS_LE)
    }
    
    static func getCheckKeyHmacConsistencyApdu(keyHmac: [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkHmac(hmac: keyHmac)
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : keyHmac + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_CHECK_KEY_HMAC_CONSISTENCY, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:-1)
    }
    
    static func getCheckAvailableVolForNewKeyApdu(keySize: [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        if keySize.count != 2 {
            throw ResponsesConstants.ERROR_MSG_KEY_SIZE_BYTE_REPRESENTATION_SIZE_INCORRECT 
        }
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : keySize + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:-1)
    }
    
    static func getInitiateChangeOfKeyApdu(index: [UInt8], sault: [UInt8]) throws -> NFCISO7816APDU {
        try checkKeyChainKeyIndex(ind: index)
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : index + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_INITIATE_CHANGE_OF_KEY, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:-1)
    }
    
    static func getGetIndexAndLenOfKeyInKeyChainApdu(keyHmac : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkHmac(hmac: keyHmac)
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : keyHmac + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.GET_KEY_INDEX_IN_STORAGE_AND_LEN_LE)
    }
    
    static func getInitiateDeleteOfKeyApdu(index : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkKeyChainKeyIndex(ind: index)
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : index + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_INITIATE_DELETE_KEY, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.INITIATE_DELETE_KEY_LE)
    }
    
    static func getDeleteKeyChunkApdu(sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_DELETE_KEY_CHUNK, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.DELETE_KEY_CHUNK_LE)
    }
    
    static func getDeleteKeyRecordApdu(sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_DELETE_KEY_RECORD, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.DELETE_KEY_RECORD_LE)
    }
    
    static func getDeleteKeyChunkNumOfPacketsApdu(sault : [UInt8]) throws -> NFCISO7816APDU{
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_LE)
    }
      
    static func getDeleteKeyRecordNumOfPacketsApdu(sault : [UInt8]) throws -> NFCISO7816APDU{
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_LE)
    }
      
    static func getGetOccupiedSizeApdu(sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_OCCUPIED_STORAGE_SIZE, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.GET_OCCUPIED_SIZE_LE)
    }
     
    static func getGetFreeSizeApdu(sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_FREE_STORAGE_SIZE, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength:TonWalletAppletConstants.GET_FREE_SIZE_LE)
    }
    
    static func getGetHmacApdu(ind : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkKeyChainKeyIndex(ind: ind)
        try checkSault(sault: sault)
        let data = try prepareApduData(dataChunk : ind + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_HMAC, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength: Int(TonWalletAppletConstants.HMAC_SHA_SIG_SIZE + 2))
    }
     
    static func getGetKeyChunkApdu(ind : [UInt8], startPos: UInt16, sault : [UInt8], le : Int) throws -> NFCISO7816APDU {
        if le <= -1 || le > TonWalletAppletConstants.DATA_PORTION_MAX_SIZE {
            throw ResponsesConstants.ERROR_MSG_LE_INCORRECT
        }
        try checkKeyChainKeyIndex(ind: ind)
        try checkSault(sault: sault)
        let startPosBytes = withUnsafeBytes(of: startPos.bigEndian, Array.init)
        print(startPosBytes.count)
        print(startPosBytes[0])
        print(startPosBytes[1])
        let data = try prepareApduData(dataChunk : ind + startPosBytes + sault)
        return NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:INS_GET_KEY_CHUNK, p1Parameter:0x00, p2Parameter:0x00, data: data, expectedResponseLength: le)
    }
     
    static func getAddKeyChunkApdu(p1 : UInt8, keyChunkOrMacBytes : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try getSendKeyChunkApdu(ins: INS_ADD_KEY_CHUNK, p1: p1, keyChunkOrMacBytes:keyChunkOrMacBytes, sault: sault)
    }
    
    static func getChangeKeyChunkApdu(p1 : UInt8, keyChunkOrMacBytes : [UInt8], sault : [UInt8] ) throws -> NFCISO7816APDU {
        try getSendKeyChunkApdu(ins: INS_CHANGE_KEY_CHUNK, p1: p1, keyChunkOrMacBytes:keyChunkOrMacBytes, sault: sault)
    }
    
    static func getSendKeyChunkApdu(ins : UInt8, p1 : UInt8, keyChunkOrMacBytes : [UInt8], sault : [UInt8] ) throws -> NFCISO7816APDU {
        try checkSault(sault: sault)
        if p1 < 0 || p1 > 2 {
            throw ResponsesConstants.ERROR_MSG_APDU_P1_INCORRECT
        }
        if p1 < 2 && (keyChunkOrMacBytes.count == 0 || keyChunkOrMacBytes.count > TonWalletAppletConstants.DATA_PORTION_MAX_SIZE) {
            throw ResponsesConstants.ERROR_MSG_KEY_CHUNK_BYTES_SIZE_INCORRECT
        }
        if p1 == 2 && keyChunkOrMacBytes.count != TonWalletAppletConstants.HMAC_SHA_SIG_SIZE {
            throw ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT
        }
        let data = (p1 == 2) ? try prepareApduData(dataChunk : keyChunkOrMacBytes + sault) :
            try prepareApduData(dataChunk : [UInt8(keyChunkOrMacBytes.count)] + keyChunkOrMacBytes + sault)
        return (p1 == 2) ? NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:ins, p1Parameter:p1, p2Parameter:0x00, data: Data(_ : data), expectedResponseLength: TonWalletAppletConstants.SEND_CHUNK_LE) :
            NFCISO7816APDU(instructionClass:WALLET_APPLET_CLA, instructionCode:ins, p1Parameter:p1, p2Parameter:0x00, data: data, expectedResponseLength: -1)
    }
    
    static func prepareApduData(dataChunk : [UInt8]) throws -> Data {
        var dataField = Data(_  :  dataChunk)
        let mac = try hmacHelper.computeHmac(data: dataField)
        dataField.append(mac)
        return dataField
    }
    
    static func checkSault(sault : [UInt8]) throws {
        if sault.count != TonWalletAppletConstants.SAULT_LENGTH {
            throw ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT
        }
    }
    
    static func checkHdIndex(ind : [UInt8]) throws {
        if ind.count == 0 || ind.count > TonWalletAppletConstants.MAX_IND_SIZE {
            throw ResponsesConstants.ERROR_MSG_HD_INDEX_BYTES_SIZE_INCORRECT
        }
    }
    
    static func checkKeyChainKeyIndex(ind : [UInt8]) throws {
        if ind.count != TonWalletAppletConstants.KEYCHAIN_KEY_INDEX_LEN {
            throw ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT
        }
    }
    
    static func checkHmac(hmac: [UInt8]) throws {
        if (hmac.count != TonWalletAppletConstants.HMAC_SHA_SIG_SIZE) {
            throw ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT
        }
    }

}
