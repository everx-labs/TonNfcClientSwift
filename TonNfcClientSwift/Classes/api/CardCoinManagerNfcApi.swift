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
    
    public func generateSeed(pin: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: genGenerateSeed")
        guard dataVerifier.checkPinSize(pin: pin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: pin, reject : reject) else {
            return
        }
        print("Got pin:" + pin)
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
    
    public func changePin(oldPin: String, newPin: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: changePin" )
        guard dataVerifier.checkPinSize(pin: oldPin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: oldPin, reject : reject) &&
                dataVerifier.checkPinSize(pin: newPin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: newPin, reject : reject) else {
            return
        }
        print("Got oldPin:" + oldPin)
        print("Got newPin:" + newPin)
        let oldPin = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: oldPin)
        let newPin = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: newPin)
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
    
    public func resetWallet(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: resetWallet")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendCoinManagerAppletApdu(apduCommand: CoinManagerApduCommands.RESET_WALLET_APDU)
                .then{_ in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func setDeviceLabel(deviceLabel: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: setDeviceLabel")
        guard dataVerifier.checkLabelSize(label: deviceLabel, reject : reject) &&
                dataVerifier.checkLabelFormat(label: deviceLabel, reject : reject) else {
            return
        }
        print("Got deviceLabel: " + deviceLabel)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendApdu(apduCommand:
                    CoinManagerApduCommands.SELECT_COIN_MANAGER_APDU)
                .then{_ in self.apduRunner.sendApdu(apduCommand: try CoinManagerApduCommands.getSetDeviceLabelApdu(label: ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: deviceLabel)))
                }
                .then{_ in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func getRemainingPinTries(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getRemainingPinTries")
        getPinTries(apduCommand: CoinManagerApduCommands.GET_PIN_RTL_APDU, resolve: resolve, reject : reject)
    }
    
    public func getMaxPinTries(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) -> Promise<String>? {
        print("Start card operation: getMaxPinTries")
        getPinTries(apduCommand: CoinManagerApduCommands.GET_PIN_TLT_APDU, resolve: resolve, reject : reject)
        return apduRunner.resultPromise
    }
    
    private func getPinTries(apduCommand: NFCISO7816APDU, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
    
    public func getRootKeyStatus(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getRootKeyStatus")
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
    
    public func getDeviceLabel(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getDeviceLabel")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_DEVICE_LABEL_APDU, errorMsg: ResponsesConstants.ERROR_MSG_GET_DEVICE_LABEL_RESPONSE_LEN_INCORRECT, resolve: resolve, reject : reject
        )
        apduRunner.startScan()
    }
    
    public func getCsn(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getCsn")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_CSN_APDU, errorMsg: ResponsesConstants.ERROR_MSG_GET_CSN_RESPONSE_LEN_INCORRECT, resolve: resolve, reject : reject)
    }
    
    public func getSeVersion(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getSeVersion")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_SE_VERSION_APDU,
            errorMsg: ResponsesConstants.ERROR_MSG_GET_SE_VERSION_RESPONSE_LEN_INCORRECT,resolve: resolve, reject : reject)
    }
    
    public func getAvailableMemory(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getAvailableMemory")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_AVAILABLE_MEMORY_APDU,
                                              errorMsg: ResponsesConstants.ERROR_MSG_GET_AVAILABLE_MEMORY_RESPONSE_LEN_INCORRECT, resolve: resolve, reject : reject)
    }
    
    public func getAppsList(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getAppsList")
        executeCoinManagerOperationAndSendHex(apdu: CoinManagerApduCommands.GET_APPLET_LIST_APDU,
            errorMsg: ResponsesConstants.ERROR_MSG_GET_APPLET_LIST_RESPONSE_LEN_INCORRECT, resolve: resolve, reject : reject)
    }
    
    private func executeCoinManagerOperationAndSendHex(apdu: NFCISO7816APDU, errorMsg: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
