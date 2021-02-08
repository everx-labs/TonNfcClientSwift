//
//  CardActivationNfcApi.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 03.09.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import PromiseKit
import Foundation
import CoreNFC

@available(iOS 13.0, *)
public class CardActivationNfcApi: CardCoinManagerNfcApi {
    
    public override init() {}

    public func turnOnWallet(newPin : String, password : String, commonSecret : String, initialVector : String, callback: NfcCallback) {
        print("Start card operation: turnOnColdWallet" )
        guard  dataVerifier.checkPasswordSize(password: password, callback: callback) &&
                dataVerifier.checkPasswordFormat(password: password, callback: callback) &&
                dataVerifier.checkCommonSecretSize(commonSecret: commonSecret, callback: callback) &&
                dataVerifier.checkCommonSecretFormat(commonSecret: commonSecret, callback: callback) &&
                dataVerifier.checkInitialVectorSize(initialVector: initialVector, callback: callback) &&
                dataVerifier.checkInitialVectorFormat(initialVector: initialVector, callback: callback) &&
                dataVerifier.checkPinSize(pin: newPin, callback: callback) &&
                dataVerifier.checkPinFormat(pin: newPin, callback: callback) else {
            return
        }
        print("Got newPin:" + newPin)
        print("Got password:" + password)
        print("Got commonSecret:" + commonSecret)
        print("Got initialVector:" + initialVector)
        let passwordBytes = ByteArrayAndHexHelper.hex(from: password)
        let passwordHash = passwordBytes.hash()
        let commonSecretBytes = ByteArrayAndHexHelper.hex(from: commonSecret)
        let initialVectorBytes = ByteArrayAndHexHelper.hex(from: initialVector)
        let aes128 = AES(key: passwordHash.subdata(in: 0..<16), iv: initialVectorBytes)
        let newPinData = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: newPin)
        apduRunner.setCallback(callback: callback)
        apduRunner.setCardOperation(cardOperation: {() in
            self.apduRunner.sendCoinManagerAppletApdu(apduCommand: CoinManagerApduCommands.RESET_WALLET_APDU)
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: CoinManagerApduCommands.GEN_SEED_FOR_DEFAULT_PIN)
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
                }
                .then{(response : Data)  -> Promise<Data> in
                    if (response.count != TonWalletAppletConstants.GET_APP_INFO_LE) {
                        throw ResponsesConstants.ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT
                    }
                    let appletState = response.bytes[0]
                    guard appletState == TonWalletAppletConstants.APP_WAITE_AUTHORIZATION_MODE else {
                        throw ResponsesConstants.ERROR_MSG_APPLET_DOES_NOT_WAIT_AUTHORIZATION + TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                    }
                    return Promise { promise in promise.fulfill(Data())}
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_COMMON_SECRET_APDU)
                }
                .then{(hashOfEncryptedCommonSecretFromCard : Data)  -> Promise<Data> in
                    let encryptedCommonSecret = aes128?.encrypt(msg: commonSecretBytes)
                    guard hashOfEncryptedCommonSecretFromCard == encryptedCommonSecret?.hash() else {
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_INCORRECT
                    }
                    return Promise { promise in promise.fulfill(Data())}
                        
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_PASSWORD_APDU)
                }
                .then{(hashOfEncryptetdPasswordFromCard : Data)  ->  Promise<Data> in
                    let encryptedPassword = aes128?.encrypt(msg: passwordBytes)
                    guard hashOfEncryptetdPasswordFromCard == encryptedPassword?.hash() else{
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_INCORRECT
                    }
                    return Promise { promise in promise.fulfill(Data())}
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getVerifyPasswordApdu(password: passwordBytes.bytes, initialVector: initialVectorBytes.bytes))
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendCoinManagerAppletApdu(apduCommand: try CoinManagerApduCommands.getChangePinApdu(oldPin : TonWalletAppletConstants.DEFAULT_PIN, newPin : newPinData))
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_SERIAL_NUMBER_APDU)
                }
                .then{(serialNumber : Data)  -> Promise<Data> in
                    try self.createKeyForHmac(password : passwordBytes, commonSecret : commonSecretBytes, serialNumber : serialNumber.makeDigitalString())
                    return self.apduRunner.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
                }
                .then{(response : Data)  -> Promise<String> in
                    let state = TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                    return self.makeFinalPromise(result : state)
                }
        })
        apduRunner.startScan()
    }
    
    public func verifyPassword(password : String, initialVector : String, callback: NfcCallback) {
        print("Start card operation: verifyPassword")
        guard  dataVerifier.checkPasswordSize(password: password, callback: callback) &&
                dataVerifier.checkPasswordFormat(password: password, callback: callback) else {
            return
        }
        print("Got password:" + password)
        print("Got initialVector:" + initialVector)
        apduRunner.setCallback(callback: callback)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendApdu(apduCommand:
                    TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
                .then{_ in
                    self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getVerifyPasswordApdu(password: ByteArrayAndHexHelper.hex(from: password).bytes, initialVector: ByteArrayAndHexHelper.hex(from: initialVector).bytes))
                }
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
        
    }
    
    public func getHashOfEncryptedCommonSecret(callback: NfcCallback) {
        print("Start card operation: getHashOfEncryptedCommonSecret")
        apduRunner.setCallback(callback: callback)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_COMMON_SECRET_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.SHA_HASH_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    public func getHashOfEncryptedPassword(callback: NfcCallback) {
        print("Start card operation: getHashOfEncryptedPassword")
        apduRunner.setCallback(callback: callback)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_PASSWORD_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.SHA_HASH_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()        
    }
}




