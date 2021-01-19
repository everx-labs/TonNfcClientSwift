//
//  CardCryptoNfcApi.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 03.09.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import PromiseKit
import Foundation
import CoreNFC


@available(iOS 13.0, *)
public class CardCryptoNfcApi: TonNfcApi {
    
    public override init() {}

    public func getPublicKeyForDefaultPath() {
        print("Start card operation: getPublicKeyForDefaultPath")
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_PUB_KEY_WITH_DEFAULT_PATH_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.PK_LEN) {
                        throw ResponsesConstants.ERROR_MSG_PUBLIC_KEY_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    public func getPublicKey(hdIndex: String) {
        print("Start card operation: getPublicKey" )
        guard dataVerifier.checkHdIndexSize(hdIndex: hdIndex) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex) else {
            return
        }
        print("Got hdIndex:" + hdIndex)
        //todo: hdIndex conversion check
        let hdIndex = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: hdIndex)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendApdu(apduCommand:
                    TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
                .then{_ in
                    self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getPublicKeyApdu(ind: hdIndex))
                }
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.PK_LEN) {
                        throw ResponsesConstants.ERROR_MSG_PUBLIC_KEY_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    public func verifyPin(pin: String) {
        print("Start card operation: verifyPin" )
        guard dataVerifier.checkPinSize(pin: pin) &&
                dataVerifier.checkPinFormat(pin: pin) else {
            return
        }
        print("Got PIN:" + pin)
        apduRunner.setCardOperation(cardOperation: { () in
            self.selectTonAppletAndVerifyPin(pin: pin)
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func signForDefaultHdPath(data: String, pin: String) {
        print("Start card operation: signForDefaultHdPath" )
        guard dataVerifier.checkPinSize(pin: pin) &&
                dataVerifier.checkPinFormat(pin: pin) &&
                dataVerifier.checkDataFormat(data: data) &&
                dataVerifier.checkDataSize(data: data) else {
            return
        }
        print("Got Data:" + data)
        print("Got PIN:" + pin)
        apduRunner.setCardOperation(cardOperation: { () in
            self.reselectKeyForHmac()
            .then{(response : Data) -> Promise<Data> in
                self.selectTonAppletAndVerifyPin(pin: pin)
            }
            .then{(response : Data) -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand:
                    try TonWalletAppletApduCommands.getSignShortMessageWithDefaultPathApdu(dataForSigning:
                            ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: data), sault: sault.bytes))
            }
            .then{(response : Data)  -> Promise<String> in
                if (response.count != TonWalletAppletConstants.SIG_LEN) {
                    throw ResponsesConstants.ERROR_MSG_SIG_RESPONSE_LEN_INCORRECT
                }
                return self.makeFinalPromise(result : response.hexEncodedString())
            }
        })
        apduRunner.startScan()
    }
    
    public func sign(data: String, hdIndex: String, pin: String) {
        print("Start card operation: sign" )
        guard dataVerifier.checkPinSize(pin: pin) &&
                dataVerifier.checkPinFormat(pin: pin) &&
                dataVerifier.checkHdIndexSize(hdIndex: hdIndex) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex) &&
                dataVerifier.checkDataFormat(data: data) &&
                dataVerifier.checkDataSizeForCaseWithPath(data: data) else {
            return
        }
        print("Got Data:" + data)
        print("Got hdIndex:" + hdIndex)
        print("Got PIN:" + pin)
        //todo: check correct conversion of hdIndex into byte array
        apduRunner.setCardOperation(cardOperation: { () in
            self.reselectKeyForHmac()
            .then{(response : Data) -> Promise<Data> in
                self.selectTonAppletAndVerifyPin(pin: pin)
            }
            .then{(response : Data) -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand:
                    try TonWalletAppletApduCommands.getSignShortMessageApdu(dataForSigning: ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: data), ind: ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: hdIndex), sault: sault.bytes))
            }
            .then{(response : Data)  -> Promise<String> in
                if (response.count != TonWalletAppletConstants.SIG_LEN) {
                    throw ResponsesConstants.ERROR_MSG_SIG_RESPONSE_LEN_INCORRECT
                }
                return self.makeFinalPromise(result : response.hexEncodedString())
            }
        })
        apduRunner.startScan()
    }
    
    private func selectTonAppletAndVerifyPin(pin: String) -> Promise<Data> {
        self.selectTonAppletAndGetSault()
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getVerifyPinApdu(pinBytes: ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: pin), sault: sault.bytes))
            }
    }
}
