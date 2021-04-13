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

class CommonConstants {
    static let INS_SELECT:UInt8 = 0xA4;
    
    //Applet stuff
    
    static let WALLET_APPLET_AID: [UInt8] = [0x31, 0x31, 0x32, 0x32, 0x33, 0x33, 0x34, 0x34, 0x35, 0x35, 0x36, 0x36]
}

class CoinManagerConstants {
    static let LABEL_LENGTH:Int = 32
    static let MAX_PIN_TRIES:Int = 0x0A
    static let POSITIVE_ROOT_KEY_STATUS = 0x5A
}
