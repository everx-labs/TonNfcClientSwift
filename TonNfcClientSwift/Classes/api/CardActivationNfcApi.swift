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

import PromiseKit
import Foundation
import CoreNFC

@available(iOS 13.0, *)
public class CardActivationNfcApi: CardCoinManagerNfcApi {
    
    public static let ECS_HASH_FIELD = "ecsHash"
    public static let EP_HASH_FIELD = "epHash"
    
    public override init() {}
    
    public func turnOnWallet(authenticationPassword : String, commonSecret : String, initialVector : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        self.turnOnWallet(newPin : TonWalletAppletConstants.DEFAULT_PIN, authenticationPassword : authenticationPassword, commonSecret : commonSecret, initialVector : initialVector, resolve : resolve, reject : reject)
    }

    public func turnOnWallet(newPin : String, authenticationPassword : String, commonSecret : String, initialVector : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: turnOnWallet" )
        guard  dataVerifier.checkPasswordSize(password: authenticationPassword, reject : reject) &&
                dataVerifier.checkPasswordFormat(password: authenticationPassword, reject : reject) &&
                dataVerifier.checkCommonSecretSize(commonSecret: commonSecret, reject : reject) &&
                dataVerifier.checkCommonSecretFormat(commonSecret: commonSecret, reject : reject) &&
                dataVerifier.checkInitialVectorSize(initialVector: initialVector, reject : reject) &&
                dataVerifier.checkInitialVectorFormat(initialVector: initialVector, reject : reject) &&
                dataVerifier.checkPinSize(pin: newPin, reject : reject) &&
                dataVerifier.checkPinFormat(pin: newPin, reject : reject) else {
            return
        }
        print("Got newPin:" + newPin)
        print("Got password:" + authenticationPassword)
        print("Got commonSecret:" + commonSecret)
        print("Got initialVector:" + initialVector)
        let passwordBytes = ByteArrayAndHexHelper.hex(from: authenticationPassword)
        let passwordHash = passwordBytes.hash()
        let commonSecretBytes = ByteArrayAndHexHelper.hex(from: commonSecret)
        let initialVectorBytes = ByteArrayAndHexHelper.hex(from: initialVector)
        let aes128 = AES(key: passwordHash.subdata(in: 0..<16), iv: initialVectorBytes)
        let newPinData = ByteArrayAndHexHelper.digitalStrIntoAsciiUInt8Array(digitalStr: newPin)
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
                    guard appletState == TonWalletAppletConstants.APP_WAITE_AUTHENTICATION_MODE else {
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
                    self.apduRunner.sendCoinManagerAppletApdu(apduCommand: try CoinManagerApduCommands.getChangePinApdu(oldPin : CommonConstants.DEFAULT_PIN, newPin : newPinData))
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_SERIAL_NUMBER_APDU)
                }
                .then{(serialNumber : Data)  -> Promise<Data> in
                    try self.createKeyForHmac(password : passwordBytes, commonSecret : commonSecretBytes, serialNumber : serialNumber.makeDigitalString())
                    return self.apduRunner.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
                }
                .then{(response : Data)  -> Promise<Data> in
                    if (response.count != TonWalletAppletConstants.GET_APP_INFO_LE) {
                        throw ResponsesConstants.ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT
                    }
                    let appletState = response.bytes[0]
                    guard appletState == TonWalletAppletConstants.APP_PERSONALIZED else {
                        throw ResponsesConstants.ERROR_MSG_APPLET_IS_NOT_PERSONALIZED + TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                    }
                    return Promise { promise in promise.fulfill(response)}
                }
                .then{(response : Data)  -> Promise<String> in
                    let state = TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                    return self.makeFinalPromise(result : state)
                }
        })
        apduRunner.startScan()
    }
    
    public func verifyPassword(password : String, initialVector : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: verifyPassword")
        guard  dataVerifier.checkPasswordSize(password: password, reject : reject) &&
                dataVerifier.checkPasswordFormat(password: password, reject : reject) else {
            return
        }
        print("Got password:" + password)
        print("Got initialVector:" + initialVector)
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
    
    
    public func generateSeedAndGetHashes(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: generateSeedAndGetHashes")
        var hashesInfo: [String : String] = [:]
        hashesInfo[JsonHelper.STATUS_FIELD] = ResponsesConstants.SUCCESS_STATUS
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendCoinManagerAppletApdu(apduCommand: CoinManagerApduCommands.GET_ROOT_KEY_STATUS_APDU)
                .then{(response : Data)  -> Promise<Data> in
                    if (response.count == 0) {
                        throw ResponsesConstants.ERROR_MSG_GET_ROOT_KEY_STATUS_RESPONSE_LEN_INCORRECT
                    }
                    let seedStatus = response.bytes[0] == CoinManagerConstants.POSITIVE_ROOT_KEY_STATUS
                    if (!seedStatus) {
                        return self.apduRunner.sendApdu(apduCommand:       CoinManagerApduCommands.RESET_WALLET_APDU).then{(response : Data)  -> Promise<Data> in self.apduRunner.sendApdu(apduCommand: CoinManagerApduCommands.GEN_SEED_FOR_DEFAULT_PIN)}
                    }
                    return Promise { promise in promise.fulfill(Data())}
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
                }
                .then{(response : Data)  -> Promise<Data> in
                    if (response.count != TonWalletAppletConstants.GET_APP_INFO_LE) {
                        throw ResponsesConstants.ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT
                    }
                    let appletState = response.bytes[0]
                    guard appletState == TonWalletAppletConstants.APP_WAITE_AUTHENTICATION_MODE else {
                        throw ResponsesConstants.ERROR_MSG_APPLET_DOES_NOT_WAIT_AUTHORIZATION + TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                    }
                    return Promise { promise in promise.fulfill(Data())}
                }
                .then{(response : Data)  -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_COMMON_SECRET_APDU)
                }
                .then{(response : Data)  -> Promise<Data> in
                    if (response.count != TonWalletAppletConstants.SHA_HASH_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_LEN_INCORRECT
                    }
                    hashesInfo[CardActivationNfcApi.ECS_HASH_FIELD] = response.hexEncodedString()
                    return self.apduRunner.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_PASSWORD_APDU)
                }
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.SHA_HASH_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_LEN_INCORRECT
                    }
                    hashesInfo[CardActivationNfcApi.EP_HASH_FIELD] = response.hexEncodedString()
                    return Promise<String> { promise in
                        promise.fulfill(self.jsonHelper.makeJsonString(data: hashesInfo))
                    }
                }
        })
        apduRunner.startScan()
    }
    
    public func getHashes(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getHashes")
        var hashesInfo: [String : String] = [:]
        hashesInfo[JsonHelper.STATUS_FIELD] = ResponsesConstants.SUCCESS_STATUS
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_COMMON_SECRET_APDU)
                .then{(response : Data)  -> Promise<Data> in
                    if (response.count != TonWalletAppletConstants.SHA_HASH_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_COMMON_SECRET_RESPONSE_LEN_INCORRECT
                    }
                    hashesInfo[CardActivationNfcApi.ECS_HASH_FIELD] = response.hexEncodedString()
                    return self.apduRunner.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_HASH_OF_ENCRYPTED_PASSWORD_APDU)
                }
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.SHA_HASH_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_HASH_OF_ENCRYPTED_PASSWORD_RESPONSE_LEN_INCORRECT
                    }
                    hashesInfo[CardActivationNfcApi.EP_HASH_FIELD] = response.hexEncodedString()
                    return Promise<String> { promise in
                        promise.fulfill(self.jsonHelper.makeJsonString(data: hashesInfo))
                    }
                }
        })
        apduRunner.startScan()
    }
    
    
    public func getHashOfEncryptedCommonSecret(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getHashOfEncryptedCommonSecret")
        apduRunner.setCallback(resolve : resolve, reject : reject)
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
    
    public func getHashOfEncryptedPassword(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getHashOfEncryptedPassword")
        apduRunner.setCallback(resolve : resolve, reject : reject)
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




