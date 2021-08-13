//
//  JsonHelperTest.swift
//  TonNfcClientSwift_Tests
//
//  Created by Alina Alinovna on 13.08.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import TonNfcClientSwift

struct MsgSuccessfullParsed : Codable {
    var message: String
    var status: String
}

struct KeyIndex : Codable {
    var index: Int
    var length: Int
}
struct KeyIndexSuccessfullParsed : Codable {
    var message : KeyIndex
    var status: String
}

@available(iOS 13.0, *)
class JsonHelperTest: QuickSpec {
    
    let decoder = JSONDecoder()
    
    override func spec() {
        let jsonHelper = JsonHelper.getInstance()
        
        context("When it calls createJson", {
            it("returns correct json with fields: 'message' and 'status'") {
                do {
                    let msg = "1234567890"
                    let status = "ok"
                    let json = jsonHelper.createJson(msg: msg)
                    let parsed = try self.decoder.decode(MsgSuccessfullParsed.self, from: json.data(using: .utf8)!)
                    expect(parsed.message) == msg
                    expect(parsed.status) == status
                }
                catch{
                    fail()
                }
            }
        })
        
        
        context("When it calls createJson", {
            it("returns correct json with fields: 'index', 'length' and 'status'") {
                do {
                    let ind = 9
                    let len = 20
                    let status = "ok"
                    let json = jsonHelper.createJson(index : ind, len : len)

                    
                    let parsed = try self.decoder.decode(KeyIndexSuccessfullParsed.self, from: json.data(using: .utf8)!)
                    expect(parsed.message.index) == ind
                    expect(parsed.message.length) == len
                    expect(parsed.status) == status
                }
                catch{
                    fail()
                }
            }
        })
        
    }

}
