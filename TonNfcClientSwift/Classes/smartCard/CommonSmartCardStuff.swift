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

/**
 Here there are some contants related to all APDU commands
 */
public class CommonConstants {
    public static let TON_WALLET_APPLET_AID: [UInt8] = [0x31, 0x31, 0x32, 0x32, 0x33, 0x33, 0x34, 0x34, 0x35, 0x35, 0x36, 0x36]
    public static let DEFAULT_PIN: [UInt8] = [0x35, 0x35, 0x35, 0x35] // default security card PIN '5555' set at the factory, represented in Ascii.
    public static let PIN_SIZE = 4
    
    static let CLA_SELECT:  UInt8 = 0x00
    static let INS_SELECT : UInt8 = 0xA4
    static let SELECT_P1 : UInt8 = 0x04
    static let SELECT_P2 : UInt8 = 0x00
    static let LE_NO_RESPONSE_DATA = -1 // Use this LE if you do not wait any response data from card (except of status word)
    static let LE_GET_ALL_RESPONSE_DATA = 256 // This is standard 0x00 value of LE. Use this LE if you want to take all  response bytes from applet that it produced
    
    static func checkPin(_ pin : [UInt8]) throws {
        if (pin.count != PIN_SIZE) {
            throw ResponsesConstants.ERROR_MSG_PIN_BYTES_SIZE_INCORRECT
        }
    }
}

/**
 Here there are some contants related to CoinManager APDU commands
 */
public class CoinManagerConstants {
    public static let LABEL_LENGTH: Int = 0x20
    public static let MAX_PIN_TRIES: Int = 0x0A
    public static let POSITIVE_ROOT_KEY_STATUS = 0x5A
    
    static func checkLabel(_ label : [UInt8]) throws {
        if label.count != LABEL_LENGTH  {
            throw ResponsesConstants.ERROR_MSG_LABEL_BYTES_SIZE_INCORRECT
        }
    }
}
