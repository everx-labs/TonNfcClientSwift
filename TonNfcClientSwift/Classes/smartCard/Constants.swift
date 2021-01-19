//
//  Constants.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 02.12.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

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
