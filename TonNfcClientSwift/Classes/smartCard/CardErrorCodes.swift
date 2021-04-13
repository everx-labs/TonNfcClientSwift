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

class CardErrorCodes {
  
  /* Standard status words that may be returned by any Java card */
  
  static let SW_SUCCESS  :UInt16 =  0x9000;
  static let SW_WRONG_LENGTH  :UInt16 =  0x6700;
  static let SW_APPLET_SELECT_FAILED   :UInt16 =  0x6999;
  static let SW_RESPONSE_BYTES_REMAINING   :UInt16 =  0x6100;
  static let SW_CLA_NOT_SUPPORTED   :UInt16 =  0x6E00;
  static let SW_COMMAND_CHAINING_NOT_SUPPORTED   :UInt16 =  0x6884;
  static let SW_COMMAND_NOT_ALLOWED   :UInt16 =  0x6986;
  static let SW_CONDITIONS_OF_USE_NOT_SATISFIED   :UInt16 =  0x6985;
  static let SW_CORRECT_EXPECTED_LENGTH   :UInt16 =  0x6C00;
  static let SW_DATA_INVALID   :UInt16 =  0x6984;
  static let SW_NOT_ENOUGH_MEMORY_SPACE_IN_FILE   :UInt16 =  0x6A84;
  static let SW_FILE_INVALID   :UInt16 =  0x6983;
  static let SW_FILE_NOT_FOUND  :UInt16 =  0x6A82;
  static let SW_FUNCTION_NOT_SUPPORTED  :UInt16 =  0x6A81;
  static let SW_INCORRECT_P1_P2  :UInt16 =  0x6A86;
  static let SW_INS_NOT_SUPPORTED  :UInt16 =  0x6D00;
  /*static let SW_LAST_COMMAND_IN_CHAIN_EXPECTED  :UInt16 =  0x6883;*/
  static let SW_LOGICAL_CHANNEL_NOT_SUPPORTED  :UInt16 =  0x6881;
  static let SW_RECORD_NOT_FOUND  :UInt16 =  0x6883;
  static let SW_SECURE_MESSAGING_NOT_SUPPORTED  :UInt16 =  0x6882;
  static let SW_SECURITY_CONDITION_NOT_SATISFIED  :UInt16 =  0x6982;
  static let SW_COMMAND_ABORTED :UInt16 =  0x6F00;
  static let SW_WRONG_DATA :UInt16 =  0x6A80;
  static let SW_WRONG_P1_P2  :UInt16 =  0x6B00;
  
  
  /* Status words that may be returned by TonWalletApplet */
  
  // Common errors
  static let SW_INTERNAL_BUFFER_IS_NULL_OR_TOO_SMALL  :UInt16 =  0x4F00;
  static let SW_PERSONALIZATION_NOT_FINISHED  :UInt16 =  0x4F01;
  static let SW_INCORRECT_OFFSET :UInt16 =  0x4F02;
  static let SW_INCORRECT_PAYLOAD :UInt16 =  0x4F03;
  
  // Password authentication errors
  static let SW_INCORRECT_PASSWORD_FOR_CARD_AUTHENICATION   :UInt16 =  0x5F00;
  static let SW_INCORRECT_PASSWORD_CARD_IS_BLOCKED   :UInt16 =  0x5F01;
  
  // Signature errors
  static let SW_SET_COIN_TYPE_FAILED :UInt16 =  0x6F01;
  static let SW_SET_CURVE_FAILED :UInt16 =  0x6F02;
  static let SW_GET_COIN_PUB_DATA_FAILED :UInt16 =  0x6F03;
  static let SW_SIGN_DATA_FAILED :UInt16 =  0x6F04;
  
  // Pin verification errors
  static let SW_COIN_MANAGER_INCORRECT_PIN :UInt16 =  0x9B01;
  static let SW_COIN_MANAGER_UPDATE_PIN_ERROR :UInt16 =  0x9B02;
  // static let SW_PIN_TRIES_EXPIRED :UInt16 =  0x9F08;
  static let SW_INCORRECT_PIN :UInt16 =  0x6F07;
  static let SW_PIN_TRIES_EXPIRED :UInt16 =  0x6F08;
  
  static let SW_LOAD_SEED_ERROR :UInt16 =  0x9F03;
  
  // Key chain errors
  static let SW_INCORRECT_KEY_INDEX  :UInt16 =  0x7F00;
  static let SW_INCORRECT_KEY_CHUNK_START_OR_LEN  :UInt16 =  0x7F01;
  static let SW_INCORRECT_KEY_CHUNK_LEN  :UInt16 =  0x7F02;
  static let SW_NOT_ENOUGH_SPACE :UInt16 =  0x7F03;
  static let SW_KEY_SIZE_UNKNOWN  :UInt16 =  0x7F04;
  static let SW_KEY_LEN_INCORRECT  :UInt16 =  0x7F05;
  static let SW_HMAC_EXISTS   :UInt16 =  0x7F06;
  static let SW_INCORRECT_KEY_INDEX_TO_CHANGE  :UInt16 =  0x7F07;
  static let SW_MAX_KEYS_NUMBER_EXCEEDED  :UInt16 =  0x7F08;
  static let SW_DELETE_KEY_CHUNK_IS_NOT_FINISHED  :UInt16 =  0x7F09;
  
  // Hmac errors
  static let SW_INCORRECT_SAULT   :UInt16 =  0x8F01;
  static let SW_DATA_INTEGRITY_CORRUPTED  :UInt16 =  0x8F02;
  static let SW_INCORRECT_APDU_HMAC  :UInt16 =  0x8F03;
  static let SW_HMAC_VERIFICATION_TRIES_EXPIRED   :UInt16 =  0x8F04;
    
    // Recovery errors
  static let SW_RECOVERY_DATA_TOO_LONG :UInt16 =  0x6F09;
  static let SW_INCORRECT_START_POS_OR_LE :UInt16 =  0x6F0A;
  static let SW_INTEGRITY_OF_RECOVERY_DATA_CORRUPTED :UInt16 =  0x6F0B;
  static let SW_RECOVERY_DATA_ALREADY_EXISTS :UInt16 =  0x6F0C;
  static let SW_RECOVERY_DATA_IS_NOT_SET:UInt16 = 0x6F0D;
    
  static func convertSw1Sw2IntoOneSw(sw1 : UInt8, sw2 : UInt8) -> Int {
    Int(256) * Int(sw1) + Int(sw2)
  }
  
  static let CARD_ERROR_MSGS = [SW_SUCCESS: "No error.",
                                SW_APPLET_SELECT_FAILED : "Applet select failed.",
                                SW_RESPONSE_BYTES_REMAINING : "Response bytes remaining.",
                                SW_CLA_NOT_SUPPORTED : "CLA value not supported.",
                                SW_COMMAND_CHAINING_NOT_SUPPORTED : "Command chaining not supported.",
                                SW_COMMAND_NOT_ALLOWED : "Command not allowed (no current EF).",
                                SW_CONDITIONS_OF_USE_NOT_SATISFIED : "Conditions of use not satisﬁed.",
                                SW_CORRECT_EXPECTED_LENGTH : "Correct Expected Length (Le).",
                                SW_DATA_INVALID : "Data invalid.",
                                SW_NOT_ENOUGH_MEMORY_SPACE_IN_FILE : "Not enough memory space in the ﬁle.",
                                SW_FILE_INVALID : "File invalid.",
                                SW_FILE_NOT_FOUND : "File not found.",
                                SW_FUNCTION_NOT_SUPPORTED : "Function not supported.",
                                SW_INCORRECT_P1_P2 : "Incorrect parameters (P1,P2).",
                                SW_INS_NOT_SUPPORTED : "INS value not supported.",
                                /* SW_LAST_COMMAND_IN_CHAIN_EXPECTED : "Last command in chain expected.",*/
    SW_LOGICAL_CHANNEL_NOT_SUPPORTED : "Card does not support the operation on the speciﬁed logical channel.",
    SW_RECORD_NOT_FOUND : "Record not found.",
    SW_SECURE_MESSAGING_NOT_SUPPORTED : "Card does not support secure messaging.",
    SW_SECURITY_CONDITION_NOT_SATISFIED : "Security condition not satisﬁed.",
    SW_COMMAND_ABORTED : "Command aborted, No precise diagnosis.",
    SW_WRONG_DATA : "Wrong data.",
    SW_WRONG_LENGTH : "Wrong length.",
    SW_WRONG_P1_P2 : "Wrong parameter(s) P1-P2",
    
    SW_INTERNAL_BUFFER_IS_NULL_OR_TOO_SMALL : "Internal buffer is null or too small.",
    SW_PERSONALIZATION_NOT_FINISHED : "Personalization is not finished.",
    SW_INCORRECT_OFFSET : "Internal error: incorrect offset.",
    SW_INCORRECT_PAYLOAD : "Internal error: incorrect payload value.",
    SW_INCORRECT_PASSWORD_FOR_CARD_AUTHENICATION : "Incorrect password for card authentication.",
    SW_INCORRECT_PASSWORD_CARD_IS_BLOCKED : "Incorrect password, card is locked.",
    SW_SET_COIN_TYPE_FAILED : "Set coin type failed.",
    SW_SET_CURVE_FAILED : "Set curve failed.",
    SW_GET_COIN_PUB_DATA_FAILED : "Get coin pub data failed.",
    SW_SIGN_DATA_FAILED : "Sign data failed.",
    SW_INCORRECT_PIN : "Incorrect PIN.",
    SW_COIN_MANAGER_INCORRECT_PIN : "Incorrect PIN.",
    SW_COIN_MANAGER_UPDATE_PIN_ERROR : "Update PIN error (for CHANGE_PIN) or wallet status not support to export (for GENERATE SEED).",
    SW_PIN_TRIES_EXPIRED : "PIN tries expired.",
    SW_LOAD_SEED_ERROR : "Load seed error.",
    SW_INCORRECT_KEY_INDEX : "Incorrect key index.",
    SW_INCORRECT_KEY_CHUNK_START_OR_LEN : "Incorrect key chunk start or length.",
    SW_INCORRECT_KEY_CHUNK_LEN : "Incorrect key chunk length.",
    SW_NOT_ENOUGH_SPACE : "Not enough space.",
    SW_KEY_SIZE_UNKNOWN : "Key size unknown.",
    SW_KEY_LEN_INCORRECT : "Key length incorrect.",
    SW_HMAC_EXISTS : "Hmac exists already.",
    SW_INCORRECT_KEY_INDEX_TO_CHANGE: "Incorrect key index to change.",
    SW_MAX_KEYS_NUMBER_EXCEEDED : "Max number of keys (1023) is exceeded.",
    SW_DELETE_KEY_CHUNK_IS_NOT_FINISHED : "Delete key chunk is not finished.",
    SW_INCORRECT_SAULT : "Incorrect sault.",
    SW_DATA_INTEGRITY_CORRUPTED : "Data integrity corrupted.",
    SW_INCORRECT_APDU_HMAC : "Incorrect apdu hmac. ",
    SW_HMAC_VERIFICATION_TRIES_EXPIRED : "Apdu Hmac verification tries expired.",
    SW_RECOVERY_DATA_TOO_LONG : "Too big length of recovery data.",
    SW_INCORRECT_START_POS_OR_LE : "Incorrect start or length of recovery data piece in internal buffer.",
    SW_INTEGRITY_OF_RECOVERY_DATA_CORRUPTED : "Hash of recovery data is incorrect. ",
    SW_RECOVERY_DATA_ALREADY_EXISTS : "Recovery data already exists.",
    SW_RECOVERY_DATA_IS_NOT_SET : "Recovery data does not exist"
  ]
    
    static func getErrorMsg(sw : UInt16) -> String? {
        return CARD_ERROR_MSGS[sw]
    }
  
}
