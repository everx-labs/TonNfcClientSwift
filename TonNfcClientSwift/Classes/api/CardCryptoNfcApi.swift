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

    public func getPublicKeyForDefaultPath(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getPublicKeyForDefaultPath")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_PUB_KEY_WITH_DEFAULT_PATH_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.PK_LEN) {
                        throw
                        ResponsesConstants.ERROR_MSG_PUBLIC_KEY_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
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
        //todo: hdIndex conversion check
        let hdIndex = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: hdIndex)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendApdu(apduCommand:
                    TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
                .then{_ in
                    self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getPublicKeyApdu(hdIndex))
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
    
    public func signForDefaultHdPath(data: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: signForDefaultHdPath" )
        guard  dataVerifier.checkDataFormat(data: data, reject : reject) &&
                dataVerifier.checkDataSize(data: data, reject : reject) else {
            return
        }
        print("Got Data:" + data)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.reselectKeyForHmac()
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
            self.reselectKeyForHmac()
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
