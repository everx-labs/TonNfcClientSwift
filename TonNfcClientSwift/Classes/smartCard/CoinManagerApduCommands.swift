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
 * Here there are all objects representing APDU commands of CoinManager software living on security card.
 * All this APDU commands does not belong to TonWalletApplet. So you can call them independent on TonWalletApplet state.
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

@available(iOS 13.0, *)
class CoinManagerApduCommands {
    static let CURVE_TYPE_SUFFIX = "0102"
    static let COIN_MANAGER_CLA : UInt8 = 0x80
    static let COIN_MANAGER_INS : UInt8 = 0xCB
    static let COIN_MANAGER_P1 : UInt8 = 0x80
    static let COIN_MANAGER_P2 : UInt8 = 0x00
    static let GET_ROOT_KEY_STATUS_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x05]
    static let GET_APPS_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x06]
    static let GET_PIN_RTL_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x02]
    static let GET_PIN_TLT_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x03]
    static let RESET_WALLET_DATA : [UInt8] =  [0xDF, 0xFE, 0x02, 0x82, 0x05]
    static let GET_SE_VERSION_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x09]
    static let GET_CSN_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x01]
    static let GET_DEVICE_LABEL_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x04]
    static let SET_DEVICE_LABEL_DATA : [UInt8] =  [0xDF, 0xFE, 0x23, 0x81, 0x04]
    static let GET_AVAILABLE_MEMORY_DATA : [UInt8] =  [0xDF, 0xFF, 0x02, 0x81, 0x46]
    static let GENERATE_SEED_DATA : [UInt8] =  [0xDF, 0xFE, 0x08, 0x82, 0x03, 0x05]
    static let CHANGE_PIN_DATA : [UInt8] =  [0xDF, 0xFE, 0x0D, 0x82, 0x04, 0x0A]
    static let SD_AID : [UInt8] = [0xA0, 0x00, 0x00, 0x01, 0x51, 0x00, 0x00, 0x00]
    
    static let SELECT_COIN_MANAGER_NAME = "SELECT_COIN_MANAGER"
    static let GET_ROOT_KEY_STATUS_NAME = "GET_ROOT_KEY_STATUS"
    static let GET_APPS_NAME = "GET_APPS"
    static let GET_PIN_RTL_NAME = "GET_PIN_RTL"
    static let GET_PIN_TLT_NAME = "GET_PIN_TLT"
    static let RESET_WALLET_NAME = "RESET_WALLET"
    static let GET_SE_VERSION_NAME = "GET_SE_VERSION"
    static let GET_CSN_NAME = "GET_CSN"
    static let GET_DEVICE_LABEL_NAME = "GET_DEVICE_LABEL"
    static let SET_DEVICE_LABEL_NAME = "SET_DEVICE_LABEL"
    static let GET_AVAILABLE_MEMORY_NAME = "GET_AVAILABLE_MEMORY"
    static let GENERATE_SEED_NAME = "GENERATE_SEED"
    static let CHANGE_PIN_NAME = "CHANGE_PIN"
    
    static let APDU_COMMAND_NAMES = [
        SD_AID : SELECT_COIN_MANAGER_NAME,
        GET_ROOT_KEY_STATUS_DATA : GET_ROOT_KEY_STATUS_NAME,
        GET_APPS_DATA : GET_APPS_NAME,
        GET_PIN_RTL_DATA : GET_PIN_RTL_NAME,
        GET_PIN_TLT_DATA : GET_PIN_TLT_NAME,
        RESET_WALLET_DATA : RESET_WALLET_NAME,
        GET_SE_VERSION_DATA : GET_SE_VERSION_NAME,
        GET_CSN_DATA : GET_CSN_NAME,
        GET_DEVICE_LABEL_DATA : GET_DEVICE_LABEL_NAME,
        SET_DEVICE_LABEL_DATA : SET_DEVICE_LABEL_NAME,
        GET_AVAILABLE_MEMORY_DATA : GET_AVAILABLE_MEMORY_NAME,
        GENERATE_SEED_DATA : GENERATE_SEED_NAME,
        CHANGE_PIN_DATA : CHANGE_PIN_NAME
    ]
    
    static func getApduName(apdu : NFCISO7816APDU) -> String? {
        for array in CoinManagerApduCommands.APDU_COMMAND_NAMES.keys {
            if let data = apdu.data {
                let num = data.count >= array.count ? array.count : data.count
                if data.prefix(upTo : num).bytes == array {
                    return CoinManagerApduCommands.APDU_COMMAND_NAMES[array]
                }
            }
        }
        return nil
    }
    
    /**
     This command is used to select CoinManager soft on security card
     00A40400
     */
    static let SELECT_COIN_MANAGER_APDU = NFCISO7816APDU(instructionClass : CommonConstants.CLA_SELECT, instructionCode : CommonConstants.INS_SELECT, p1Parameter : CommonConstants.SELECT_P1, p2Parameter : CommonConstants.SELECT_P2, data : Data(_ : SD_AID), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    
    /**
     This command is used to get SE (secure element) version.
    */
    static let GET_SE_VERSION_APDU =  NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_SE_VERSION_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to get CSN (SE ID).
     */
    static let GET_CSN_APDU =  NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_CSN_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to get security card abel. (we do not use it now)
     */
    static let GET_DEVICE_LABEL_APDU = NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_DEVICE_LABEL_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to get retry maximum times of security card PIN.
     80CB800005DFFF028103
     */
    static let GET_PIN_TLT_APDU = NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_PIN_TLT_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to get remaining retry times of security card PIN.
     80CB800005DFFF028102
     */
    static let GET_PIN_RTL_APDU = NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_PIN_RTL_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to get the status of seed.
     80CB800005DFFF028105
     */
    static let GET_ROOT_KEY_STATUS_APDU = NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_ROOT_KEY_STATUS_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to obtain the amount of memory of the specified type that is available to the applet.
     Note that implementation-dependent memory overhead structures may also use the same memory pool.
     */
    static let GET_AVAILABLE_MEMORY_APDU = NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_AVAILABLE_MEMORY_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to get application list (list of applets AIDS installed onto security card).
     */
    static let GET_APPLET_LIST_APDU = NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GET_APPS_DATA), expectedResponseLength : CommonConstants.LE_GET_ALL_RESPONSE_DATA)
    
    /**
     This command is used to reset the wallet state to the initial state. After resetting the wallet, the default PIN
     value would be ‘35353535’, in hexadecimal format. The remaining retry for the PIN will be reset to MAX (default
     is 10). The root key will be erased. The coin info if exist will also be reset.
     */
    static let RESET_WALLET_APDU = NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : RESET_WALLET_DATA), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    
    static let GEN_SEED_FOR_DEFAULT_PIN = NFCISO7816APDU(instructionClass:COIN_MANAGER_CLA, instructionCode:COIN_MANAGER_INS, p1Parameter:COIN_MANAGER_P1, p2Parameter:COIN_MANAGER_P2, data: Data(_ : GENERATE_SEED_DATA + [UInt8(CommonConstants.PIN_SIZE)] + CommonConstants.DEFAULT_PIN), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    
    /**
     * This command is used to generate the seed with RNG. If the seed already exist, this command will throw an exception.
     * You should reset the wallet before importing it again. You can use the command GET ROOT KEY STATUS to get the status of the current root key.
     * If the length or value of security card PIN is incorrect or verified failed, the RTL will decrement and throw an exception
     * with ‘9B01’. If there is no remaining retry time left for PIN, the current wallet will be reset. See RESET WALLET
     * command for more details. If the wallet status shows the current JuBiter could not generate any seed, it will throw an exception with
     * ‘9B02’. If any error occurs while loading the seed, the wallet will reset to the default status and throw an exception
     * with ‘9B03’.
     * Example: 80CB8000DFFE08820305043535353500
     */
    static func getGenSeedApdu(_ pin : [UInt8]) throws -> NFCISO7816APDU {
        try CommonConstants.checkPin(pin)
        return NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : GENERATE_SEED_DATA + [UInt8(CommonConstants.PIN_SIZE)] + pin), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
     * This command is used to change security card PIN. The default PIN Value is ‘35353535’, in hexadecimal format.
     * If the length or value of PIN is incorrect or verified failed, the RTL will decrement and throw an exception
     * with ‘9B01’. If there is no remaining retry time left for PIN, the current wallet will be reset. See RESET WALLET
     * command for more details.
     * Example: User entered oldpin=5555 and newpin=6666. Here we transform it into strings 35353535 and 36363636 and wrap into apdu command
     */
    static func getChangePinApdu(oldPin : [UInt8], newPin : [UInt8]) throws -> NFCISO7816APDU {
        try CommonConstants.checkPin(oldPin)
        try CommonConstants.checkPin(newPin)
        return NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : CHANGE_PIN_DATA + [UInt8(CommonConstants.PIN_SIZE)] + oldPin + [UInt8(CommonConstants.PIN_SIZE)] + newPin), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }
    
    /**
     This command is used to set security card device label (we do not use it now).
     */
    static func getSetDeviceLabelApdu(_ label : [UInt8]) throws -> NFCISO7816APDU {
        try CoinManagerConstants.checkLabel(label)
        return NFCISO7816APDU(instructionClass : COIN_MANAGER_CLA, instructionCode : COIN_MANAGER_INS, p1Parameter : COIN_MANAGER_P1, p2Parameter : COIN_MANAGER_P2, data : Data(_ : SET_DEVICE_LABEL_DATA + [UInt8(CoinManagerConstants.LABEL_LENGTH)] + label), expectedResponseLength : CommonConstants.LE_NO_RESPONSE_DATA)
    }    
}
