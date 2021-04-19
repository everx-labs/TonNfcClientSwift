//
//  TonWalletAppletApduCommandsTest.swift
//  TonNfcClientSwift_Tests
//
//  Created by Alina Alinovna on 15.04.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import TonNfcClientSwift

@available(iOS 13.0, *)
class TonWalletAppletApduCommandsTest: QuickSpec  {
    
    override func spec() {
        // We must create key for HMACSHA256 signature to run below tests
        
        let hmacHelper = HmacHelper.getInstance()
        let SERIAL_NUMBER = "504394802433901126813236"
        let COMMON_SECRET = ByteArrayAndHexHelper.hex(from : "7256EFE7A77AFC7E9088266EF27A93CB01CD9432E0DB66D600745D506EE04AC4")
        let IV = ByteArrayAndHexHelper.hex(from : "1A550F4B413D0E971C28293F9183EA8A")
        let PASSWORD  = ByteArrayAndHexHelper.hex(from : "F4B072E1DF2DB7CF6CD0CD681EC5CD2D071458D278E6546763CBB4860F8082FE14418C8A8A55E2106CBC6CB1174F4BA6D827A26A2D205F99B7E00401DA4C15ACC943274B92258114B5E11C16DA64484034F93771547FBE60DA70E273E6BD64F8A4201A9913B386BCA55B6678CFD7E7E68A646A7543E9E439DD5B60B9615079FE")
        hmacHelper.currentSerialNumber = SERIAL_NUMBER 
        let cardActivationApi : CardActivationNfcApi = CardActivationNfcApi()
        
        do {
            try cardActivationApi.createKeyForHmac(password : PASSWORD, commonSecret : COMMON_SECRET, serialNumber : SERIAL_NUMBER)
        }
        catch {
            fail()
        }
        
        let badP1Params : [UInt8] = [
            0xFF,
            3,
            100
        ]
        
        let goodP1Params : [UInt8] = [
            0x00,
            0x01,
            0x02
        ]
        
        let badIvs : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x65, count: Int(TonWalletAppletConstants.IV_SIZE) - 1),
            [UInt8](repeating: 0x89, count: Int(TonWalletAppletConstants.IV_SIZE) + 1)
        ]
        
        let badPasswords : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x90, count: Int(TonWalletAppletConstants.PASSWORD_SIZE) - 1),
            [UInt8](repeating: 0x87, count: Int(TonWalletAppletConstants.PASSWORD_SIZE) + 1)
        ]
        
        let pin : [UInt8] = [UInt8](repeating: 0x35, count: CommonConstants.PIN_SIZE)
        let badPins : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x36, count: CommonConstants.PIN_SIZE - 1),
            [UInt8](repeating: 0x36, count: CommonConstants.PIN_SIZE + 1)
        ]
        
        let dataForSigning  : [UInt8] = [0x00, 0x01, 0x02, 0x03, 0x04]
        let badDataForSigning  : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x02, count : Int(TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH) + 1),
            [UInt8](repeating: 0x39, count : Int(TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH) + 100)
        ]
        let badDataForSigningForDefaultHdPath  : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x06, count: Int(TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE) + 1),
            [UInt8](repeating: 0x34, count: Int(TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE) + 200)
        ]
        
        let hdIndex : [UInt8] = [0x00, 0x01]
        let badHdIndices : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x01, count: Int(TonWalletAppletConstants.MAX_IND_SIZE) + 1),
            [UInt8](repeating: 0x36, count: Int(TonWalletAppletConstants.MAX_IND_SIZE) + 100)
        ]
        
        let sault : [UInt8] = [UInt8](repeating: 0x09, count: TonWalletAppletConstants.SAULT_LENGTH)
        let badSaults : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x36, count: TonWalletAppletConstants.SAULT_LENGTH - 1),
            [UInt8](repeating: 0x36, count: TonWalletAppletConstants.SAULT_LENGTH + 1)
        ]
        
        let recoveryDataPortion : [UInt8] = [0x00, 0x01]
        let badRecoveryDataPortions : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x36, count: Int(TonWalletAppletConstants.APDU_DATA_MAX_SIZE) + 1),
            [UInt8](repeating: 0x36, count: Int(TonWalletAppletConstants.APDU_DATA_MAX_SIZE) + 100)
        ]
        
        let badLEs : [Int] = [
            CommonConstants.LE_NO_RESPONSE_DATA,
            CommonConstants.LE_GET_ALL_RESPONSE_DATA + 1
        ]
        
        
        let startPos : [UInt8] = [0x00, 0x00]
        let badStartPositions  : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x06, count: Int(TonWalletAppletConstants.START_POS_LEN) + 1),
            [UInt8](repeating: 0x34, count: Int(TonWalletAppletConstants.START_POS_LEN) - 1)
        ]
        
        let keySizeBytes : [UInt8] = [0x00, 0x00]
        let badKeySizesBytes  : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x06, count: Int(TonWalletAppletConstants.KEY_SIZE_BYTES_LEN) + 1),
            [UInt8](repeating: 0x34, count: Int(TonWalletAppletConstants.KEY_SIZE_BYTES_LEN) - 1)
        ]
        
        let hmac : [UInt8] = [UInt8](repeating: 0x06, count: Int(TonWalletAppletConstants.HMAC_SHA_SIG_SIZE))
        let badHmacBytes  : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x06, count: Int(TonWalletAppletConstants.HMAC_SHA_SIG_SIZE) + 1),
            [UInt8](repeating: 0x34, count: Int(TonWalletAppletConstants.HMAC_SHA_SIG_SIZE) - 1)
        ]
        
        let keyIndex : [UInt8] = [UInt8](repeating: 0x06, count: Int(TonWalletAppletConstants.KEYCHAIN_KEY_INDEX_LEN ))
        let badKeyIndices  : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x00, count: Int(TonWalletAppletConstants.KEYCHAIN_KEY_INDEX_LEN) + 1),
            [UInt8](repeating: 0x01, count: Int(TonWalletAppletConstants.KEYCHAIN_KEY_INDEX_LEN) - 1)
        ]
        
        let SEND_KEY_CHUNK_INSTRUCTIONS : [UInt8] = [TonWalletAppletApduCommands.INS_ADD_KEY_CHUNK, TonWalletAppletApduCommands.INS_CHANGE_KEY_CHUNK]
        
        let keyChunk : [UInt8] = [UInt8](repeating: 0x06, count: 100)
        let badKeyChunks  : [[UInt8]] = [
            [],
            [UInt8](repeating: 0x00, count: Int(TonWalletAppletConstants.DATA_PORTION_MAX_SIZE) + 1),
            [UInt8](repeating: 0x01, count: Int(TonWalletAppletConstants.DATA_PORTION_MAX_SIZE) + 100)
        ]
        
        /**
         static func checkKeyChainKeyIndex(_ ind : [UInt8]) throws {
             if ind.count != TonWalletAppletConstants.KEYCHAIN_KEY_INDEX_LEN {
                 throw ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT
             }
         }
         */
        
        
        
        /**
             * GET_RECOVERY_DATA_PART
             * CLA: 0xB0
             * INS: 0xD2
             * P1: 0x00
             * P2: 0x00
             * LC: 0x02
             * Data: startPosition of recovery data piece in internal buffer
             * LE: length of recovery data piece in internal buffer
        */
        
        context("When it's requesting GET_RECOVERY_DATA_PART APDU command with startPositionBytes of incorrect length", {
            it("throws a error") {
                for badStartPos in badStartPositions {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetRecoveryDataPartApdu(startPositionBytes : badStartPos, le : TonWalletAppletConstants.DATA_PORTION_MAX_SIZE) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_START_POS_BYTE_REPRESENTATION_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_RECOVERY_DATA_PART APDU command with startPositionBytes of incorrect length", {
            it("throws a error") {
                for badLe in badLEs {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetRecoveryDataPartApdu(startPositionBytes : startPos, le : badLe) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_LE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_RECOVERY_DATA_PART APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    for le in 1...CommonConstants.LE_GET_ALL_RESPONSE_DATA {
                        let apdu = try TonWalletAppletApduCommands.getGetRecoveryDataPartApdu(startPositionBytes : startPos, le : le)
                        expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                        expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_RECOVERY_DATA_PART
                        expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                        expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                        expect(apdu.data) == Data(_ : startPos)
                        expect(apdu.expectedResponseLength) == le
                    }
                }
                catch{
                    fail()
                }
            }
        })
        
        
        /**
             * ADD_RECOVERY_DATA_PART
             * CLA: 0xB0
             * INS: 0xD1
             * P1: 0x00 (START_OF_TRANSMISSION), 0x01 or 0x02 (END_OF_TRANSMISSION)
             * P2: 0x00
             * LC: If (P1 ≠ 0x02) Length of recovery data piece else 0x20
             * Data: If (P1 ≠ 0x02) recovery data piece else SHA256(recovery data)
        */
        
        context("When it's requesting ADD_RECOVERY_DATA_PART APDU command with incorrect p1", {
            it("throws a error") {
                for badP1 in badP1Params {
                    expect ( expression: {try TonWalletAppletApduCommands.getAddRecoveryDataPartApdu(p1 : badP1, data : recoveryDataPortion) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_APDU_P1_INCORRECT})
                }
            }
        })
        
        context("When it's requesting ADD_RECOVERY_DATA_PART APDU command with recoveryDataPortion incorrect of incorrect length", {
            it("throws a error") {
                for p1 in goodP1Params {
                    for badRecoveryDataPortion in badRecoveryDataPortions {
                        expect ( expression: {try TonWalletAppletApduCommands.getAddRecoveryDataPartApdu(p1 : p1, data : badRecoveryDataPortion) })
                            .to(throwError { (error: Error) in
                                    expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_APDU_DATA_FIELD_SIZE_INCORRECT})
                    }
                }
            }
        })
        
        context("When it's requesting ADD_RECOVERY_DATA_PART APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    for p1 in goodP1Params {
                        let apdu = try TonWalletAppletApduCommands.getAddRecoveryDataPartApdu(p1 : p1, data : recoveryDataPortion)
                        expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                        expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_ADD_RECOVERY_DATA_PART
                        expect(apdu.p1Parameter) == p1
                        expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                        expect(apdu.data) == Data(_ : recoveryDataPortion)
                        expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                    }
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             VERIFY_PASSWORD
             CLA: 0xB0
             INS: 0x92
             P1: 0x00
             P2: 0x00
             LC: 0x90
             Data: 128 bytes of unencrypted activation password | 16 bytes of IV for AES128 CBC
        */
        
        context("When it's requesting VERIFY_PASSWORD APDU command with password of incorrect length", {
            it("throws a error") {
                for badPassword in badPasswords {
                    expect ( expression: {try TonWalletAppletApduCommands.getVerifyPasswordApdu(password : badPassword, initialVector : IV.bytes) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_ACTIVATION_PASSWORD_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting VERIFY_PASSWORD APDU command with iv of incorrect length", {
            it("throws a error") {
                for badIv in badIvs {
                    expect ( expression: {try TonWalletAppletApduCommands.getVerifyPasswordApdu(password : PASSWORD.bytes, initialVector : badIv) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_INITIAL_VECTOR_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting VERIFY_PASSWORD APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getVerifyPasswordApdu(password : PASSWORD.bytes, initialVector : IV.bytes)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_VERIFY_PASSWORD
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    let dataChunk = PASSWORD.bytes + IV.bytes
                    var dataField = Data(_  :  dataChunk)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                }
                catch{
                    fail()
                }
            }
        })
        
        
        /**
             VERIFY_PIN
             CLA: 0xB0
             INS: 0xA2
             P1: 0x00
             P2: 0x00
             LC: 0x44
             Data: 4 bytes of PIN | 32 bytes of sault | 32 bytes of mac
        */
        
        context("When it's requesting VERIFY_PIN APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getVerifyPinApdu(pinBytes: pin, sault : badSault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting VERIFY_PIN APDU command with pin of incorrect length", {
            it("throws a error") {
                for badPin in badPins {
                    expect ( expression: {try TonWalletAppletApduCommands.getVerifyPinApdu(pinBytes: badPin, sault : sault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_PIN_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting VERIFY_PIN APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getVerifyPinApdu(pinBytes: pin, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_VERIFY_PIN
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    let dataChunk = pin + sault
                    var dataField = Data(_  :  dataChunk)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                }
                catch{
                    fail()
                }
            }
        })
        
        
        /**
             SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH
             CLA: 0xB0
             INS: 0xA5
             P1: 0x00
             P2: 0x00
             LC: APDU data length
             Data: messageLength (2bytes)| message | sault (32 bytes) | mac (32 bytes)
             LE: 0x40
        */
        
        context("When it's requesting SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getSignShortMessageWithDefaultPathApdu(dataForSigning : dataForSigning, sault : badSault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH APDU command with data of incorrect length", {
            it("throws a error") {
                for badData in badDataForSigningForDefaultHdPath  {
                    expect ( expression: {try TonWalletAppletApduCommands.getSignShortMessageWithDefaultPathApdu(dataForSigning : badData, sault : sault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_DATA_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getSignShortMessageWithDefaultPathApdu(dataForSigning : dataForSigning, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_SIGN_SHORT_MESSAGE_WITH_DEFAULT_PATH
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    let dataChunk = [0x00, UInt8(dataForSigning.count)] + dataForSigning + sault
                    var dataField = Data(_  :  dataChunk)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.SIG_LEN
                }
                catch{
                    fail()
                }
            }
        })
    
        
        /**
             SIGN_SHORT_MESSAGE
             CLA: 0xB0
             INS: 0xA3
             P1: 0x00
             P2: 0x00
             LC: APDU data length
             Data: messageLength (2bytes)| message | indLength (1 byte, > 0, <= 10) | ind | sault (32 bytes) | mac (32 bytes)
             LE: 0x40
        */
        
        context("When it's requesting SIGN_SHORT_MESSAGE APDU command with hdIndex of incorrect length", {
            it("throws a error") {
                for badHdIndex in badHdIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.getSignShortMessageApdu(dataForSigning : dataForSigning, hdIndex : badHdIndex, sault : sault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_HD_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting SIGN_SHORT_MESSAGE APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getSignShortMessageApdu(dataForSigning : dataForSigning, hdIndex : hdIndex, sault : badSault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting SIGN_SHORT_MESSAGE APDU command with data of incorrect length", {
            it("throws a error") {
                for badData in badDataForSigning {
                    expect ( expression: {try TonWalletAppletApduCommands.getSignShortMessageApdu(dataForSigning : badData, hdIndex : hdIndex, sault : sault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_DATA_WITH_HD_PATH_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting SIGN_SHORT_MESSAGE APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getSignShortMessageApdu(dataForSigning : dataForSigning, hdIndex : hdIndex, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_SIGN_SHORT_MESSAGE
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    let indAndSault = hdIndex + sault
                    let dataChunk = [0x00, UInt8(dataForSigning.count)] + dataForSigning + [UInt8(hdIndex.count)] + indAndSault
                    var dataField = Data(_  :  dataChunk)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.SIG_LEN
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             GET_PUBLIC_KEY
             CLA: 0xB0
             INS: 0xA0
             P1: 0x00
             P2: 0x00
             LC: Number of decimal places in ind
             Data: Ascii encoding of ind decimal places
             LE: 0x20
        */
        
       
        context("When it's requesting GET_PUBLIC_KEY APDU command with hdIndex of incorrect length", {
            it("throws a error") {
                for badHdIndex in badHdIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.getPublicKeyApdu(badHdIndex)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_HD_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_PUBLIC_KEY APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getPublicKeyApdu(hdIndex)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_PUBLIC_KEY
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    expect(apdu.data) == Data(_ : hdIndex)
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.PK_LEN
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             RESET_KEYCHAIN
             CLA: 0xB0
             INS: 0xBC
             P1: 0x00
             P2: 0x00
             LC: 0x40
             Data: sault (32 bytes) | mac (32 bytes)
        */
        
        context("When it's requesting RESET_KEYCHAIN APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getResetKeyChainApdu(badSault)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting RESET_KEYCHAIN APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getResetKeyChainApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_RESET_KEYCHAIN
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             GET_NUMBER_OF_KEYS
             CLA: 0xB0
             INS: 0xB8
             P1: 0x00
             P2: 0x00
             LC: 0x40
             Data: sault (32 bytes) | mac (32 bytes)
             LE: 0x02
         */
        
        context("When it's requesting GET_NUMBER_OF_KEYS APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getNumberOfKeysApdu(badSault)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_NUMBER_OF_KEYS APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_NUMBER_OF_KEYS
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.GET_NUMBER_OF_KEYS_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             GET_OCCUPIED_STORAGE_SIZE
             CLA: 0xB0
             INS: 0xBA
             P1: 0x00
             P2: 0x00
             LC: 0x40
             Data: sault (32 bytes) | mac (32 bytes)
             LE: 0x02
        */
        
        context("When it's requesting GET_OCCUPIED_STORAGE_SIZE APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetOccupiedSizeApdu(badSault)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_OCCUPIED_STORAGE_SIZE APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getGetOccupiedSizeApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_OCCUPIED_STORAGE_SIZE
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.GET_OCCUPIED_SIZE_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             GET_FREE_STORAGE_SIZE
             CLA: 0xB0
             INS: 0xB9
             P1: 0x00
             P2: 0x00
             LC: 0x40
             Data: sault (32 bytes) | mac (32 bytes)
             LE: 0x02
        */
        
        context("When it's requesting GET_FREE_STORAGE_SIZE APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetFreeSizeApdu(badSault)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_FREE_STORAGE_SIZE APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getGetFreeSizeApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_FREE_STORAGE_SIZE
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.GET_FREE_SIZE_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             CHECK_AVAILABLE_VOL_FOR_NEW_KEY
             CLA: 0xB0
             INS: 0xB3
             P1: 0x00
             P2: 0x00
             LC: 0x42
             Data: length of new key (2 bytes) | sault (32 bytes) | mac (32 bytes)
        */
        
        context("When it's requesting CHECK_AVAILABLE_VOL_FOR_NEW_KEY APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getCheckAvailableVolForNewKeyApdu(keySize : keySizeBytes, sault : badSault)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting CHECK_AVAILABLE_VOL_FOR_NEW_KEY APDU command with keySizeBytes of incorrect length", {
            it("throws a error") {
                for badKeySize in badKeySizesBytes {
                    expect ( expression: {try TonWalletAppletApduCommands.getCheckAvailableVolForNewKeyApdu(keySize : badKeySize, sault : sault)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_SIZE_BYTE_REPRESENTATION_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting CHECK_AVAILABLE_VOL_FOR_NEW_KEY APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getCheckAvailableVolForNewKeyApdu(keySize : keySizeBytes, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_CHECK_AVAILABLE_VOL_FOR_NEW_KEY
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  keySizeBytes + sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             CHECK_KEY_HMAC_CONSISTENCY
             CLA: 0xB0
             INS: 0xB0
             P1: 0x00
             P2: 0x00
             LC: 0x60
             Data: keyMac (32 bytes) | sault (32 bytes) | mac (32 bytes)
        */
        
        context("When it's requesting CHECK_KEY_HMAC_CONSISTENCY APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getCheckKeyHmacConsistencyApdu(keyHmac: hmac, sault : badSault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting CHECK_KEY_HMAC_CONSISTENCY APDU command with keyHmac of incorrect length", {
            it("throws a error") {
                for badHmac in badHmacBytes {
                    expect ( expression: {try TonWalletAppletApduCommands.getCheckKeyHmacConsistencyApdu(keyHmac: badHmac, sault : sault) })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting CHECK_KEY_HMAC_CONSISTENCY APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getCheckKeyHmacConsistencyApdu(keyHmac: hmac, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_CHECK_KEY_HMAC_CONSISTENCY
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  hmac + sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             INITIATE_CHANGE_OF_KEY
             CLA: 0xB0
             INS: 0xB5
             P1: 0x00
             P2: 0x00
             LC: 0x42
             Data: index of key (2 bytes) | sault (32 bytes) | mac (32 bytes)
        */
        
        context("When it's requesting INITIATE_CHANGE_OF_KEY APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getInitiateChangeOfKeyApdu(index : keyIndex, sault : badSault)  })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting INITIATE_CHANGE_OF_KEY APDU command with key index of incorrect length", {
            it("throws a error") {
                for badKeyIndex in badKeyIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.getInitiateChangeOfKeyApdu(index : badKeyIndex, sault : sault)  })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting INITIATE_CHANGE_OF_KEY APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getInitiateChangeOfKeyApdu(index : keyIndex, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_INITIATE_CHANGE_OF_KEY
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  keyIndex + sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             GET_KEY_INDEX_IN_STORAGE_AND_LEN
             CLA: 0xB0
             INS: 0xB1
             P1: 0x00
             P2: 0x00
             LC: 0x60
             Data: hmac of key (32 bytes) | sault (32 bytes) | mac (32 bytes)
             LE: 0x04
        */

        context("When it's requesting GET_KEY_INDEX_IN_STORAGE_AND_LEN, APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetIndexAndLenOfKeyInKeyChainApdu(keyHmac : hmac, sault : badSault)  })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_KEY_INDEX_IN_STORAGE_AND_LEN, APDU command with keyHmac of incorrect length", {
            it("throws a error") {
                for badHmac in badHmacBytes {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetIndexAndLenOfKeyInKeyChainApdu(keyHmac : badHmac, sault : sault)  })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_KEY_INDEX_IN_STORAGE_AND_LEN APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getGetIndexAndLenOfKeyInKeyChainApdu(keyHmac : hmac, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_KEY_INDEX_IN_STORAGE_AND_LEN
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  hmac + sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.GET_KEY_INDEX_IN_STORAGE_AND_LEN_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             INITIATE_DELETE_KEY
             CLA: 0xB0
             INS: 0xB7
             P1: 0x00
             P2: 0x00
             LC: 0x42
             Data: key  index (2 bytes) | sault (32 bytes) | mac (32 bytes)
             LE: 0x02
        */
        
        context("When it's requesting INITIATE_DELETE_KEY, APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getInitiateDeleteOfKeyApdu(index : keyIndex, sault : badSault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting INITIATE_DELETE_KEY, APDU command with keyIndex of incorrect length", {
            it("throws a error") {
                for badKeyIndex in badKeyIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.getInitiateDeleteOfKeyApdu(index : badKeyIndex, sault : sault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting INITIATE_DELETE_KEY APDU command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getInitiateDeleteOfKeyApdu(index : keyIndex, sault : sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_INITIATE_DELETE_KEY
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  keyIndex + sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.INITIATE_DELETE_KEY_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             * GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS
             * CLA: 0xB0
             * INS: 0xE1
             * P1: 0x00
             * P2: 0x00
             * LC: 0x40
             * Data: sault (32 bytes) | mac (32 bytes)
             * LE: 0x02
        */
        
        context("When it's requesting GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS, APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getDeleteKeyChunkNumOfPacketsApdu(badSault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getDeleteKeyChunkNumOfPacketsApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             * GET_DELETE_KEY_RECORD_NUM_OF_PACKETS
             * CLA: 0xB0
             * INS: 0xE2
             * P1: 0x00
             * P2: 0x00
             * LC: 0x40
             * Data: sault (32 bytes) | mac (32 bytes)
             * LE: 0x02
        */
        
        context("When it's requesting GET_DELETE_KEY_RECORD_NUM_OF_PACKETS, APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getDeleteKeyRecordNumOfPacketsApdu(badSault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_DELETE_KEY_RECORD_NUM_OF_PACKETS command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getDeleteKeyRecordNumOfPacketsApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             DELETE_KEY_CHUNK
             CLA: 0xB0
             INS: 0xBE
             P1: 0x00
             P2: 0x00
             LC: 0x40
             Data: sault (32 bytes) | mac (32 bytes)
             LE: 0x01
        */
        
        context("When it's requesting DELETE_KEY_CHUNK, APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getDeleteKeyChunkApdu(badSault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting DELETE_KEY_CHUNK command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getDeleteKeyChunkApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_DELETE_KEY_CHUNK
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.DELETE_KEY_CHUNK_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             DELETE_KEY_RECORD
             CLA: 0xB0
             INS: 0xBF
             P1: 0x00
             P2: 0x00
             LC: 0x40
             Data: sault (32 bytes) | mac (32 bytes)
             LE: 0x01
        */
        
        context("When it's requesting DELETE_KEY_RECORD, APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getDeleteKeyRecordApdu(badSault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting DELETE_KEY_RECORD command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getDeleteKeyRecordApdu(sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_DELETE_KEY_RECORD
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.DELETE_KEY_RECORD_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             GET_HMAC
             CLA: 0xB0
             INS: 0xBB
             P1: 0x00
             P2: 0x00
             LC: 0x42
             Data: index of key (2 bytes) | sault (32 bytes) | mac (32 bytes)
             LE: 0x22
        */
        
        context("When it's requesting GET_HMAC APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetHmacApdu(index : keyIndex, sault : badSault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_HMAC APDU command with keyIndex of incorrect length", {
            it("throws a error") {
                for badKeyIndex in badKeyIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetHmacApdu(index : badKeyIndex, sault :  sault)   })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_HMAC command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    let apdu = try TonWalletAppletApduCommands.getGetHmacApdu(index : keyIndex, sault :  sault)
                    expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                    expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_HMAC
                    expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                    expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                    var dataField = Data(_  :  keyIndex + sault)
                    let mac = try hmacHelper.computeHmac(data: dataField)
                    dataField.append(mac)
                    expect(apdu.data) == dataField
                    expect(apdu.expectedResponseLength) == TonWalletAppletConstants.GET_HMAC_LE
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
             GET_KEY_CHUNK
             CLA: 0xB0
             INS: 0xB2
             P1: 0x00
             P2: 0x00
             LC: 0x44
             Data: key  index (2 bytes) | startPos (2 bytes) | sault (32 bytes) | mac (32 bytes)
             LE: Key chunk length
        */
        
        context("When it's requesting GET_KEY_CHUNK APDU command with sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetKeyChunkApdu(index : keyIndex, startPos: 0x00, sault : badSault, le : TonWalletAppletConstants.DATA_PORTION_MAX_SIZE)    })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_KEY_CHUNK APDU command with keyIndex of incorrect length", {
            it("throws a error") {
                for badKeyIndex in badKeyIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetKeyChunkApdu(index : badKeyIndex, startPos: 0x00, sault : sault, le : TonWalletAppletConstants.DATA_PORTION_MAX_SIZE)    })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_KEY_CHUNK APDU command with incorrect le", {
            it("throws a error") {
                for badLe in badLEs {
                    expect ( expression: {try TonWalletAppletApduCommands.getGetKeyChunkApdu(index : keyIndex, startPos: 0x00, sault : sault, le : badLe)    })
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_LE_INCORRECT})
                }
            }
        })
        
        context("When it's requesting GET_KEY_CHUNK command", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    for le in 1...CommonConstants.LE_GET_ALL_RESPONSE_DATA {
                        let apdu = try TonWalletAppletApduCommands.getGetKeyChunkApdu(index : keyIndex, startPos: 0x00, sault : sault, le : le)
                        expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                        expect(apdu.instructionCode) == TonWalletAppletApduCommands.INS_GET_KEY_CHUNK
                        expect(apdu.p1Parameter) == TonWalletAppletApduCommands.P1
                        expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                        var dataField = Data(_  :  keyIndex + [0x00, 0x00] + sault)
                        let mac = try hmacHelper.computeHmac(data: dataField)
                        dataField.append(mac)
                        expect(apdu.data) == dataField
                        expect(apdu.expectedResponseLength) == le
                    }
                }
                catch{
                    fail()
                }
            }
        })
        
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
        */

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
        */
        
        context("When it's requesting ADD_KEY_CHUNK/CHANGE_KEY_CHUNK APDU command with sault of incorrect length", {
            it("throws a error") {
                for ins in SEND_KEY_CHUNK_INSTRUCTIONS {
                    for badSault in badSaults {
                        expect ( expression: {try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1 : 0x00, keyChunkOrMacBytes : keyChunk, sault : badSault)     })
                            .to(throwError { (error: Error) in
                                    expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                    }
                }
            }
        })
        
        context("When it's requesting ADD_KEY_CHUNK/CHANGE_KEY_CHUNK_KEY_CHUNK APDU command with keyChunk of incorrect length", {
            it("throws a error") {
                for ins in SEND_KEY_CHUNK_INSTRUCTIONS {
                    for p1 in 0...1 {
                        for badKeyChunk in badKeyChunks {
                            expect ( expression: {try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1 : UInt8(p1), keyChunkOrMacBytes : badKeyChunk, sault : sault)     })
                                .to(throwError { (error: Error) in
                                        expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_CHUNK_BYTES_SIZE_INCORRECT})
                        }
                    }
                }
            }
        })
        
        context("When it's requesting ADD_KEY_CHUNK/CHANGE_KEY_CHUNK APDU command with keyHMac of incorrect length", {
            it("throws a error") {
                for ins in SEND_KEY_CHUNK_INSTRUCTIONS {
                    for badHmac in badHmacBytes {
                        expect ( expression: {try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1 : 0x02, keyChunkOrMacBytes : badHmac , sault : sault)     })
                            .to(throwError { (error: Error) in
                                    expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT})
                    }
                    
                }
            }
        })
        
        context("When it's requesting ADD_KEY_CHUNK/CHANGE_KEY_CHUNK APDU command with incorrect P1", {
            it("throws a error") {
                for ins in SEND_KEY_CHUNK_INSTRUCTIONS {
                    for badP1 in badP1Params {
                        expect ( expression: {try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1 : badP1, keyChunkOrMacBytes : keyChunk, sault : sault)     })
                            .to(throwError { (error: Error) in
                                    expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_APDU_P1_INCORRECT})
                    }
                }
            }
        })
        
        context("When it's requesting ADD_KEY_CHUNK/CHANGE_KEY_CHUNK command for p1=0, 1", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    for ins in SEND_KEY_CHUNK_INSTRUCTIONS {
                        for p1 in 0...1  {
                            let apdu = try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1 : UInt8(p1), keyChunkOrMacBytes : keyChunk, sault : sault)
                            expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                            expect(apdu.instructionCode) == ins
                            expect(apdu.p1Parameter) == UInt8(p1)
                            expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                            var dataField = Data(_  :  [UInt8(keyChunk.count)] + keyChunk  + sault)
                            let mac = try hmacHelper.computeHmac(data: dataField)
                            dataField.append(mac)
                            expect(apdu.data) == dataField
                            expect(apdu.expectedResponseLength) == CommonConstants.LE_NO_RESPONSE_DATA
                        }
                    }
                }
                catch{
                    fail()
                }
            }
        })
        
        context("When it's requesting ADD_KEY_CHUNK/CHANGE_KEY_CHUNK command for p1=2", {
            it("returns NFCISO7816APDU object with correct APDU fields") {
                do {
                    for ins in SEND_KEY_CHUNK_INSTRUCTIONS {
                        let apdu = try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1 : 0x02, keyChunkOrMacBytes : hmac, sault : sault)
                        expect(apdu.instructionClass) == TonWalletAppletApduCommands.WALLET_APPLET_CLA
                        expect(apdu.instructionCode) == ins
                        expect(apdu.p1Parameter) == 0x02
                        expect(apdu.p2Parameter) == TonWalletAppletApduCommands.P2
                        var dataField = Data(_  :  hmac + sault)
                        let mac = try hmacHelper.computeHmac(data : dataField)
                        dataField.append(mac)
                        expect(apdu.data) == dataField
                        expect(apdu.expectedResponseLength) == TonWalletAppletConstants.SEND_CHUNK_LE
                    }
                }
                catch{
                    fail()
                }
            }
        })
        
        /**
            Tests for auxiliary methods
         */

        context("When it's checking sault of incorrect length", {
            it("throws a error") {
                for badSault in badSaults {
                    expect ( expression: {try TonWalletAppletApduCommands.checkSault(badSault)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_SAULT_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's checking hdIndex of incorrect length", {
            it("throws a error") {
                for badHdIndex in badHdIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.checkHdIndex(badHdIndex)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_HD_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's checking key index of incorrect length", {
            it("throws a error") {
                for badKeyIndex in badKeyIndices {
                    expect ( expression: {try TonWalletAppletApduCommands.checkKeyChainKeyIndex(badKeyIndex)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_INDEX_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's checking hmac of incorrect length", {
            it("throws a error") {
                for badHmac in badHmacBytes {
                    expect ( expression: {try TonWalletAppletApduCommands.checkHmac(badHmac)})
                        .to(throwError { (error: Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_KEY_MAC_BYTES_SIZE_INCORRECT})
                }
            }
        })
        
        context("When it's checking incorrect le", {
            it("throws a error") {
                for badLe in badLEs {
                    expect ( expression: {try TonWalletAppletApduCommands.checkLe(badLe)})
                        .to(throwError { (error : Error) in
                                expect(error.localizedDescription) == ResponsesConstants.ERROR_MSG_LE_INCORRECT})
                }
            }
        })
        
    }
}
