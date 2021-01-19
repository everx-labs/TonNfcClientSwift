//
//  Data.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 02.09.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
extension Data {
    public var bytes: [UInt8] {
        return [UInt8](self)
    }
    
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    func makeDigitalString() -> String {
        //todo: check numeric
        var s: String = ""
        for i in 0...bytes.count-1 {
            if (bytes[i] >= 0 &&  bytes[i] <= 9) {
                s += String(bytes[i])
            }
        }
        return s
    }
}
