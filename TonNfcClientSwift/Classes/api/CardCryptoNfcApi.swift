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
import PromiseKit
import Foundation
import CoreNFC


@available(iOS 13.0, *)
public class CardCryptoNfcApi: TonNfcApi {
    
    public override init() {}
    
    public func verifyPin(pin: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: verifyPin" )
        guard dataVerifier.checkPinSize(pin: pin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: pin, reject : reject) else {
            return
        }
        print("Got PIN:" + pin)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.selectTonAppletAndVerifyPin(pin: pin)
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func getPublicKeyForDefaultPath(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getPublicKeyForDefaultPath")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.getPublicKeyForDefaultPathPromise(startPromise: Promise<Data> { promise in promise.fulfill(Data(_ : []))})
        })
        apduRunner.startScan()
    }
    
    public func checkSerialNumberAndGetPublicKeyForDefaultPath(serialNumber: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: checkSerialNumberAndGetPublicKeyForDefaultPath")
        guard
            dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) else {
            return
        }
        print("Got serialNumber:" + serialNumber)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.getPublicKeyForDefaultPathPromise(startPromise: self.checkSerialNumberPromise(serialNumber))
        })
        apduRunner.startScan()
    }
    
    public func getPublicKey(hdIndex: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getPublicKey" )
        guard dataVerifier.checkHdIndexSize(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex, reject : reject) else {
            return
        }
        print("Got hdIndex:" + hdIndex)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.getPublicKeyPromise(hdIndex, startPromise: Promise<Data> { promise in promise.fulfill(Data(_ : []))})
        })
        apduRunner.startScan()
    }
    
    public func checkSerialNumberAndGetPublicKey(serialNumber: String, hdIndex: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: checkSerialNumberAndGetPublicKey" )
        guard
            dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkHdIndexSize(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex, reject : reject) else {
            return
        }
        print("Got serialNumber:" + serialNumber)
        print("Got hdIndex:" + hdIndex)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.getPublicKeyPromise(hdIndex, startPromise: self.checkSerialNumberPromise(serialNumber))
        })
        apduRunner.startScan()
    }
    
    
    public func signForDefaultHdPath(data: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: signForDefaultHdPath" )
        guard  dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSize(data: data, reject : reject) else {
            return
        }
        print("Got Data:" + data)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signForDefaultHdPathPromise(data, startPromise: Promise<Data> { promise in promise.fulfill(Data(_ : []))})
        })
        apduRunner.startScan()
    }
    
    public func checkSerialNumberAndSignForDefaultHdPath(serialNumber: String, data: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: checkSerialNumberAndSignForDefaultHdPath" )
        guard
            dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSize(data: data, reject : reject) else {
            return
        }
        print("Got serialNumber:" + serialNumber)
        print("Got Data:" + data)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signForDefaultHdPathPromise(data, startPromise: self.checkSerialNumberPromise(serialNumber))
        })
        apduRunner.startScan()
    }
    
    public func verifyPinAndSignForDefaultHdPath(data: String, pin: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: verifyPinAndSignForDefaultHdPath" )
        guard dataVerifier.checkPinSize(pin: pin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: pin, reject : reject) &&
                dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSize(data: data, reject : reject) else {
            return
        }
        print("Got Data:" + data)
        print("Got PIN:" + pin)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signForDefaultHdPathPromise(data, startPromise: self.reselectKeyForHmac()
                                                .then{(response : Data) -> Promise<Data> in
                                                    self.selectTonAppletAndVerifyPin(pin: pin)
                                                }
            )
        })
        apduRunner.startScan()
    }
    
    public func checkSerialNumberAndVerifyPinAndSignForDefaultHdPath(serialNumber: String, data: String, pin: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: checkSerialNumberAndVerifyPinAndSignForDefaultHdPath" )
        guard
            dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkPinSize(pin: pin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: pin, reject : reject) &&
                dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSize(data: data, reject : reject) else {
            return
        }
        print("Got serialNumber:" + serialNumber)
        print("Got Data:" + data)
        print("Got PIN:" + pin)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signForDefaultHdPathPromise(data, startPromise:
                                                self.checkSerialNumberPromise(serialNumber)
                                                .then{(response : Data) -> Promise<Data> in
                                                    self.reselectKeyForHmac()
                                                }
                                                .then{(response : Data) -> Promise<Data> in
                                                    self.selectTonAppletAndVerifyPin(pin: pin)
                                                }
            )
        })
        apduRunner.startScan()
    }
    
    public func sign(data: String, hdIndex: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: sign" )
        guard dataVerifier.checkHdIndexSize(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSizeForCaseWithPath(data: data, reject : reject) else {
            return
        }
        print("Got Data:" + data)
        print("Got hdIndex:" + hdIndex)
        //todo: check correct conversion of hdIndex into byte array
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signPromise(data, hdIndex, startPromise: Promise<Data> { promise in promise.fulfill(Data(_ : []))})
        })
        apduRunner.startScan()
    }
    
    public func checkSerialNumberAndSign(serialNumber: String, data: String, hdIndex: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: checkSerialNumberAndSign" )
        guard
            dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkHdIndexSize(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSizeForCaseWithPath(data: data, reject : reject) else {
            return
        }
        print("Got serialNumber:" + serialNumber)
        print("Got Data:" + data)
        print("Got hdIndex:" + hdIndex)
        //todo: check correct conversion of hdIndex into byte array
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signPromise(data, hdIndex, startPromise: self.checkSerialNumberPromise(serialNumber))
        })
        apduRunner.startScan()
    }
    
    
    
    public func verifyPinAndSign(data: String, hdIndex: String, pin: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: verifyPinAndSign" )
        guard dataVerifier.checkPinSize(pin: pin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: pin, reject : reject) &&
                dataVerifier.checkHdIndexSize(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSizeForCaseWithPath(data: data, reject : reject) else {
            return
        }
        print("Got Data:" + data)
        print("Got hdIndex:" + hdIndex)
        print("Got PIN:" + pin)
        //todo: check correct conversion of hdIndex into byte array
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signPromise(data, hdIndex, startPromise:
                                self.reselectKeyForHmac()
                                .then{(response : Data) -> Promise<Data> in
                                    self.selectTonAppletAndVerifyPin(pin: pin)
                                }
            )
        })
        apduRunner.startScan()
    }
    
    public func checkSerialNumberAndVerifyPinAndSign(serialNumber: String, data: String, hdIndex: String, pin: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: checkSerialNumberAndVerifyPinAndSign" )
        guard
            dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkPinSize(pin: pin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: pin, reject : reject) &&
                dataVerifier.checkHdIndexSize(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkHdIndexFormat(hdIndex: hdIndex, reject : reject) &&
                dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSizeForCaseWithPath(data: data, reject : reject) else {
            return
        }
        print("Got serialNumber:" + serialNumber)
        print("Got Data:" + data)
        print("Got hdIndex:" + hdIndex)
        print("Got PIN:" + pin)
        //todo: check correct conversion of hdIndex into byte array
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.signPromise(data, hdIndex, startPromise:
                                self.checkSerialNumberPromise(serialNumber)
                                .then{(response : Data) -> Promise<Data> in
                                    self.reselectKeyForHmac()
                                }
                                .then{(response : Data) -> Promise<Data> in
                                    self.selectTonAppletAndVerifyPin(pin: pin)
                                }
            )
        })
        apduRunner.startScan()
    }
    
    private func selectTonAppletAndVerifyPin(pin: String) -> Promise<Data> {
        self.selectTonAppletAndGetSault()
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getVerifyPinApdu(pinBytes: ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: pin), sault: sault.bytes))
            }
    }
    
    private func checkSerialNumberPromise(_ serialNumber: String) -> Promise<Data> {
        self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                                                    TonWalletAppletApduCommands.GET_SERIAL_NUMBER_APDU)
            .then{(response : Data)  -> Promise<Data> in
                print(response.makeDigitalString())
                print(serialNumber)
                if (response.makeDigitalString() != serialNumber) {
                    throw ResponsesConstants.ERROR_MSG_CARD_HAVE_INCORRECT_SN
                }
                print(response.makeDigitalString() != serialNumber)
                return Promise<Data> { promise in promise.fulfill(Data(_ : []))}
            }
    }
    
    private func getPublicKeyForDefaultPathPromise(startPromise: Promise<Data>) -> Promise<String> {
        startPromise
            .then{(response : Data) -> Promise<Data> in
                return self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_PUB_KEY_WITH_DEFAULT_PATH_APDU)
            }
            .then{(response : Data)  -> Promise<String> in
                if (response.count != TonWalletAppletConstants.PK_LEN) {
                    throw
                    ResponsesConstants.ERROR_MSG_PUBLIC_KEY_RESPONSE_LEN_INCORRECT
                }
                return self.makeFinalPromise(result : response.hexEncodedString())
            }
    }
    
    private func getPublicKeyPromise(_ hdIndex: String, startPromise: Promise<Data>) -> Promise<String> {
        let hdIndex = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: hdIndex)
        return startPromise
            .then{(response : Data) -> Promise<Data> in
                return self.apduRunner.sendTonWalletAppletApdu(apduCommand: try TonWalletAppletApduCommands.getPublicKeyApdu(hdIndex))
            }
            .then{(response : Data)  -> Promise<String> in
                if (response.count != TonWalletAppletConstants.PK_LEN) {
                    throw
                    ResponsesConstants.ERROR_MSG_PUBLIC_KEY_RESPONSE_LEN_INCORRECT
                }
                return self.makeFinalPromise(result : response.hexEncodedString())
            }
    }
    
    private func signForDefaultHdPathPromise(_ data: String, startPromise: Promise<Data>) -> Promise<String> {
        startPromise
            .then{(response : Data) -> Promise<Data> in
                return self.reselectKeyForHmac()
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
    }
    
    private func signPromise(_ data: String, _ hdIndex: String, startPromise: Promise<Data>) -> Promise<String> {
        startPromise
            .then{(response : Data) -> Promise<Data> in
                return self.reselectKeyForHmac()
            }
            .then{(response : Data) -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand:
                                            try TonWalletAppletApduCommands.getSignShortMessageApdu(dataForSigning: ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: data), hdIndex: ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: hdIndex), sault: sault.bytes))
            }
            .then{(response : Data)  -> Promise<String> in
                if (response.count != TonWalletAppletConstants.SIG_LEN) {
                    throw ResponsesConstants.ERROR_MSG_SIG_RESPONSE_LEN_INCORRECT
                }
                return self.makeFinalPromise(result : response.hexEncodedString())
            }
    }
}
