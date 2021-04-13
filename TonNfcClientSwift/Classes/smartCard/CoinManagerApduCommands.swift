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
class CoinManagerApduCommands {

  static let CURVE_TYPE_SUFFIX = "0102"
  static let CLA:UInt8 = 0x80
  static let INS:UInt8 = 0xCB
  static let P1:UInt8 = 0x80
  static let P2:UInt8 = 0x00
  static let GET_ROOT_KEY_STATUS_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x05]
  static let GET_APPS_APDU_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x06]
  static let GET_PIN_RTL_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x02]
  static let GET_PIN_TLT_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x03]
  static let RESET_WALLET_APDU_BYTES :[UInt8] =  [0xDF, 0xFE, 0x02, 0x82, 0x05]
  static let GET_SE_VERSION_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x09]
  static let GET_CSN_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x01]
  static let GET_DEVICE_LABEL_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x04]
  static let SET_DEVICE_LABEL_BYTES :[UInt8] =  [0xDF, 0xFE, 0x23, 0x81, 0x04]
  static let GET_AVAILABLE_MEMORY_BYTES :[UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x46]
  static let GENERATE_SEED_BYTES :[UInt8] =  [0xDF, 0xFE, 0x08, 0x82, 0x03, 0x05]
  static let CHANGE_PIN_BYTES :[UInt8] =  [0xDF, 0xFE, 0x0D, 0x82, 0x04, 0x0A]
  
  static let APDU_COMMAND_NAMES = [
    SD_AID: "SELECT_COIN_MANAGER",
    GET_ROOT_KEY_STATUS_BYTES: "GET_ROOT_KEY_STATUS",
    GET_APPS_APDU_BYTES: "GET_APPS",
    GET_PIN_RTL_BYTES: "GET_PIN_RTL",
    GET_PIN_TLT_BYTES: "GET_PIN_TLT",
    RESET_WALLET_APDU_BYTES: "RESET_WALLET_APDU",
    GET_SE_VERSION_BYTES: "GET_SE_VERSION",
    GET_CSN_BYTES: "GET_CSN",
    GET_DEVICE_LABEL_BYTES: "GET_DEVICE_LABEL",
    SET_DEVICE_LABEL_BYTES: "SET_DEVICE_LABEL",
    GET_AVAILABLE_MEMORY_BYTES: "GET_AVAILABLE_MEMORY",
    GENERATE_SEED_BYTES: "GENERATE_SEED",
    CHANGE_PIN_BYTES: "CHANGE_PIN"
  ]
  
  static func getApduName(apdu: NFCISO7816APDU) -> String? {
    for array in CoinManagerApduCommands.APDU_COMMAND_NAMES.keys {
      if let data = apdu.data {
        let num = data.count >= array.count ? array.count : data.count
        //   print(data.prefix(upTo: num).bytes)
        if data.prefix(upTo: num) == Data(_ : array) {
          return CoinManagerApduCommands.APDU_COMMAND_NAMES[array]
        }
      }
    }
    return nil
  }
  
  static let SD_AID: [UInt8] = [0xA0, 0x00, 0x00, 0x01, 0x51, 0x00, 0x00, 0x00]
  
  static let SELECT_COIN_MANAGER_APDU = NFCISO7816APDU(instructionClass:0x00, instructionCode:0xA4, p1Parameter:0x04, p2Parameter:0x00, data: Data(_ : SD_AID), expectedResponseLength:-1) // "00A40400"
  
  static let GET_SE_VERSION_APDU =  NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_SE_VERSION_BYTES), expectedResponseLength:256)
  
  static let GET_CSN_APDU =  NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_CSN_BYTES), expectedResponseLength:256)
  
  static let GET_DEVICE_LABEL_APDU = NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_DEVICE_LABEL_BYTES), expectedResponseLength:256)
  
  static let GET_PIN_TLT_APDU = NFCISO7816APDU  (instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_PIN_TLT_BYTES), expectedResponseLength:256) // "80CB800005DFFF028103" get retry maximum times of PIN
  
  static let GET_PIN_RTL_APDU = NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_PIN_RTL_BYTES), expectedResponseLength:256) // "80CB800005DFFF028102" get remaining retry times of PIN
  
  static let GET_ROOT_KEY_STATUS_APDU = NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_ROOT_KEY_STATUS_BYTES), expectedResponseLength:256) // "80CB800005DFFF028105"
  
  static let GET_AVAILABLE_MEMORY_APDU = NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_AVAILABLE_MEMORY_BYTES), expectedResponseLength:256)
  
  static let GET_APPLET_LIST_APDU = NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GET_APPS_APDU_BYTES), expectedResponseLength:256)
  
  static let RESET_WALLET_APDU = NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : RESET_WALLET_APDU_BYTES), expectedResponseLength:-1)
  
  static let GEN_SEED_FOR_DEFAULT_PIN = NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GENERATE_SEED_BYTES + [UInt8(TonWalletAppletConstants.PIN_SIZE)] + TonWalletAppletConstants.DEFAULT_PIN), expectedResponseLength:-1)
  
  static func getGenSeedApdu(pin : [UInt8]) throws -> NFCISO7816APDU {
    try checkPin(pin : pin)
    return NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : GENERATE_SEED_BYTES + [UInt8(TonWalletAppletConstants.PIN_SIZE)] + pin), expectedResponseLength:-1)
  }

  static func getChangePinApdu(oldPin : [UInt8], newPin : [UInt8]) throws -> NFCISO7816APDU {
    try checkPin(pin : oldPin)
    try checkPin(pin : newPin)
    return NFCISO7816APDU(instructionClass:CLA, instructionCode:INS, p1Parameter:P1, p2Parameter:P2, data: Data(_ : CHANGE_PIN_BYTES + [UInt8(TonWalletAppletConstants.PIN_SIZE)] + oldPin + [UInt8(TonWalletAppletConstants.PIN_SIZE)] + newPin), expectedResponseLength:-1)
  }
  
  static func getSetDeviceLabelApdu(label : [UInt8]) throws -> NFCISO7816APDU {
    if label.count != CoinManagerConstants.LABEL_LENGTH  {
        throw ResponsesConstants.ERROR_MSG_LABEL_BYTES_SIZE_INCORRECT
    }
    return NFCISO7816APDU(instructionClass : CLA, instructionCode : INS, p1Parameter : P1, p2Parameter : P2, data : Data(_ : SET_DEVICE_LABEL_BYTES + [UInt8(CoinManagerConstants.LABEL_LENGTH)] + label), expectedResponseLength : -1)
  }
  
  static func checkPin(pin : [UInt8]) throws {
    if (pin.count != TonWalletAppletConstants.PIN_SIZE) {
        throw ResponsesConstants.ERROR_MSG_PIN_BYTES_SIZE_INCORRECT
    }
  }
    
}
