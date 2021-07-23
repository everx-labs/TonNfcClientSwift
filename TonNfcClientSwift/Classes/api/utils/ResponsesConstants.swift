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

public class ResponsesConstants {
    public static let FAIL_STATUS: String =  "fail"
    public static let SUCCESS_STATUS: String =  "ok"
    public static let DONE_MSG: String =  "done"
    
    public static let FALSE_MSG: String =  "false"
    public static let TRUE_MSG: String =  "true"
    public static let GENERATED_MSG: String =  "generated"
    public static let NOT_GENERATED_MSG: String =  "not generated"
    
    static let HMAC_KEYS_DOES_NOT_FOUND_MSG: String =  "HMAC-SHA256 keys are not found."
    static let HMAC_KEY_GENERATED_MSG: String =  "HMac key to sign APDU data is generated"
    static let PIN_SET_MSG: String =  "Pin is set"
    
    static let CARD_ERROR_TYPE_ID: String =  "0"
    static let SWIFT_INTERNAL_ERROR_TYPE_ID: String =  "1"
    static let NFC_INTERRUPTION_TYPE_ID: String = "2"
    static let IOS_NFC_ERROR_TYPE_ID: String =  "21"
    static let INPUT_DATA_FORMAT_ERROR_TYPE_ID: String =  "3"
    static let CARD_RESPONSE_DATA_ERROR_TYPE_ID: String =  "4"
    static let IMPROPER_APPLET_STATE_ERROR_TYPE_ID: String =  "5"
    static let IOS_KEYCHAIN_HMAC_KEY_ERROR_TYPE_ID: String =  "6"
    static let WRONG_CARD_ERROR_TYPE_ID: String = "7"
    
    static let ERROR_TYPE_IDS = [CARD_ERROR_TYPE_ID, SWIFT_INTERNAL_ERROR_TYPE_ID, NFC_INTERRUPTION_TYPE_ID, IOS_NFC_ERROR_TYPE_ID, INPUT_DATA_FORMAT_ERROR_TYPE_ID, CARD_RESPONSE_DATA_ERROR_TYPE_ID, IMPROPER_APPLET_STATE_ERROR_TYPE_ID, IOS_KEYCHAIN_HMAC_KEY_ERROR_TYPE_ID, WRONG_CARD_ERROR_TYPE_ID]
    
    static let CARD_ERROR_TYPE: String =  "CARD_ERROR"
    static let SWIFT_INTERNAL_ERROR_TYPE: String =  "SWIFT_INTERNAL_ERROR"
    static let NFC_INTERRUPTION_TYPE: String =  "NFC_INTERRUPTION_ERROR"
    static let IOS_NFC_ERROR_TYPE: String =  "IOS_NFC_ERROR"
    static let INPUT_DATA_FORMAT_ERROR_TYPE: String =  "INPUT_DATA_FORMAT_ERROR"
    static let CARD_RESPONSE_DATA_ERROR_TYPE: String =  "CARD_RESPONSE_DATA_ERROR"
    static let IMPROPER_APPLET_STATE_ERROR_TYPE: String =  "IMPROPER_APPLET_STATE_ERROR"
    static let HMAC_KEY_ERROR_TYPE: String =  "HMAC_KEY_ERROR"
    static let WRONG_CARD_ERROR_TYPE: String = "WRONG_CARD_ERROR"
    
    static let ERROR_TYPE_NAMES = [CARD_ERROR_TYPE, SWIFT_INTERNAL_ERROR_TYPE, NFC_INTERRUPTION_TYPE, IOS_NFC_ERROR_TYPE, INPUT_DATA_FORMAT_ERROR_TYPE, CARD_RESPONSE_DATA_ERROR_TYPE, IMPROPER_APPLET_STATE_ERROR_TYPE, HMAC_KEY_ERROR_TYPE, WRONG_CARD_ERROR_TYPE]
    
    static let CARD_ERROR_TYPE_MSG: String =  "Applet fail: card operation error"
    static let SWIFT_INTERNAL_ERROR_TYPE_MSG: String =  "Swift code fail: internal error"
    static let NFC_INTERRUPTION_TYPE_MSG = "Native code fail: NFC connection interruption"
    static let IOS_NFC_ERROR_TYPE_MSG: String =  "Swift code fail: NFC error"
    static let INPUT_DATA_FORMAT_ERROR_TYPE_MSG: String =  "Native code fail: incorrect format of input data"
    static let CARD_RESPONSE_DATA_ERROR_TYPE_MSG: String =  "Native code fail: incorrect response from card"
    static let IMPROPER_APPLET_STATE_ERROR_TYPE_MSG: String =  "Native code fail: improper applet state"
    static let IOS_KEYCHAIN_HMAC_KEY_ERROR_TYPE_MSG: String =  "Native code (iOS) fail: hmac key issue"
    static let WRONG_CARD_ERROR_TYPE_MSG: String = "Native code fail: wrong card"
    
    static let ERROR_TYPE_MSGS = [CARD_ERROR_TYPE_MSG, SWIFT_INTERNAL_ERROR_TYPE_MSG, NFC_INTERRUPTION_TYPE_MSG, IOS_NFC_ERROR_TYPE_MSG, INPUT_DATA_FORMAT_ERROR_TYPE_MSG, CARD_RESPONSE_DATA_ERROR_TYPE_MSG, IMPROPER_APPLET_STATE_ERROR_TYPE_MSG, IOS_KEYCHAIN_HMAC_KEY_ERROR_TYPE_MSG, WRONG_CARD_ERROR_TYPE_MSG]
    
    static let errorTypeIdToErrorTypeMsgMap: [String: String] = {
        var map: [String: String] = [:]
        for ind in 0...(ERROR_TYPE_IDS.count - 1) {
            map[ERROR_TYPE_IDS[ind]] = ERROR_TYPE_MSGS[ind]
        }
        return map
    }()
    
    static let errorTypeIdToErrorTypeNameMap: [String: String] = {
        var map: [String: String] = [:]
        for ind in 0...(ERROR_TYPE_IDS.count - 1) {
            map[ERROR_TYPE_IDS[ind]] = ERROR_TYPE_NAMES[ind]
        }
        return map
    }()
    
    /* SWIFT_INTERNAL_ERROR_TYPE_ID = 1
     **/
    static let ERROR_MSG_CARD_OPERATION_EMPTY: String =  "Card operation for ApduRunner is not set."
    
    
    
    static let ERROR_MSG_APDU_EMPTY: String =  "Apdu command is null"
    static let ERROR_MSG_APDU_DATA_FIELD_LEN_INCORRECT: String =  "Datafield in APDU must have length > 0 and <= 255 bytes."
    static let ERROR_MSG_SW_TOO_SHORT: String =  "APDU response bytes are incorrect. It must contain at least 2 bytes of status word (SW) from the card."
    static let ERROR_MSG_APDU_RESPONSE_TOO_LONG: String =  "APDU response is incorrect. Response from the card can not contain > 255 bytes."
    static let ERROR_MSG_PIN_BYTES_SIZE_INCORRECT: String =  "Pin byte array must have length " + String(CommonConstants.PIN_SIZE) + "."
    static let ERROR_MSG_LABEL_BYTES_SIZE_INCORRECT: String =  "Device label byte array must have length " + String(CoinManagerConstants.LABEL_LENGTH) + "."
    static let ERROR_MSG_ACTIVATION_PASSWORD_BYTES_SIZE_INCORRECT: String =  "Activation password byte array must have length " + String(TonWalletAppletConstants.PASSWORD_SIZE) + "."
    static let ERROR_MSG_INITIAL_VECTOR_BYTES_SIZE_INCORRECT: String =  "Initial vector byte array must have length " + String(TonWalletAppletConstants.IV_SIZE) + "."
    static let ERROR_MSG_DATA_BYTES_SIZE_INCORRECT: String =  "Data for signing byte array must have length > 0 and <= " + String(TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE) + "."
    static let ERROR_MSG_DATA_WITH_HD_PATH_BYTES_SIZE_INCORRECT: String =  "Data for signing byte array must have length > 0 and <= " + String(TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH) + "."
    static let ERROR_MSG_APDU_P1_INCORRECT: String =  "APDU parameter P2 must take value from {0, 1, 2}."
    static let ERROR_MSG_KEY_CHUNK_BYTES_SIZE_INCORRECT: String =  "Key (from keyChain) chunk byte array must have length > 0 and <= " + String(TonWalletAppletConstants.DATA_PORTION_MAX_SIZE) + "."
    static let ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT: String =  "Key (from keyChain) mac byte array must have length " + String(TonWalletAppletConstants.HMAC_SHA_SIG_SIZE) + "."
    static let ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT: String =  "Sault byte array must have length " + String(TonWalletAppletConstants.SAULT_LENGTH) + "."
    static let ERROR_MSG_HD_INDEX_BYTES_SIZE_INCORRECT: String =  "hdIndex byte array must have length > 0 and <= " + String(TonWalletAppletConstants.MAX_IND_SIZE) + "."
    static let ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT: String =  "Key (from keyChain) index byte array must have length = " + String(TonWalletAppletConstants.KEYCHAIN_KEY_INDEX_LEN) + "."
    static let ERROR_MSG_APDU_DATA_FIELD_SIZE_INCORRECT: String =  "Data field of APDU command must have length > 0 and <= " + String(TonWalletAppletConstants.APDU_DATA_MAX_SIZE) + "."
    static let ERROR_MSG_KEY_SIZE_BYTE_REPRESENTATION_SIZE_INCORRECT: String =  "Byte array representation of key (from keyChain) size must have length = 2."
    static let ERROR_MSG_START_POS_BYTE_REPRESENTATION_SIZE_INCORRECT: String =  "Byte array representation of start position must have length = 2."
    static let ERROR_MSG_LE_INCORRECT: String =  "Le value must be >= -1 and <= 255."
    
    static let SWIFT_INTERNAL_ERRORS = [ERROR_MSG_CARD_OPERATION_EMPTY,
        
        ERROR_MSG_APDU_EMPTY, ERROR_MSG_APDU_DATA_FIELD_LEN_INCORRECT, ERROR_MSG_SW_TOO_SHORT, ERROR_MSG_APDU_RESPONSE_TOO_LONG,
                                          ERROR_MSG_PIN_BYTES_SIZE_INCORRECT, ERROR_MSG_LABEL_BYTES_SIZE_INCORRECT, ERROR_MSG_ACTIVATION_PASSWORD_BYTES_SIZE_INCORRECT, ERROR_MSG_INITIAL_VECTOR_BYTES_SIZE_INCORRECT,
                                          ERROR_MSG_DATA_BYTES_SIZE_INCORRECT, ERROR_MSG_DATA_WITH_HD_PATH_BYTES_SIZE_INCORRECT, ERROR_MSG_APDU_P1_INCORRECT, ERROR_MSG_KEY_CHUNK_BYTES_SIZE_INCORRECT,
                                          ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT, ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT, ERROR_MSG_HD_INDEX_BYTES_SIZE_INCORRECT, ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT,
                                          ERROR_MSG_APDU_DATA_FIELD_SIZE_INCORRECT,
                                          ERROR_MSG_KEY_SIZE_BYTE_REPRESENTATION_SIZE_INCORRECT,
                                          ERROR_MSG_START_POS_BYTE_REPRESENTATION_SIZE_INCORRECT,
                                          ERROR_MSG_LE_INCORRECT
    ]
    
    
    /**
    * NFC_INTERRUPTION_TYPE_ID = 2
    */
    static let ERROR_NFC_CONNECTION_INTERRUPTED = "Nfc connection was interrupted by user."
    
    static let NFC_INTERRUPTION_ERRORS = [
        ERROR_NFC_CONNECTION_INTERRUPTED
    ]
    
    /**
    * IOS_NFC_ERROR_TYPE_ID = 21
    */
    
    static let ERROR_MSG_NFC_SESSION_IS_NIL: String =  "NFC session is not established (session is empty)."
    static let ERROR_MSG_NFC_TAG_NOT_DETECTED: String =  "NFC Tag is not detected."
    static let ERROR_MSG_NFC_TAG_NOT_CONNECTED: String =  "Can not establish connection with NFC Tag, more details:"
    
    static let IOS_NFC_ERRORS = [
        ERROR_MSG_NFC_SESSION_IS_NIL,
        ERROR_MSG_NFC_TAG_NOT_DETECTED,
        ERROR_MSG_NFC_TAG_NOT_CONNECTED
    ]
    
    
    /**
     * INPUT_DATA_FORMAT_ERROR_TYPE_ID = 3
     */
    static let ERROR_MSG_PASSWORD_LEN_INCORRECT: String =  "Activation password is a hex string of length " + String(2 * TonWalletAppletConstants.PASSWORD_SIZE) + "."
    static let ERROR_MSG_COMMON_SECRET_LEN_INCORRECT: String =  "Common secret is a hex string of length "  + String(2 * TonWalletAppletConstants.COMMON_SECRET_SIZE) + "."
    static let ERROR_MSG_INITIAL_VECTOR_LEN_INCORRECT: String =  "Initial vector is a hex string of length "  + String(2 * TonWalletAppletConstants.IV_SIZE) + "."
    static let ERROR_MSG_PASSWORD_NOT_HEX: String =  "Activation password is not a valid hex string."
    static let ERROR_MSG_COMMON_SECRET_NOT_HEX: String =  "Common secret is not a valid hex string."
    static let ERROR_MSG_INITIAL_VECTOR_NOT_HEX: String =  "Initial vector is not a valid hex string."
    static let ERROR_MSG_PIN_LEN_INCORRECT: String =  "Pin must be a numeric string of length " + String(CommonConstants.PIN_SIZE) + "."
    static let ERROR_MSG_PIN_FORMAT_INCORRECT: String =  "Pin is not a valid numeric string."
    static let ERROR_MSG_DATA_FOR_SIGNING_NOT_HEX: String =  "Data for signing is not a valid hex."
    static let ERROR_MSG_DATA_FOR_SIGNING_LEN_INCORRECT: String =  "Data for signing must be a nonempty hex string of even length > 0 and <= " + String(2 * TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE) + "."
    static let ERROR_MSG_DATA_FOR_SIGNING_WITH_PATH_LEN_INCORRECT: String =  "Data for signing must be a nonempty hex string of even length > 0 and <= " + String(2 * TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH) + "."
    static let ERROR_MSG_RECOVERY_DATA_NOT_HEX: String =  "Recovery data is not a valid hex string."
    static let ERROR_MSG_RECOVERY_DATA_LEN_INCORRECT: String =  "Recovery data is a hex string of length > 0 and <= " + String(2 * TonWalletAppletConstants.RECOVERY_DATA_MAX_SIZE) + "."
    static let ERROR_MSG_HD_INDEX_LEN_INCORRECT: String =  "Hd index must be a numeric string of length > 0 and <= " + String(TonWalletAppletConstants.MAX_IND_SIZE) + "."
    static let ERROR_MSG_HD_INDEX_FORMAT_INCORRECT: String =  "Hd index is not a valid numeric string."
    static let ERROR_MSG_DEVICE_LABEL_LEN_INCORRECT: String =  "Device label must be a hex string of length " + String(2 * CoinManagerConstants.LABEL_LENGTH) + "."
    static let ERROR_MSG_DEVICE_LABEL_NOT_HEX: String =  "Device label is not a valid hex string."
    static let ERROR_MSG_KEY_HMAC_LEN_INCORRECT: String =  "Key hmac is a hex string of length " + String(2 * TonWalletAppletConstants.HMAC_SHA_SIG_SIZE) + "."
    static let ERROR_MSG_KEY_HMAC_NOT_HEX: String =  "Key hmac is not a valid hex string."
    static let ERROR_MSG_KEY_NOT_HEX: String =  "Key is not a valid hex string."
    static let ERROR_MSG_KEY_LEN_INCORRECT: String =  "Key is a hex string of length > 0 and <= " + String(2 * TonWalletAppletConstants.MAX_KEY_SIZE_IN_KEYCHAIN) + "."
    static let ERROR_MSG_KEY_SIZE_INCORRECT: String =  "Key size must be > 0 and <= " + String(TonWalletAppletConstants.MAX_KEY_SIZE_IN_KEYCHAIN) + "."
    static let ERROR_MSG_NEW_KEY_LEN_INCORRECT: String =  "Length of new key must be equal to length of old key "
    static let ERROR_MSG_KEY_INDEX_VALUE_INCORRECT: String =  "Key index is a numeric string representing integer >= 0 and <= " + String(TonWalletAppletConstants.MAX_NUMBER_OF_KEYS_IN_KEYCHAIN - 1) + "."
    static let ERROR_MSG_KEY_INDEX_STRING_NOT_NUMERIC: String =  "Key index is not a valid numeric string."
    static let ERROR_MSG_SERIAL_NUMBER_LEN_INCORRECT: String =  "Serial number is a numeric string of length "  + String(TonWalletAppletConstants.SERIAL_NUMBER_SIZE) + "."
    static let ERROR_MSG_SERIAL_NUMBER_NOT_NUMERIC: String =  "Serial number is not a valid numeric string."
    
    static let INPUT_DATA_FORMAT_ERRORS = [
        ERROR_MSG_PASSWORD_LEN_INCORRECT,
        ERROR_MSG_COMMON_SECRET_LEN_INCORRECT,
        ERROR_MSG_INITIAL_VECTOR_LEN_INCORRECT,
        ERROR_MSG_PASSWORD_NOT_HEX,
        ERROR_MSG_COMMON_SECRET_NOT_HEX,
        ERROR_MSG_INITIAL_VECTOR_NOT_HEX,
        ERROR_MSG_PIN_LEN_INCORRECT,
        ERROR_MSG_PIN_FORMAT_INCORRECT,
        ERROR_MSG_DATA_FOR_SIGNING_NOT_HEX,
        ERROR_MSG_DATA_FOR_SIGNING_LEN_INCORRECT,
        ERROR_MSG_DATA_FOR_SIGNING_WITH_PATH_LEN_INCORRECT,
        ERROR_MSG_RECOVERY_DATA_NOT_HEX,
        ERROR_MSG_RECOVERY_DATA_LEN_INCORRECT,
        ERROR_MSG_HD_INDEX_LEN_INCORRECT,
        ERROR_MSG_HD_INDEX_FORMAT_INCORRECT,
        ERROR_MSG_DEVICE_LABEL_LEN_INCORRECT,
        ERROR_MSG_DEVICE_LABEL_NOT_HEX,
        ERROR_MSG_KEY_HMAC_LEN_INCORRECT,
        ERROR_MSG_KEY_HMAC_NOT_HEX,
        ERROR_MSG_KEY_NOT_HEX,
        ERROR_MSG_KEY_LEN_INCORRECT,
        ERROR_MSG_KEY_SIZE_INCORRECT,
        ERROR_MSG_NEW_KEY_LEN_INCORRECT,
        ERROR_MSG_KEY_INDEX_VALUE_INCORRECT,
        ERROR_MSG_KEY_INDEX_STRING_NOT_NUMERIC,
        ERROR_MSG_SERIAL_NUMBER_LEN_INCORRECT,
        ERROR_MSG_SERIAL_NUMBER_NOT_NUMERIC
    ]
    
    /**
     * CARD_RESPONSE_DATA_ERROR_TYPE_ID = 4
     */
    static let ERROR_MSG_SAULT_RESPONSE_LEN_INCORRECT: String =  "Sault response from card must have length " + String(TonWalletAppletConstants.SAULT_LENGTH) + ". Current length is "
    static let ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT: String =  "Applet state response from card must have length 1. Current length is "
    static let ERROR_MSG_STATE_RESPONSE_INCORRECT: String =  "Unknown applet state = " //todo: not used yet
    static let ERROR_MSG_RECOVERY_DATA_HASH_RESPONSE_LEN_INCORRECT: String =  "Recovery data hash must have length " + String(TonWalletAppletConstants.SHA_HASH_SIZE) + "."
    static let ERROR_MSG_RECOVERY_DATA_LENGTH_RESPONSE_LEN_INCORRECT: String =  "Recovery data length byte array must have length 2."
    static let ERROR_MSG_RECOVERY_DATA_LENGTH_RESPONSE_INCORRECT: String =  "Recovery data length must be > 0 and <= " + String(TonWalletAppletConstants.RECOVERY_DATA_MAX_SIZE) + "."
    static let ERROR_IS_RECOVERY_DATA_SET_RESPONSE_LEN_INCORRECT: String =  "Response from IS_RECOVERY_DATA_SET card operation must have length 1."
    static let ERROR_RECOVERY_DATA_PORTION_INCORRECT_LEN = "Recovery data portion must have length = ";
    static let ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_LEN_INCORRECT: String =  "Hash of encrypted password must have length " + String(TonWalletAppletConstants.SHA_HASH_SIZE) + "."
    static let ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_LEN_INCORRECT: String =  "Hash of encrypted common secret must have length " + String(TonWalletAppletConstants.SHA_HASH_SIZE) + "."
    static let ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_INCORRECT: String =  "Card two-factor authorization failed: Hash of encrypted common secret is invalid."
    static let ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_INCORRECT: String =  "Card two-factor authorization failed: Hash of encrypted password is invalid."
    static let ERROR_MSG_SIG_RESPONSE_LEN_INCORRECT: String =  "Signature must have length " + String(TonWalletAppletConstants.SIG_LEN) + "."
    static let ERROR_MSG_PUBLIC_KEY_RESPONSE_LEN_INCORRECT: String =  "Public key must have length " + String(TonWalletAppletConstants.PK_LEN) + "."
    static let ERROR_MSG_GET_NUMBER_OF_KEYS_RESPONSE_LEN_INCORRECT: String =  "Response from GET_NUMBER_OF_KEYS card operation must have length " + String(TonWalletAppletConstants.GET_NUMBER_OF_KEYS_LE) + "."
    static let ERROR_MSG_NUMBER_OF_KEYS_RESPONSE_INCORRECT: String = "Number of keys in keychain must be > 0 and <= " + String(TonWalletAppletConstants.MAX_NUMBER_OF_KEYS_IN_KEYCHAIN) + "."
    static let ERROR_MSG_GET_OCCUPIED_SIZE_RESPONSE_LEN_INCORRECT: String = "Response from GET_OCCUPIED_SIZE card operation must have length " + String(TonWalletAppletConstants.GET_NUMBER_OF_KEYS_LE) + "."
    static let ERROR_MSG_GET_FREE_SIZE_RESPONSE_LEN_INCORRECT: String = "Response from GET_FREE_SIZE_RESPONSE card operation must have length " + String(TonWalletAppletConstants.GET_NUMBER_OF_KEYS_LE) + "."
    static let ERROR_MSG_OCCUPIED_SIZE_RESPONSE_INCORRECT: String = "Occupied size in keychain can not be negative."
    static let ERROR_MSG_FREE_SIZE_RESPONSE_INCORRECT: String = "Free size in keychain can not be negative."
    static let ERROR_MSG_GET_KEY_INDEX_IN_STORAGE_AND_LEN_RESPONSE_LEN_INCORRECT: String =  "Response from GET_KEY_INDEX_IN_STORAGE_AND_LEN card operation must have length " + String(TonWalletAppletConstants.GET_KEY_INDEX_IN_STORAGE_AND_LEN_LE) + "."
    static let ERROR_MSG_KEY_INDEX_INCORRECT: String = "Key index must be >= 0 and <= " + String(TonWalletAppletConstants.MAX_NUMBER_OF_KEYS_IN_KEYCHAIN - 1) + "."
    static let ERROR_MSG_KEY_LENGTH_INCORRECT: String = "Key length (in keychain) must be > 0 and <= " + String(TonWalletAppletConstants.MAX_KEY_SIZE_IN_KEYCHAIN) + "."
    static let ERROR_MSG_DELETE_KEY_CHUNK_RESPONSE_LEN_INCORRECT: String = "Response from DELETE_KEY_CHUNK card operation must have length " + String(TonWalletAppletConstants.DELETE_KEY_CHUNK_LE) + "."
    static let ERROR_MSG_DELETE_KEY_CHUNK_RESPONSE_INCORRECT: String = "Response from DELETE_KEY_CHUNK card operation must have value 0 or 1."
    static let ERROR_MSG_DELETE_KEY_RECORD_RESPONSE_LEN_INCORRECT: String = "Response from DELETE_KEY_RECORD card operation must have length " + String(TonWalletAppletConstants.DELETE_KEY_RECORD_LE) + "."
    static let ERROR_MSG_DELETE_KEY_RECORD_RESPONSE_INCORRECT: String = "Response from DELETE_KEY_RECORD card operation must have value 0 or 1."
    static let ERROR_MSG_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_RESPONSE_LEN_INCORRECT: String = "Response from GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS card operation must have length " + String(TonWalletAppletConstants.GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_LE) + "."
    static let ERROR_MSG_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_RESPONSE_INCORRECT: String = "Response from GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS card operation can not be negative."
    static let ERROR_MSG_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_RESPONSE_LEN_INCORRECT: String =  "Response from GET_DELETE_KEY_RECORD card operation must have length " + String(TonWalletAppletConstants.GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_LE) + "."
    static let ERROR_MSG_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_RESPONSE_INCORRECT = "Response from GET_DELETE_KEY_RECORD_NUM_OF_PACKETS card operation can not be negative."
    static let ERROR_MSG_NUM_OF_KEYS_INCORRECT_AFTER_ADD: String = "After ADD_KEY card operation number of keys must be increased by 1."
    static let ERROR_MSG_NUM_OF_KEYS_INCORRECT_AFTER_CHANGE: String = "After CHANGE_KEY card operation number of keys must not be changed."
    static let ERROR_MSG_SEND_CHUNK_RESPONSE_LEN_INCORRECT: String = "Response from SEND_CHUNK card operation must have length " + String(TonWalletAppletConstants.SEND_CHUNK_LE) + "."
    static let ERROR_MSG_GET_HMAC_RESPONSE_LEN_INCORRECT: String = "Hash of key (from keychain) must have length " + String(TonWalletAppletConstants.SHA_HASH_SIZE) + "."
    static let ERROR_MSG_INITIATE_DELETE_KEY_RESPONSE_LEN_INCORRECT: String = "Response from INITIATE_DELETE_KEY card operation must have length " + String(TonWalletAppletConstants.INITIATE_DELETE_KEY_LE) + "."
    static let ERROR_KEY_DATA_PORTION_INCORRECT_LEN = "Key data portion must have length = "
    static let ERROR_MSG_GET_SERIAL_NUMBER_RESPONSE_LEN_INCORRECT: String = "Response from GET_SERIAL_NUMBER number must have length " + String(TonWalletAppletConstants.SERIAL_NUMBER_SIZE) + "."
    static let ERROR_MSG_GET_PIN_TLT_OR_RTL_RESPONSE_LEN_INCORRECT: String = "Response from GET_PIN_TLT (GET_PIN_RTL) must have length > 0."
    static let ERROR_MSG_GET_PIN_TLT_OR_RTL_RESPONSE_VAL_INCORRECT: String = "Response from GET_PIN_TLT (GET_PIN_RTL) must have value >= 0 and <= " + String(CoinManagerConstants.MAX_PIN_TRIES) + "."
    static let ERROR_MSG_GET_ROOT_KEY_STATUS_RESPONSE_LEN_INCORRECT: String = "Response from GET_ROOT_KEY_STATUS must have length > 0."
    static let ERROR_MSG_GET_DEVICE_LABEL_RESPONSE_LEN_INCORRECT: String = "Response from GET_DEVICE_LABEL must have length = " + String(CoinManagerConstants.LABEL_LENGTH) + "."
    static let ERROR_MSG_GET_CSN_RESPONSE_LEN_INCORRECT: String = "Response from GET_CSN_VERSION must have length > 0."
    static let ERROR_MSG_GET_SE_VERSION_RESPONSE_LEN_INCORRECT: String = "Response from GET_SE_VERSION must have length > 0."
    static let ERROR_MSG_GET_AVAILABLE_MEMORY_RESPONSE_LEN_INCORRECT: String = "Response from GET_AVAILABLE_MEMORY must have length > 0."
    static let ERROR_MSG_GET_APPLET_LIST_RESPONSE_LEN_INCORRECT: String = "Response from GET_APPLET_LIST must have length > 0."
    
    static let CARD_RESPONSE_DATA_ERRORS = [
        ERROR_MSG_SAULT_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_STATE_RESPONSE_INCORRECT,
        ERROR_MSG_RECOVERY_DATA_HASH_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_RECOVERY_DATA_LENGTH_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_RECOVERY_DATA_LENGTH_RESPONSE_INCORRECT,
        ERROR_IS_RECOVERY_DATA_SET_RESPONSE_LEN_INCORRECT,
        ERROR_RECOVERY_DATA_PORTION_INCORRECT_LEN, 
        ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_INCORRECT,
        ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_INCORRECT,
        ERROR_MSG_SIG_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_PUBLIC_KEY_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_NUMBER_OF_KEYS_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_NUMBER_OF_KEYS_RESPONSE_INCORRECT,
        ERROR_MSG_GET_OCCUPIED_SIZE_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_FREE_SIZE_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_OCCUPIED_SIZE_RESPONSE_INCORRECT,
        ERROR_MSG_FREE_SIZE_RESPONSE_INCORRECT,
        ERROR_MSG_GET_KEY_INDEX_IN_STORAGE_AND_LEN_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_KEY_INDEX_INCORRECT,
        ERROR_MSG_KEY_LENGTH_INCORRECT,
        ERROR_MSG_DELETE_KEY_CHUNK_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_DELETE_KEY_CHUNK_RESPONSE_INCORRECT,
        ERROR_MSG_DELETE_KEY_RECORD_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_DELETE_KEY_RECORD_RESPONSE_INCORRECT,
        ERROR_MSG_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_RESPONSE_INCORRECT,
        ERROR_MSG_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_RESPONSE_INCORRECT,
        ERROR_MSG_NUM_OF_KEYS_INCORRECT_AFTER_ADD,
        ERROR_MSG_NUM_OF_KEYS_INCORRECT_AFTER_CHANGE,
        ERROR_MSG_SEND_CHUNK_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_HMAC_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_INITIATE_DELETE_KEY_RESPONSE_LEN_INCORRECT,
        ERROR_KEY_DATA_PORTION_INCORRECT_LEN,
        ERROR_MSG_GET_SERIAL_NUMBER_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_PIN_TLT_OR_RTL_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_PIN_TLT_OR_RTL_RESPONSE_VAL_INCORRECT,
        ERROR_MSG_GET_ROOT_KEY_STATUS_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_DEVICE_LABEL_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_CSN_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_SE_VERSION_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_AVAILABLE_MEMORY_RESPONSE_LEN_INCORRECT,
        ERROR_MSG_GET_APPLET_LIST_RESPONSE_LEN_INCORRECT
    ]
    
    /**
     * IMPROPER_APPLET_STATE_ERROR_TYPE_ID = 5
     */
    static let ERROR_MSG_APDU_NOT_SUPPORTED: String = "APDU command is not supported" 
    static let ERROR_MSG_APPLET_DOES_NOT_WAIT_AUTHORIZATION: String = "Applet must be in mode that waits authorization. Now it is: "
    static let ERROR_MSG_APPLET_IS_NOT_PERSONALIZED: String = "Applet must be in personalized mode. Now it is: "
    static let ERROR_MSG_APPLET_DOES_NOT_WAIT_TO_DELETE_KEY: String = "Applet must be in mode for deleting key. Now it is: "
    
    static let IMPROPER_APPLET_STATE_ERRORS = [
        ERROR_MSG_APDU_NOT_SUPPORTED,
        ERROR_MSG_APPLET_DOES_NOT_WAIT_AUTHORIZATION,
        ERROR_MSG_APPLET_IS_NOT_PERSONALIZED,
        ERROR_MSG_APPLET_DOES_NOT_WAIT_TO_DELETE_KEY
    ]
    
    /**
     *IOS_KEYCHAIN_HMAC_KEY_ERROR_TYPE_ID = 6
     */
    static let ERROR_MSG_KEY_FOR_HMAC_DOES_NOT_EXIST_IN_IOS_KEYCHAIN: String = "Key for hmac signing for specified serial number does not exist."
    static let ERROR_MSG_CURRENT_SERIAL_NUMBER_IS_NOT_SET_IN_IOS_KEYCHAIN: String = "Current serial number is not set. Can not select key for hmac."
    static let ERROR_MSG_UNABLE_RETRIEVE_ANY_KEY_FROM_IOS_KEYCHAIN: String = "Unable to retrieve any key from keychain."
    static let ERROR_MSG_UNABLE_RETRIEVE_KEY_INFO_FROM_IOS_KEYCHAIN: String =  "Unable to retrieve info about key from keychain."
    static let ERROR_MSG_UNABLE_SAVE_KEY_INTO_IOS_KEYCHAIN: String =  "Unable to save key into keychain."
    static let ERROR_MSG_UNABLE_DELETE_KEY_FROM_IOS_KEYCHAIN: String =  "Unable to delete key from keychain."
    static let ERROR_MSG_UNABLE_UPDATE_KEY_IN_IOS_KEYCHAIN: String =  "Unable to update key in keychain."
    
    
    static let IOS_KEYCHAIN_HMAC_KEY_ERRORS = [
        ERROR_MSG_KEY_FOR_HMAC_DOES_NOT_EXIST_IN_IOS_KEYCHAIN,
        ERROR_MSG_CURRENT_SERIAL_NUMBER_IS_NOT_SET_IN_IOS_KEYCHAIN,
        ERROR_MSG_UNABLE_RETRIEVE_ANY_KEY_FROM_IOS_KEYCHAIN,
        ERROR_MSG_UNABLE_RETRIEVE_KEY_INFO_FROM_IOS_KEYCHAIN,
        ERROR_MSG_UNABLE_SAVE_KEY_INTO_IOS_KEYCHAIN,
        ERROR_MSG_UNABLE_DELETE_KEY_FROM_IOS_KEYCHAIN,
        ERROR_MSG_UNABLE_UPDATE_KEY_IN_IOS_KEYCHAIN
    ]
    
    /**
    * WRONG_CARD_ERROR_TYPE_ID = 7
    */

    static let ERROR_MSG_CARD_HAVE_INCORRECT_SN: String =  "You try to use security card with incorrect serial number. "
    
    static let WRONG_CARD_ERRORS = [
        ERROR_MSG_CARD_HAVE_INCORRECT_SN
    ]
    
    static let ALL_NATIVE_ERROR_MESSAGES = [
        SWIFT_INTERNAL_ERRORS,
        NFC_INTERRUPTION_ERRORS,
        IOS_NFC_ERRORS,
        INPUT_DATA_FORMAT_ERRORS,
        CARD_RESPONSE_DATA_ERRORS,
        IMPROPER_APPLET_STATE_ERRORS,
        IOS_KEYCHAIN_HMAC_KEY_ERRORS,
        WRONG_CARD_ERRORS
    ]
    
    static let errorMsgsToErrorTypeIdMap: [[String] : String] = {
        var map: [[String] : String] = [:]
        for ind in 0...(ALL_NATIVE_ERROR_MESSAGES.count - 1) {
            map[ALL_NATIVE_ERROR_MESSAGES[ind]] = ERROR_TYPE_IDS[ind + 1]
        }
        return map
    }()
    
    static let errorMsgToErrorCodeMap : [String : String] = {
        var map: [String : String] = [:]
        for i in 0...(ALL_NATIVE_ERROR_MESSAGES.count - 1) {
            let errMsgsArray = ALL_NATIVE_ERROR_MESSAGES[i]
            let errTypeId = errorMsgsToErrorTypeIdMap[errMsgsArray]!
            print(errTypeId)
            for ind in 0...(errMsgsArray.count - 1) {
                let errMsg = errMsgsArray[ind]
                let index = String(ind)
                let numOfZeros = 4 - index.count
                let zeros = String(repeating: "0", count: numOfZeros)
                let errCode = errTypeId + zeros + index
                map[errMsg] = errCode
            }
        }
        return map
    }()
    
    
    static func getErrorTypeMsg(typeId : String) -> String? {
        return errorTypeIdToErrorTypeMsgMap[typeId]
    }
    
    static func getErrorTypeName(typeId : String) -> String? {
        return errorTypeIdToErrorTypeNameMap[typeId]
    }
    
    static func getErrorCode(errMsg : String) -> String? {
        if let ec = errorMsgToErrorCodeMap[errMsg] {
            return ec
        }
        else {
            for key in errorMsgToErrorCodeMap.keys {
                if (errMsg.hasPrefix(key)) {
                    return errorMsgToErrorCodeMap[key]
                }
            }
        }
        return nil
    }
    
    static func getErrorType(errMsg : String) -> String? {
        if let ec = errorMsgToErrorCodeMap[errMsg] {
            return String(ec.substring(with: 0..<1))
        }
        else {
            for key in errorMsgToErrorCodeMap.keys {
                if (errMsg.hasPrefix(key)) {
                    return String(errorMsgToErrorCodeMap[key]!.substring(with: 0..<1))
                }
            }
        }
        return nil
    }
    
    
}
