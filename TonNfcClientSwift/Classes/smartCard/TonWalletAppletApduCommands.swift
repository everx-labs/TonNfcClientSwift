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

/**
 * Here there are all objects representing APDU commands of TonWalletApplet
 */

/**
 * We are using the following notation:
 * CLA = APDU command class
 * INS = APDU command type
 * P1= first param of APDU
 * P2= second param of APDU
 * LC = length of input data for APDU command
 * LE = length of response data array for APDU command.
 *
 * Each APDU command field (CLA, INS, P1, P2, Lc and Le)  has a size = 1 byte except of Data.
 * APDU command may have one of the following format:
 * CLA | INS | P1 | P2
 * CLA | INS | P1 | P2 | LC | Data
 * CLA | INS | P1 | P2 | LC | Data | LE
 * CLA | INS | P1 | P2 | LE
 *
 * Note:
 * 1) LE = 0 usually means that applet must return all the data that it has
 * 2) LE = -1 we use for the case when really LE is absent and we do not wait for response from the card.
 */

//TODO: unify work with startPos everywhere and add some verification

@available(iOS 13.0, *)
class TonWalletAppletApduCommands {
    static let hmacHelper = HmacHelper.getInstance()
    
    static let WALLET_APPLET_CLA : UInt8 = 0xB0
    static let P1 : UInt8 = 0x00
    static let P2 : UInt8 = 0x00
    
    /**
        Instruction codes
     */
    
    /**
        Personalization (installed) mode
     */
    static let INS_FINISH_PERS : UInt8 = 0x90
    static let INS_SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION : UInt8 = 0x91
    static let INS_SET_ENCRYPTED_COMMON_SECRET : UInt8 = 0x94
    static let INS_SET_SERIAL_NUMBER : UInt8 = 0x96
    
    /**
        Waite for authentication (activation) mode
     */
    static let INS_VERIFY_PASSWORD : UInt8 = 0x92
    static let INS_GET_HASH_OF_ENCRYPTED_PASSWORD : UInt8 = 0x93
    static let INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET : UInt8 = 0x95
    
    /**
        Personalized (main) mode
     */
    static let INS_GET_PUBLIC_KEY : UInt8 = 0xA0
    static let INS_GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH : UInt8 = 0xA7
    static let INS_VERIFY_PIN : UInt8 = 0xA2
    static let INS_SIGN_SHORT_MESSAGE : UInt8 = 0xA3
    static let INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH : UInt8 = 0xA5
    
    static let INS_CHECK_KEY_HMAC_CONSISTENCY : UInt8 = 0xB0
    static let INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN : UInt8 = 0xB1
    static let INS_GET_KEY_CHUNK : UInt8 = 0xB2
    static let INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY : UInt8 = 0xB3
    static let INS_ADD_KEY_CHUNK : UInt8 = 0xB4
    static let INS_INITIATE_CHANGE_OF_KEY : UInt8 = 0xB5
    static let INS_CHANGE_KEY_CHUNK : UInt8 = 0xB6
    static let INS_INITIATE_DELETE_KEY : UInt8 = 0xB7
    
    static let INS_GET_NUMBER_OF_KEYS : UInt8 = 0xB8
    static let INS_GET_FREE_STORAGE_SIZE : UInt8 = 0xB9
    static let INS_GET_OCCUPIED_STORAGE_SIZE : UInt8 = 0xBA
    static let INS_GET_HMAC : UInt8 = 0xBB
    static let INS_RESET_KEYCHAIN : UInt8 = 0xBC
    
    static let INS_GET_SAULT : UInt8 = 0xBD
    static let INS_GET_APP_INFO : UInt8 = 0xC1
    static let INS_GET_SERIAL_NUMBER : UInt8 = 0xC2
    
    static let INS_ADD_RECOVERY_DATA_PART : UInt8 = 0xD1
    static let INS_GET_RECOVERY_DATA_PART : UInt8 = 0xD2
    static let INS_GET_RECOVERY_DATA_HASH : UInt8 = 0xD3
    static let INS_GET_RECOVERY_DATA_LEN : UInt8 = 0xD4
    static let INS_RESET_RECOVERY_DATA : UInt8 = 0xD5
    static let INS_IS_RECOVERY_DATA_SET : UInt8 = 0xD6
    
    /**
        DELETE_KEY_FROM_KEYCHAIN_MODE
     */
    static let INS_DELETE_KEY_CHUNK : UInt8 = 0xBE
    static let INS_DELETE_KEY_RECORD : UInt8 = 0xBF
    static let INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS : UInt8 = 0xE1
    static let INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS : UInt8 = 0xE2
    
    static let SELECT_TON_APPLET_NAME = "SELECT_TON_APPLET"
    static let FINISH_PERS_NAME = "FINISH_PERS"
    static let SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION_NAME = "SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION"
    static let SET_SERIAL_NUMBER_NAME = "SET_SERIAL_NUMBER"
    static let SET_ENCRYPTED_COMMON_SECRET_NAME = "SET_ENCRYPTED_COMMON_SECRET"
    static let VERIFY_PASSWORD_NAME = "VERIFY_PASSWORD"
    static let GET_HASH_OF_ENCRYPTED_PASSWORD_NAME = "GET_HASH_OF_ENCRYPTED_PASSWORD"
    static let GET_HASH_OF_ENCRYPTED_COMMON_SECRET_NAME = "GET_HASH_OF_ENCRYPTED_COMMON_SECRET"
    static let VERIFY_PIN_NAME = "VERIFY_PIN"
    static let GET_PUBLIC_KEY_NAME = "GET_PUBLIC_KEY"
    static let GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH_NAME = "GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH "
    static let SIGN_SHORT_MESSAGE_NAME = "SIGN_SHORT_MESSAGE"
    static let SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH_NAME = "SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH"
    static let GET_APP_INFO_NAME = "GET_APP_INFO"
    static let GET_SERIAL_NUMBER_NAME = "GET_SERIAL_NUMBER"
    static let GET_KEY_INDEX_IN_STORAGE_AND_LEN_NAME = "GET_KEY_INDEX_IN_STORAGE_AND_LEN"
    static let GET_KEY_CHUNK_NAME = "GET_KEY_CHUNK"
    static let CHECK_AVAILABLE_VOL_FOR_NEW_KEY_NAME = "CHECK_AVAILABLE_VOL_FOR_NEW_KEY"
    static let ADD_KEY_CHUNK_NAME = "ADD_KEY_CHUNK"
    static let CHANGE_KEY_CHUNK_NAME = "CHANGE_KEY_CHUNK"
    static let DELETE_KEY_CHUNK_NAME = "DELETE_KEY_CHUNK"
    static let GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_NAME = "GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS"
    static let INITIATE_DELETE_KEY_NAME = "INITIATE_DELETE_KEY"
    static let DELETE_KEY_RECORD_NAME = "DELETE_KEY_RECORD"
    static let GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_NAME = "GET_DELETE_KEY_RECORD_NUM_OF_PACKETS"
    static let GET_NUMBER_OF_KEYS_NAME = "GET_NUMBER_OF_KEYS"
    static let GET_FREE_STORAGE_SIZE_NAME = "GET_FREE_STORAGE_SIZE"
    static let GET_OCCUPIED_STORAGE_SIZE_NAME = "GET_OCCUPIED_STORAGE_SIZE"
    static let GET_HMAC_NAME = "GET_HMAC_SIZE"
    static let RESET_KEYCHAIN_NAME = "RESET_KEYCHAIN_SIZE"
    static let GET_SAULT_NAME = "GET_SAULT_SIZE"
    static let CHECK_KEY_HMAC_CONSISTENCY_NAME = "CHECK_KEY_HMAC_CONSISTENCY_SIZE"
    static let ADD_RECOVERY_DATA_PART_NAME = "ADD_RECOVERY_DATA_PART"
    static let GET_RECOVERY_DATA_PART_NAME = "GET_RECOVERY_DATA_PART"
    static let GET_RECOVERY_DATA_HASH_NAME = "GET_RECOVERY_DATA_HASH"
    static let GET_RECOVERY_DATA_LEN_NAME = "GET_RECOVERY_DATA_LEN"
    static let RESET_RECOVERY_DATA_NAME = "RESET_RECOVERY_DATA"
    static let IS_RECOVERY_DATA_SET_NAME = "IS_RECOVERY_DATA_SET"
    
    static let APDU_COMMAND_NAMES = [CommonConstants.INS_SELECT: SELECT_TON_APPLET_NAME,
                                     INS_FINISH_PERS : FINISH_PERS_NAME,
                                     INS_SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION : SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION_NAME,
                                     INS_SET_SERIAL_NUMBER : SET_SERIAL_NUMBER_NAME,
                                     INS_SET_ENCRYPTED_COMMON_SECRET : SET_ENCRYPTED_COMMON_SECRET_NAME,
                                     INS_VERIFY_PASSWORD : VERIFY_PASSWORD_NAME,
                                     INS_GET_HASH_OF_ENCRYPTED_PASSWORD :  GET_HASH_OF_ENCRYPTED_PASSWORD_NAME,
                                     INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET : GET_HASH_OF_ENCRYPTED_COMMON_SECRET_NAME,
                                     INS_VERIFY_PIN : VERIFY_PIN_NAME,
                                     INS_GET_PUBLIC_KEY : GET_PUBLIC_KEY_NAME,
                                     INS_GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH : GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH_NAME,
                                     INS_SIGN_SHORT_MESSAGE: SIGN_SHORT_MESSAGE_NAME,
                                     INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH : SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH_NAME,
                                     INS_GET_APP_INFO: GET_APP_INFO_NAME,
                                     INS_GET_SERIAL_NUMBER : GET_SERIAL_NUMBER_NAME,
                                     INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN : GET_KEY_INDEX_IN_STORAGE_AND_LEN_NAME,
                                     INS_GET_KEY_CHUNK : GET_KEY_CHUNK_NAME,
                                     INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY : CHECK_AVAILABLE_VOL_FOR_NEW_KEY_NAME,
                                     INS_ADD_KEY_CHUNK : ADD_KEY_CHUNK_NAME,
                                     INS_CHANGE_KEY_CHUNK : CHANGE_KEY_CHUNK_NAME,
                                     INS_DELETE_KEY_CHUNK : DELETE_KEY_CHUNK_NAME,
                                     INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS : GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_NAME,
                                     INS_INITIATE_DELETE_KEY : INITIATE_DELETE_KEY_NAME,
                                     INS_DELETE_KEY_RECORD : DELETE_KEY_RECORD_NAME,
                                     INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS : GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_NAME,
                                     INS_GET_NUMBER_OF_KEYS : GET_NUMBER_OF_KEYS_NAME,
                                     INS_GET_FREE_STORAGE_SIZE : GET_FREE_STORAGE_SIZE_NAME,
                                     INS_GET_OCCUPIED_STORAGE_SIZE : GET_OCCUPIED_STORAGE_SIZE_NAME,
                                     INS_GET_HMAC : GET_HMAC_NAME,
                                     INS_RESET_KEYCHAIN : RESET_KEYCHAIN_NAME,
                                     INS_GET_SAULT : GET_SAULT_NAME,
                                     INS_CHECK_KEY_HMAC_CONSISTENCY : CHECK_KEY_HMAC_CONSISTENCY_NAME,
                                     INS_ADD_RECOVERY_DATA_PART : ADD_RECOVERY_DATA_PART_NAME,
                                     INS_GET_RECOVERY_DATA_PART : GET_RECOVERY_DATA_PART_NAME,
                                     INS_GET_RECOVERY_DATA_HASH : GET_RECOVERY_DATA_HASH_NAME,
                                     INS_GET_RECOVERY_DATA_LEN : GET_RECOVERY_DATA_LEN_NAME,
                                     INS_RESET_RECOVERY_DATA : RESET_RECOVERY_DATA_NAME,
                                     INS_IS_RECOVERY_DATA_SET : IS_RECOVERY_DATA_SET_NAME
    ]
    
    static func getApduCommandName(ins : UInt8) -> String? {
        return APDU_COMMAND_NAMES[ins]
    }
    
    static let APPLET_COMMAND_STATE_MAPPING = [
        INS_FINISH_PERS : TonWalletAppletConstants.INSTALLED_STATE,
        INS_SET_ENCRYPTED_PASSWORD_FOR_CARD_AUTHENTICATION: TonWalletAppletConstants.INSTALLED_STATE,
        INS_SET_SERIAL_NUMBER : TonWalletAppletConstants.INSTALLED_STATE,
        INS_SET_ENCRYPTED_COMMON_SECRET : TonWalletAppletConstants.INSTALLED_STATE,
        INS_VERIFY_PASSWORD : TonWalletAppletConstants.WAITE_AUTHENTICATION_STATE,
        INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET : TonWalletAppletConstants.WAITE_AUTHENTICATION_STATE,
        INS_GET_HASH_OF_ENCRYPTED_PASSWORD : TonWalletAppletConstants.WAITE_AUTHENTICATION_STATE,
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
    
    /**
       This command selects TonWalletApplet to start communicating with applet.
    */
    static let SELECT_TON_WALLET_APPLET_APDU = NFCISO7816APDU(instructionClass : CommonConstants.CLA_SELECT, instructionCode : CommonConstants.INS_SELECT, p1Parameter : CommonConstants.SELECT_P1, p2Parameter : CommonConstants.SELECT_P2, data : Data(_ :  CommonConstants.TON_WALLET_APPLET_AID), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    
    /**
       * GET_APP_INFO

       * CLA: 0xB0
       * INS: 0xC1
       * P1: 0x00
       * P2: 0x00
       * LE: 0x01
     
       * This command returns applet state. Available in any applet state. Applet state = 0x07, 0x17, 0x27, 0x37 or 0x47
    */
    static let GET_APP_INFO_APDU =  NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_APP_INFO, p1Parameter : P1, p2Parameter : P2, data: Data(), expectedResponseLength : TonWalletAppletConstants.GET_APP_INFO_LE)
    
    
    static let GET_SERIAL_NUMBER_APDU =  NFCISO7816APDU(instructionClass: WALLET_APPLET_CLA, instructionCode: INS_GET_SERIAL_NUMBER, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength: TonWalletAppletConstants.GET_SERIAL_NUMBER_LE)
    
    /**
       * GET_HASH_OF_ENCRYPTED_PASSWORD

       * CLA: 0xB0
       * INS: 0x93
       * P1: 0x00
       * P2: 0x00
       * LE: 0x20
    
       * This command returns SHA256 hash of encrypted (by AES) activation password. Available only in WAITE_AUTHENTICATION_MODE state of applet.
    */
    static let GET_HASH_OF_ENCRYPTED_PASSWORD_APDU = NFCISO7816APDU(instructionClass: WALLET_APPLET_CLA, instructionCode: INS_GET_HASH_OF_ENCRYPTED_PASSWORD, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength: TonWalletAppletConstants.SHA_HASH_SIZE)
    
    /**
       * GET_HASH_OF_COMMON_SECRET
       
       * CLA: 0xB0
       * INS: 0x95
       * P1: 0x00
       * P2: 0x00
       * LE: 0x20
       
       * This command returns SHA256 hash of encrypted (by AES) activation common secret. Available only in WAITE_AUTHENTICATION_MODE state of applet.
    */
    static let GET_HASH_OF_ENCRYPTED_COMMON_SECRET_APDU = NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_HASH_OF_ENCRYPTED_COMMON_SECRET, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength : TonWalletAppletConstants.SHA_HASH_SIZE)
    
    /**
       * GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH
       
       * CLA: 0xB0
       * INS: 0xA7
       * P1: 0x00
       * P2: 0x00
       * LE: 0x20
       
       * This function retrieves ED25519 public key from CoinManager for fixed bip44 HD path m/44'/396'/0'/0'/0
    */
    static let GET_PUB_KEY_WITH_DEFAULT_PATH_APDU =  NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_PUBLIC_KEY_WITH_DEFAULT_HD_PATH, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength : TonWalletAppletConstants.PK_LEN)
    
    /**
       * GET_SAULT
       
       * CLA: 0xB0
       * INS: 0xBD
       * P1: 0x00
       * P2: 0x00
       * LE: 0x20
       
       * The command outputs random 32-bytes sault produced by card. This sault must be used  by the host to generate HMAC.
       * In the end of its work it calls generateNewSault. So each call of GET_SAULT should produce new random looking sault
       * Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static let GET_SAULT_APDU = NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_SAULT, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength : TonWalletAppletConstants.SAULT_LENGTH)
    
    /**
        * GET_RECOVERY_DATA_HASH
        
        * CLA: 0xB0
        * INS: 0xD3
        * P1: 0x00
        * P2: 0x00
        * LE: 0x20
        
        * This function returns SHA256 hash of encrypted binary blob saved during registration in Recovery service. This is necessary to control the integrity.
        * Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static let GET_RECOVERY_DATA_HASH_APDU = NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_RECOVERY_DATA_HASH, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength : TonWalletAppletConstants.SHA_HASH_SIZE)
    
    /**
       * GET_RECOVERY_DATA_LEN
       
       * CLA: 0xB0
       * INS: 0xD4
       * P1: 0x00
       * P2: 0x00
       * LE:  0x02
       
       * This function returns real length of recovery data  saved in applet's internal buffer.
       * Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static let GET_RECOVERY_DATA_LEN_APDU = NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_RECOVERY_DATA_LEN, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength : TonWalletAppletConstants.GET_RECOVERY_DATA_LEN_LE)
    
    /**
       * IS_RECOVERY_DATA_SET
       
       * CLA: 0xB0
       * INS: 0xD6
       * P1: 0x00
       * P2: 0x00
       * LE: 0x01
       
       * Returns 0x01 if recovery data is set, 0x00 if not.
       * Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static let IS_RECOVERY_DATA_SET_APDU = NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_IS_RECOVERY_DATA_SET, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength : TonWalletAppletConstants.IS_RECOVERY_DATA_SET_LE)
    
    /**
       * RESET_RECOVERY_DATA
       
       * CLA: 0xB0
       * INS: 0xD5
       * P1: 0x00
       * P2: 0x00
       
       * This function reset recovery data, internal buffer is filled by zeros, internal variable realRecoveryDataLen is set to 0, internal flag  isRecoveryDataSet is set to false.
       * Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE
    */
    static let RESET_RECOVERY_DATA_APDU = NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_RESET_RECOVERY_DATA, p1Parameter : P1, p2Parameter : P2, data : Data(), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    
    
    /**
       * GET_RECOVERY_DATA_PART
       * CLA: 0xB0
       * INS: 0xD2
       * P1: 0x00
       * P2: 0x00
       * LC: 0x02
       * Data: startPosition of recovery data piece in internal buffer
       * LE: length of recovery data piece in internal buffer
       * This function returns encrypted binary blob saved during registration in Recovery service. This APDU command shouldn't be protected with HMAC or PIN.
       * If length of recovery data > 256 bytes then this apdu command must be called multiple times.
       * Since as usually the APDU command can be used to transmit no more than 256 bytes from applet into host at once. It is just a limitation of APDU protocol.
       * 256 bytes is a max byte array length that we can request from the card.
       * Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getGetRecoveryDataPartApdu(startPositionBytes : [UInt8], le : Int) throws -> NFCISO7816APDU {
        if startPositionBytes.count != TonWalletAppletConstants.START_POS_LEN {
            throw ResponsesConstants.ERROR_MSG_START_POS_BYTE_REPRESENTATION_SIZE_INCORRECT
        }
        try checkLe(le)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_RECOVERY_DATA_PART, p1Parameter : P1, p2Parameter : P2, data: Data(_ : startPositionBytes), expectedResponseLength : le)
    }
    
    /**
      * ADD_RECOVERY_DATA_PART
      * CLA: 0xB0
      * INS: 0xD1
      * P1: 0x00 (START_OF_TRANSMISSION), 0x01 or 0x02 (END_OF_TRANSMISSION)
      * P2: 0x00
      * LC: If (P1 ≠ 0x02) Length of recovery data piece else 0x20
      * Data: If (P1 ≠ 0x02) recovery data piece else SHA256(recovery data)
      * This function receives encrypted byte array containing data for recovery service. Now it is multisignature wallet address, surf public key(32 bytes),
      * card common secret (32 bytes) and authentication password (128 bytes) (and this stuff is wrapped in json). Just in case in applet for now we reserved 2048 bytes for string recovery data.
      * It is probably bigger volume than required just now.
      * As usually the APDU command can be used to put no more than 256 bytes into applet at once. It is just a limitation of APDU protocol. 256 bytes is a max byte array length that we can send(request) into the card.
      * So if recover data will extended then ADD_RECOVERY_DATA_PART should be called multiple times sequentially.
      * Last call of ADD_RECOVERY_DATA_PART must contain SHA256 hash of all recovery data. The card inside will compute hash of received data and it will compare te computed hash and hash received from the host.
      * If they are identical then internal flag isRecoveryDataSet is set to true. Otherwise the card resets all internal buffers, sets  isRecoveryDataSet = false and thrwos exception.
      * Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getAddRecoveryDataPartApdu(p1 : UInt8, data : [UInt8]) throws -> NFCISO7816APDU {
        if p1 < 0 || p1 > 2 {
            throw ResponsesConstants.ERROR_MSG_APDU_P1_INCORRECT
        }
        if data.count == 0 || data.count > TonWalletAppletConstants.APDU_DATA_MAX_SIZE {
            throw ResponsesConstants.ERROR_MSG_APDU_DATA_FIELD_SIZE_INCORRECT
        }
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_ADD_RECOVERY_DATA_PART, p1Parameter : p1, p2Parameter : P2, data : Data(_ : data), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }

    /**
       VERIFY_PASSWORD
       CLA: 0xB0
       INS: 0x92
       P1: 0x00
       P2: 0x00
       LC: 0x90
       Data: 128 bytes of unencrypted activation password | 16 bytes of IV for AES128 CBC
       This function is available only in WAITE_AUTHENTICATION_MODE state of applet.
       It makes activation password verification and in the case of success it changes the state of applet: WAITE_AUTHENTICATION_MODE -> PERSONALIZED.
       After 20 unsuccessful attempts to verify password this functions changes the state of applet: WAITE_AUTHENTICATION_MODE -> BLOCKED_MODE. In this case applet is blocked.
       This is irreversible and card becomes useless.
    */
    
    static func getVerifyPasswordApdu(password : [UInt8], initialVector : [UInt8]) throws -> NFCISO7816APDU {
        if password.count != TonWalletAppletConstants.PASSWORD_SIZE {
            throw ResponsesConstants.ERROR_MSG_ACTIVATION_PASSWORD_BYTES_SIZE_INCORRECT
        }
        if initialVector.count != TonWalletAppletConstants.IV_SIZE {
            throw ResponsesConstants.ERROR_MSG_INITIAL_VECTOR_BYTES_SIZE_INCORRECT
        }
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_VERIFY_PASSWORD, p1Parameter : P1, p2Parameter : P2, data : Data(_ : password + initialVector), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
       VERIFY_PIN
       CLA: 0xB0
       INS: 0xA2
       P1: 0x00
       P2: 0x00
       LC: 0x44
       Data: 4 bytes of PIN | 32 bytes of sault | 32 bytes of mac
       This function verifies ascii encoded PIN bytes sent in the data field. After 10 fails of PIN verification internal seed will be blocked.
       Keys produced from it will not be available for signing transactions. And then RESET WALLET and GENERATE SEED APDU commands of CoinManager must be called.
       It will regenerate seed and reset PIN.The default card PIN is 5555 now. This version of applet was written for NFC card.
       It uses special mode PIN_MODE_FROM_API for entering PIN. PIN  bytes are  given to applet as plain text.
       If PIN code = 5555 plain PIN bytes array must look like {0x35, 0x35 0x35, 0x35}.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
       Precondition:  GET_SAULT should be called before to get new sault from card.
    */
    static func getVerifyPinApdu(pinBytes : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try CommonConstants.checkPin(pinBytes)
        try checkSault(sault)
        let data = try prepareApduData(pinBytes + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_VERIFY_PIN, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
       SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH
       CLA: 0xB0
       INS: 0xA5
       P1: 0x00
       P2: 0x00
       LC: APDU data length
       Data: messageLength (2bytes)| message | sault (32 bytes) | mac (32 bytes)
       LE: 0x40
       This function signs the message from apdu buffer by ED25519 for default bip44 HD path
       m/44'/396'/0'/0'/0'.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
       Precondition:  1) GET_SAULT should be called before to get new sault from card. 2) VERIFY_PIN should be called before.
    */
    static func getSignShortMessageWithDefaultPathApdu(dataForSigning : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        if (dataForSigning.count == 0 || dataForSigning.count > TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE ) {
            throw ResponsesConstants.ERROR_MSG_DATA_BYTES_SIZE_INCORRECT
        }
        try checkSault(sault)
        let data = try prepareApduData([0x00, UInt8(dataForSigning.count)] + dataForSigning + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.SIG_LEN)
    }
    
    
    /**
       SIGN_SHORT_MESSAGE
       CLA: 0xB0
       INS: 0xA3
       P1: 0x00
       P2: 0x00
       LC: APDU data length
       Data: messageLength (2bytes)| message | indLength (1 byte, > 0, <= 10) | ind | sault (32 bytes) | mac (32 bytes)
       LE: 0x40
       This function signs the message from apdu buffer by ED25519 for default bip44 HD path
       m/44'/396'/0'/0'/ind'. There is 0 <= ind <= 2^31 - 1. ind must be represented as decimal number and each decimal place should be transformed into Ascii encoding.
       Example: ind = 171 ⇒ {0x31, 0x37, 0x31}
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
       Precondition:  1)* GET_SAULT should be called before to get new sault from card. 2) VERIFY_PIN should be called before.
    */
    static func getSignShortMessageApdu(dataForSigning : [UInt8], hdIndex : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        if (dataForSigning.count == 0 ||
            dataForSigning.count > TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH) {
            throw ResponsesConstants.ERROR_MSG_DATA_WITH_HD_PATH_BYTES_SIZE_INCORRECT
        }
        try checkHdIndex(hdIndex)
        try checkSault(sault)
        let indAndSault = hdIndex + sault
        let dataChunk = [0x00, UInt8(dataForSigning.count)] + dataForSigning + [UInt8(hdIndex.count)] + indAndSault
        let data = try prepareApduData(dataChunk)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_SIGN_SHORT_MESSAGE, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.SIG_LEN)
    }
    
    /**
       GET_PUBLIC_KEY
       CLA: 0xB0
       INS: 0xA0
       P1: 0x00
       P2: 0x00
       LC: Number of decimal places in ind
       Data: Ascii encoding of ind decimal places
       LE: 0x20
       This function retrieves ED25519 public key from CoinManager for bip44 HD path
       m/44'/396'/0'/0'/ind'. There is 0 <= ind <= 2^31 - 1.
       ind must be represented as decimal number and each decimal place should be transformed into Ascii encoding.
       Example: ind = 171 ⇒ {0x31, 0x37, 0x31}
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getPublicKeyApdu(_ hdIndex : [UInt8]) throws -> NFCISO7816APDU {
        try checkHdIndex(hdIndex)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_PUBLIC_KEY, p1Parameter : P1, p2Parameter : P2, data : Data(_ : hdIndex), expectedResponseLength : TonWalletAppletConstants.PK_LEN)
    }
    
    /**
       RESET_KEYCHAIN
       CLA: 0xB0
       INS: 0xBC
       P1: 0x00
       P2: 0x00
       LC: 0x40
       Data: sault (32 bytes) | mac (32 bytes)
       Clears all internal buffers and counters. So after it keychain is clear. In the end it always switches applet state into APP_PERSONALIZED.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getResetKeyChainApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_RESET_KEYCHAIN, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
       GET_NUMBER_OF_KEYS
       CLA: 0xB0
       INS: 0xB8
       P1: 0x00
       P2: 0x00
       LC: 0x40
       Data: sault (32 bytes) | mac (32 bytes)
       LE: 0x02
       Outputs the number of keys that are stored by KeyChain at the present moment.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getNumberOfKeysApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_NUMBER_OF_KEYS, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.GET_NUMBER_OF_KEYS_LE)
    }
    
    /**
       CHECK_KEY_HMAC_CONSISTENCY
       CLA: 0xB0
       INS: 0xB0
       P1: 0x00
       P2: 0x00
       LC: 0x60
       Data: keyMac (32 bytes) | sault (32 bytes) | mac (32 bytes)
       Gets mac of key and checks that *mac(key bytes in keyStore)* coincides with this mac.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getCheckKeyHmacConsistencyApdu(keyHmac : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkHmac(keyHmac)
        try checkSault(sault)
        let data = try prepareApduData(keyHmac + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_CHECK_KEY_HMAC_CONSISTENCY, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
       CHECK_AVAILABLE_VOL_FOR_NEW_KEY
       CLA: 0xB0
       INS: 0xB3
       P1: 0x00
       P2: 0x00
       LC: 0x42
       Data: length of new key (2 bytes) | sault (32 bytes) | mac (32 bytes)
       Gets from host the size of new key that user wants to add. It checks free space. And if it's enough it saves this value into internal applet variable.
       Otherwise it will throw an exception. This command always should be called before adding new key.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet state PERSONALIZED.
    */
    static func getCheckAvailableVolForNewKeyApdu(keySize : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        if keySize.count != TonWalletAppletConstants.KEY_SIZE_BYTES_LEN {
            throw ResponsesConstants.ERROR_MSG_KEY_SIZE_BYTE_REPRESENTATION_SIZE_INCORRECT 
        }
        try checkSault(sault)
        let data = try prepareApduData(keySize + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
       INITIATE_CHANGE_OF_KEY
       CLA: 0xB0
       INS: 0xB5
       P1: 0x00
       P2: 0x00
       LC: 0x42
       Data: index of key (2 bytes) | sault (32 bytes) | mac (32 bytes)
       Gets from the host  the real index of key to be changed and stores this index into internal applet variable.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet state PERSONALIZED.
    */
    static func getInitiateChangeOfKeyApdu(index : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkKeyChainKeyIndex(index)
        try checkSault(sault)
        let data = try prepareApduData(index + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_INITIATE_CHANGE_OF_KEY, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
       GET_KEY_INDEX_IN_STORAGE_AND_LEN
       CLA: 0xB0
       INS: 0xB1
       P1: 0x00
       P2: 0x00
       LC: 0x60
       Data: hmac of key (32 bytes) | sault (32 bytes) | mac (32 bytes)
       LE: 0x04
       Gets hmac of the key from host. It outputs its real index in keyOffsets array and key length.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getGetIndexAndLenOfKeyInKeyChainApdu(keyHmac : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkHmac(keyHmac)
        try checkSault(sault)
        let data = try prepareApduData(keyHmac + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength:TonWalletAppletConstants.GET_KEY_INDEX_IN_STORAGE_AND_LEN_LE)
    }
    
    /**
       INITIATE_DELETE_KEY
       CLA: 0xB0
       INS: 0xB7
       P1: 0x00
       P2: 0x00
       LC: 0x42
       Data: key  index (2 bytes) | sault (32 bytes) | mac (32 bytes)
       LE: 0x02
       Gets from host the real index of key in keyOffsets array and stores this index into internal applet variable.
       Outputs length of key to be deleted. In the case of success in the end it changes the state of applet on DELETE_KEY_FROM_KEYCHAIN_MODE.
       Precondition:  1) GET_SAULT should be called before to get new sault from card. 2) call GET_KEY_INDEX_IN_STORAGE_AND_LEN to get key index.
       Available in applet state PERSONALIZED.
    */
    static func getInitiateDeleteOfKeyApdu(index : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkKeyChainKeyIndex(index)
        try checkSault(sault)
        let data = try prepareApduData(index + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_INITIATE_DELETE_KEY, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.INITIATE_DELETE_KEY_LE)
    }
    
    /**
       DELETE_KEY_CHUNK
       CLA: 0xB0
       INS: 0xBE
       P1: 0x00
       P2: 0x00
       LC: 0x40
       Data: sault (32 bytes) | mac (32 bytes)
       LE: 0x01
       Deletes the portion of key bytes in internal buffer. Max size of portion = 128 bytes.
       The command should be called (totalOccupied size - offsetOfNextKey) / 128  times + 1 times for tail having length  (totalOccupied size - offsetOfNextKey) % 128.
       The response contains status byte. If status == 0 then we should continue calling DELETE_LEY_CHUNK. Else if status == 1 then process is finished.
       Such splitting into multiple calls was implemented only because we wanted to use javacard transaction for deleting to control data integrity in keychain.
       But our device has small internal buffer for transactions and can not handle big transactions.
       Precondition: 1) GET_SAULT should be called before to get new sault from card.  2) INITIATE_DELETE_KEY should be called before to set the index of key to be deleted.
       Available in applet state DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getDeleteKeyChunkApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_DELETE_KEY_CHUNK, p1Parameter : P1, p2Parameter : P2, data: data, expectedResponseLength : TonWalletAppletConstants.DELETE_KEY_CHUNK_LE)
    }
    
    /**
       DELETE_KEY_RECORD
       CLA: 0xB0
       INS: 0xBF
       P1: 0x00
       P2: 0x00
       LC: 0x40
       Data: sault (32 bytes) | mac (32 bytes)
       LE: 0x01
       Processes the portion of elements in internal buffer storing record about keys. Max size of portion = 12.
       The command should be called (numberOfStoredKeys - indOfKeyToDelete - 1) / 12  times + 1 times for tail having length  (numberOfStoredKeys - indOfKeyToDelete - 1) % 12.
       The response contains status byte. If status == 0 then we should continue calling DELETE_LEY_RECORD. Else if status == 1 then process is finished.
       In the end when status is set to 1 and delete operation is finished applet state is changed on APP_PERSONALIZED.
       And again one may conduct new add, change or delete operation in keychain,
       Such splitting into multiple calls was implemented only because we wanted to use javacard transaction for deleting to control data integrity in keychain.
       But our device has small internal buffer for transactions and can not handle big transactions.
       Precondition: 1) GET_SAULT should be called before to get new sault from card.  2) DELETE_KEY _CHUNK should be called before to clear keyStore array
       (it should be called until it will return response byte = 1).
       Available in applet state DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getDeleteKeyRecordApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_DELETE_KEY_RECORD, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.DELETE_KEY_RECORD_LE)
    }
    
    /**
       * GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS
       * CLA: 0xB0
       * INS: 0xE1
       * P1: 0x00
       * P2: 0x00
       * LC: 0x40
       * Data: sault (32 bytes) | mac (32 bytes)
       * LE: 0x02
       * Outputs total number of iterations that is necessary to remove key chunk from keychain.
       * Precondition: GET_SAULT should be called before to get new sault from card.
       * Available in applet state DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getDeleteKeyChunkNumOfPacketsApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU{
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_LE)
    }
    
    /**
       * GET_DELETE_KEY_RECORD_NUM_OF_PACKETS
       * CLA: 0xB0
       * INS: 0xE2
       * P1: 0x00
       * P2: 0x00
       * LC: 0x40
       * Data: sault (32 bytes) | mac (32 bytes)
       * LE: 0x02
       * Outputs total number of iterations that is necessary to remove key record from keychain.
       * Precondition: GET_SAULT should be called before to get new sault from card.
       * Available in applet state DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getDeleteKeyRecordNumOfPacketsApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU{
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_LE)
    }
    
    /**
       GET_OCCUPIED_STORAGE_SIZE
       CLA: 0xB0
       INS: 0xBA
       P1: 0x00
       P2: 0x00
       LC: 0x40
       Data: sault (32 bytes) | mac (32 bytes)
       LE: 0x02
       Outputs the volume of occupied size (in bytes) in KeyChain.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getGetOccupiedSizeApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_OCCUPIED_STORAGE_SIZE, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.GET_OCCUPIED_SIZE_LE)
    }
    
    /**
       GET_FREE_STORAGE_SIZE
       CLA: 0xB0
       INS: 0xB9
       P1: 0x00
       P2: 0x00
       LC: 0x40
       Data: sault (32 bytes) | mac (32 bytes)
       LE: 0x02
       Outputs the volume of free size in keyStore.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getGetFreeSizeApdu(_ sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkSault(sault)
        let data = try prepareApduData(sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_FREE_STORAGE_SIZE, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.GET_FREE_SIZE_LE)
    }
    
    /**
       GET_HMAC
       CLA: 0xB0
       INS: 0xBB
       P1: 0x00
       P2: 0x00
       LC: 0x42
       Data: index of key (2 bytes) | sault (32 bytes) | mac (32 bytes)
       LE: 0x22
       Gets the index of key (≥ 0 and  < numberOfStoredKeys) and outputs its hmac.
       Precondition:  GET_SAULT should be called before to get new sault from card.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    static func getGetHmacApdu(index : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try checkKeyChainKeyIndex(index)
        try checkSault(sault)
        let data = try prepareApduData(index + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : INS_GET_HMAC, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : TonWalletAppletConstants.GET_HMAC_LE)
    }
    
    /**
       GET_KEY_CHUNK
       CLA: 0xB0
       INS: 0xB2
       P1: 0x00
       P2: 0x00
       LC: 0x44
       Data: key  index (2 bytes) | startPos (2 bytes) | sault (32 bytes) | mac (32 bytes)
       LE: Key chunk length
       Gets from host  the real index of key in keyOffsets array and relative start position from which key bytes should be read (at first time startPos = 0).
       Applet calculates real offset inside keyStore based on its data and startPos and outputs key chunk. Max size of key chunk is 255 bytes.
       So if key size > 255 bytes GET_KEY_CHUNK will be called multiple times. After getting all data host should verify that hmac of received data is correct and we did not lose any packet.
       Precondition:  1) GET_SAULT should be called before to get new sault from card. 2)  call GET_KEY_INDEX_IN_STORAGE_AND_LEN.
       Available in applet states PERSONALIZED and DELETE_KEY_FROM_KEYCHAIN_MODE.
    */
    // TODO: startPos must be verified
    static func getGetKeyChunkApdu(index : [UInt8], startPos: UInt16, sault : [UInt8], le : Int) throws -> NFCISO7816APDU {
        try checkLe(le)
        try checkKeyChainKeyIndex(index)
        try checkSault(sault)
        let startPosBytes = withUnsafeBytes(of : startPos.bigEndian, Array.init)
        let data = try prepareApduData(index + startPosBytes + sault)
        return NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode:INS_GET_KEY_CHUNK, p1Parameter : P1, p2Parameter : P2, data : data, expectedResponseLength : le)
    }
    
    /**
       ADD_KEY_CHUNK
       CLA: 0xB0
       INS: 0xB4
       P1: 0x00 (START_OF_TRANSMISSION), 0x01 or 0x02 (END_OF_TRANSMISSION)
       P2: 0x00
       LC:
       if (P1 = 0x00 OR  0x01): 0x01 +  length of key chunk + 0x40
       if (P1 = 0x02): 0x60
       Data:
       if (P1 = 0x00 OR  0x01): length of key chunk (1 byte) | key chunk | sault (32 bytes) | mac (32 bytes)
       if (P1 = 0x02): hmac of key (32 bytes) | sault (32 bytes) | mac (32 bytes)
       LE: if (P1 = 0x02): 0x02
       Gets keychunk from the host and adds it into the end of keyStore array. Max size of key chunk is 128 bytes.
       So if total key size > 128 bytes ADD_KEY_CHUNK will be called multiple times. After all key data is transmitted we call ADD_KEY_CHUNK once again, its input data is Hmac of the key.
       Applet checks that hmac of received sequence equals to this hmac got from host. So we did not lose any packet and key is not replaced by adversary.
       And also  ADD_KEY_CHUNK  checks that size of new key equals to size set previously by command CHECK_AVAILABLE_VOL_FOR_NEW_KEY.
       If verification is ok all ket data is added into keyMacs, keyOffsets and keyLebs buffers, keys counter is incremented  and since this moment the key is registered and can be requested from the card.
       Precondition:  1) GET_SAULT should be called before to get new sault from card. 2) call CHECK_AVAILABLE_VOL_FOR_NEW_KEY.
       Then ADD_KEY_CHUNK is called multiple times.
       Available in applet states PERSONALIZED.
    */
    static func getAddKeyChunkApdu(p1 : UInt8, keyChunkOrMacBytes : [UInt8], sault : [UInt8]) throws -> NFCISO7816APDU {
        try getSendKeyChunkApdu(ins : INS_ADD_KEY_CHUNK, p1 : p1, keyChunkOrMacBytes : keyChunkOrMacBytes, sault : sault)
    }
    
    /**
       CHANGE_KEY_CHUNK
       CLA: 0xB0
       INS: 0xB6
       P1: 0x00 (START_OF_TRANSMISSION), 0x01 or 0x02 (END_OF_TRANSMISSION)
       P2: 0x00
       LC:
       if (P1 = 0x00 OR  0x01): 0x01 +  length of key chunk + 0x40
       if (P1 = 0x02): 0x60
       Data:
       if (P1 = 0x00 OR  0x01): length of key chunk (1 byte) | key chunk | sault (32 bytes) | mac (32 bytes)
       if (P1 = 0x02): hmac of key (32 bytes) | sault (32 bytes) | mac (32 bytes)
       LE: if (P1 = 0x02): 0x02
       Gets keychunk bytes from the host and puts it into keyStore array in place of old key bytes. Max size of key chunk is 128 bytes.
       So if total key size > 128 bytes CHANGE_KEY_CHUNK will be called multiple times.  We control that lengthes of old key and new key are the same.
       After all new key data is transmitted we call CHANGE_KEY_CHUNK once again, its input data is Hmac of new key and it is verified by applet.
       If it is ok then corresponding data about key  is changed in keyOffsets, keyMacs and keyLens buffers.
       Precondition:  1) GET_SAULT should be called before to get new sault from card. 2)call  GET_KEY_INDEX_IN_STORAGE_AND_LEN , INIATE_CHANGE_OF_KEY.
       Then call CHANGE_KEY_CHUNK multiple times.
       Available in applet states PERSONALIZED.
    */
    static func getChangeKeyChunkApdu(p1 : UInt8, keyChunkOrMacBytes : [UInt8], sault : [UInt8] ) throws -> NFCISO7816APDU {
        try getSendKeyChunkApdu(ins : INS_CHANGE_KEY_CHUNK, p1 : p1, keyChunkOrMacBytes : keyChunkOrMacBytes, sault : sault)
    }
    
    static func getSendKeyChunkApdu(ins : UInt8, p1 : UInt8, keyChunkOrMacBytes : [UInt8], sault : [UInt8] ) throws -> NFCISO7816APDU {
        try checkSault(sault)
        if p1 < 0 || p1 > 2 {
            throw ResponsesConstants.ERROR_MSG_APDU_P1_INCORRECT
        }
        if p1 < 2 && (keyChunkOrMacBytes.count == 0 || keyChunkOrMacBytes.count > TonWalletAppletConstants.DATA_PORTION_MAX_SIZE) {
            throw ResponsesConstants.ERROR_MSG_KEY_CHUNK_BYTES_SIZE_INCORRECT
        }
        if p1 == 2 && keyChunkOrMacBytes.count != TonWalletAppletConstants.HMAC_SHA_SIG_SIZE {
            throw ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT
        }
        let data = (p1 == 2) ? try prepareApduData(keyChunkOrMacBytes + sault) :
            try prepareApduData([UInt8(keyChunkOrMacBytes.count)] + keyChunkOrMacBytes + sault)
        return (p1 == 2) ? NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : ins, p1Parameter : p1, p2Parameter : P2, data : Data(_ : data), expectedResponseLength : TonWalletAppletConstants.SEND_CHUNK_LE) :
            NFCISO7816APDU(instructionClass : WALLET_APPLET_CLA, instructionCode : ins, p1Parameter : p1, p2Parameter : P2, data : data, expectedResponseLength: CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    static func prepareApduData(_ dataChunk : [UInt8]) throws -> Data {
        var dataField = Data(_  :  dataChunk)
        let mac = try hmacHelper.computeHmac(data : dataField)
        dataField.append(mac)
        return dataField
    }
    
    static func checkSault(_ sault : [UInt8]) throws {
        if sault.count != TonWalletAppletConstants.SAULT_LENGTH {
            throw ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT
        }
    }
    
    static func checkHdIndex(_ hdIndex : [UInt8]) throws {
        if hdIndex.count == 0 || hdIndex.count > TonWalletAppletConstants.MAX_IND_SIZE {
            throw ResponsesConstants.ERROR_MSG_HD_INDEX_BYTES_SIZE_INCORRECT
        }
    }
    
    static func checkKeyChainKeyIndex(_ index : [UInt8]) throws {
        if index.count != TonWalletAppletConstants.KEYCHAIN_KEY_INDEX_LEN {
            throw ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT
        }
    }
    
    static func checkHmac(_ hmac : [UInt8]) throws {
        if (hmac.count != TonWalletAppletConstants.HMAC_SHA_SIG_SIZE) {
            throw ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT
        }
    }
    
    static func checkLe(_ le : Int) throws {
        if le <= 0 || le > CommonConstants.LE_GET_ALL_RESPONSE_DATA {
            throw ResponsesConstants.ERROR_MSG_LE_INCORRECT
        }
    }

}
