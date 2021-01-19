//
//  CardCoinManagerNfcApi.swift
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
public class CardCoinManagerNfcApi: TonNfcApi {

    public override init() {}
    
    public func generateSeed(pin: String) {
        print("Start card operation: genGenerateSeed")
        guard dataVerifier.checkPinSize(pin: pin) &&
                dataVerifier.checkPinFormat(pin: pin) else {
            return
        }
        print("Got pin:" + pin)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendApdu(apduCommand: CoinManagerApduCommands.SELECT_COIN_MANAGER_APDU)
                .then{_ in self.apduRunner.sendApdu(apduCommand: try CoinManagerApduCommands.getGenSeedApdu(pin: ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: pin)))
                }
                .then{_ in
                    self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func changePin(oldPin: String, newPin: String) {
        print("Start card operation: changePin" )
        guard dataVerifier.checkPinSize(pin: oldPin) &&
                dataVerifier.checkPinFormat(pin: oldPin) &&
                dataVerifier.checkPinSize(pin: newPin) &&
                dataVerifier.checkPinFormat(pin: newPin) else {
            return
        }
        print("Got oldPin:" + oldPin)
        print("Got newPin:" + newPin)
        let oldPin = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: oldPin)
        let newPin = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: newPin)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendApdu(apduCommand: CoinManagerApduCommands.SELECT_COIN_MANAGER_APDU)
                .then{_ in self.apduRunner.sendApdu(apduCommand: try CoinManagerApduCommands.getChangePinApdu(oldPin: oldPin, newPin: newPin))
                }
                .then{_ in
                    self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func resetWallet() {
        print("Start card operation: resetWallet")
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendCoinManagerAppletApdu(apduCommand: CoinManagerApduCommands.RESET_WALLET_APDU)
                .then{_ in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func setDeviceLabel(label: String) {
        print("Start card operation: setDeviceLabel")
        guard dataVerifier.checkLabelSize(label: label) &&
                dataVerifier.checkLabelFormat(label: label) else {
            return
        }
        print("Got label: " + label)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendApdu(apduCommand:
                    CoinManagerApduCommands.SELECT_COIN_MANAGER_APDU)
                .then{_ in self.apduRunner.sendApdu(apduCommand: try CoinManagerApduCommands.getSetDeviceLabelApdu(label: ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: label)))
                }
                .then{_ in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func getRemainingPinTries() {
        print("Start card operation: getRemainingPinTries")
        getPinTries(apduCommand: CoinManagerApduCommands.GET_PIN_RTL_APDU)
    }
    
    public func getMaxPinTries() {
        print("Start card operation: getMaxPinTries")
        getPinTries(apduCommand: CoinManagerApduCommands.GET_PIN_TLT_APDU)
    }
    
    private func getPinTries(apduCommand: NFCISO7816APDU) {
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendCoinManagerAppletApdu(apduCommand: apduCommand)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count == 0) {
                        throw ResponsesConstants.ERROR_MSG_GET_PIN_TLT_OR_RTL_RESPONSE_LEN_INCORRECT
                    }
                    let res = response.bytes[0]
                    if (res < 0 || res > CoinManagerConstants.MAX_PIN_TRIES) {
                        throw ResponsesConstants.ERROR_MSG_GET_PIN_TLT_OR_RTL_RESPONSE_VAL_INCORRECT
                    }
                    return self.makeFinalPromise(result : String(res))
                }
        })
        apduRunner.startScan()
    }
    
    public func getRootKeyStatus() {
        print("Start card operation: getRootKeyStatus")
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendCoinManagerAppletApdu(apduCommand:
                    CoinManagerApduCommands.GET_ROOT_KEY_STATUS_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count == 0) {
                        throw ResponsesConstants.ERROR_MSG_GET_ROOT_KEY_STATUS_RESPONSE_LEN_INCORRECT
                    }
                    let seedStatus = response.bytes[0] == CoinManagerConstants.POSITIVE_ROOT_KEY_STATUS ? ResponsesConstants.GENERATED_MSG : ResponsesConstants.NOT_GENERATED_MSG
                    return self.makeFinalPromise(result : seedStatus)
                }
        })
        apduRunner.startScan()
    }
    
    public func getDeviceLabel() {
        print("Start card operation: getDeviceLabel")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_DEVICE_LABEL_APDU, errorMsg: ResponsesConstants.ERROR_MSG_GET_DEVICE_LABEL_RESPONSE_LEN_INCORRECT)
    
        apduRunner.startScan()
    }
    
    public func getCsn() {
        print("Start card operation: getCsn")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_CSN_APDU, errorMsg: ResponsesConstants.ERROR_MSG_GET_CSN_RESPONSE_LEN_INCORRECT)
    }
    
    public func getSeVersion() {
        print("Start card operation: getSeVersion")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_SE_VERSION_APDU,
            errorMsg: ResponsesConstants.ERROR_MSG_GET_SE_VERSION_RESPONSE_LEN_INCORRECT)
    }
    
    public func getAvailableMemory() {
        print("Start card operation: getAvailableMemory")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_AVAILABLE_MEMORY_APDU,
            errorMsg: ResponsesConstants.ERROR_MSG_GET_AVAILABLE_MEMORY_RESPONSE_LEN_INCORRECT)
    }
    
    public func getAppsList() {
        print("Start card operation: getAppsList")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_APPLET_LIST_APDU,
            errorMsg: ResponsesConstants.ERROR_MSG_GET_APPLET_LIST_RESPONSE_LEN_INCORRECT)
    }
    
    private func executeCoinManagerOperationAndSendHex(apdu: NFCISO7816APDU, errorMsg: String) {
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendCoinManagerAppletApdu(apduCommand: apdu)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count == 0) {
                        throw errorMsg
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
}
