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


extension CFArray {
    func toSwiftArray<T>() -> [T] {
        let array = Array<AnyObject>(_immutableCocoaArray: self)
        return array.compactMap { $0 as? T }
    }
}

extension Dictionary where Key == String, Value == Any {
    var account: String? {
        guard let account = self[kSecAttrAccount as String] as? String else {
            return nil
        }
        return account
    }
}

@available(iOS 13.0, *)
public class TonNfcApi {
    var apduRunner = ApduRunner()
    let dataVerifier = DataVerifier.getInstance()
    let keychainQueryHelper = KeychainQueryHelper.getInstance()
    let hmacHelper = HmacHelper.getInstance()
    let jsonHelper = JsonHelper.getInstance()
    let errorHelper = ErrorHelper.getInstance()
    
    public init() {}
    
    public func setCurrentSerialNumber(serialNumber : String) {
        hmacHelper.currentSerialNumber = serialNumber
    }
    
    public func getCurrentSerialNumberAndPutIntoCallback(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        resolve(jsonHelper.createJson(msg : hmacHelper.currentSerialNumber))
    }
    
    public func getAllSerialNumbers(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start operation: getAllSerialNumbers")
        do {
            let accounts = try getAllAccounts()
            if (accounts.count == 0) {
                resolve(jsonHelper.createJson(msg : ResponsesConstants.HMAC_KEYS_DOES_NOT_FOUND_MSG))
            }
            else {
                var serialNumbers : [String] = []
                for acc in accounts {
                    serialNumbers.append(acc.deletingPrefix(KeychainQueryHelper.HMAC_ACCOUNT))
                }
                resolve(jsonHelper.createJsonWithSerialNumbers(serialNumbers: serialNumbers))
            }
        }
        catch {
            errorHelper.callRejectWith(errMsg : error as! String, reject : reject)
        }
    }
    
    private func getAllAccounts() throws -> [String] {
        let query = keychainQueryHelper.createDictionaryToGetAllKeysFromKeychain()
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &extractedData)
        guard status == errSecItemNotFound || status == errSecSuccess else {
            throw ResponsesConstants.ERROR_MSG_UNABLE_RETRIEVE_ANY_KEY_FROM_IOS_KEYCHAIN
        }
        if status == errSecItemNotFound || extractedData == nil  {
            return []
        }
        let array = extractedData as! CFArray
        let dictionaries: [[String: Any]] = array.toSwiftArray()
        let accounts = dictionaries.compactMap { $0.account }
        return accounts
    }
    
    public func isKeyForHmacExistAndReturnIntoCallback(serialNumber : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start operation: isKeyForHmacExist")
        guard dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) else {
            return
        }
        do {
            let res = try isKeyForHmacExist(serialNumber : serialNumber)
            let msg = res == true ? ResponsesConstants.TRUE_MSG : ResponsesConstants.FALSE_MSG
            resolve(jsonHelper.createJson(msg : msg))
        }
        catch {
            errorHelper.callRejectWith(errMsg : error as! String, reject : reject)
        }
    }
    
    private func isKeyForHmacExist(serialNumber : String) throws  -> Bool {
        let query = keychainQueryHelper.createQueryToCheckKeyExist(serialNumber: serialNumber)
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        guard status == errSecItemNotFound || status == errSecSuccess else {
            throw ResponsesConstants.ERROR_MSG_UNABLE_RETRIEVE_KEY_INFO_FROM_IOS_KEYCHAIN
        }
        return status == errSecSuccess
    }
    
    public func selectKeyForHmacAndReturnIntoCallback(serialNumber : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start operation: selectKeyForHmac")
        guard dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) else {
            return
        }
        do {
            let existFlag = try selectKeyForHmac(serialNumber: serialNumber)
            if (existFlag == true) {
                resolve(jsonHelper.createJson(msg : ResponsesConstants.DONE_MSG))
            }
            else {
                throw ResponsesConstants.ERROR_MSG_KEY_FOR_HMAC_DOES_NOT_EXIST_IN_IOS_KEYCHAIN
            }
        }
        catch {
            errorHelper.callRejectWith(errMsg : error as! String, reject : reject)
        }
    }
    
    func selectKeyForHmac(serialNumber : String) throws -> Bool {
        guard serialNumber.isNumeric == true else {
            throw  ResponsesConstants.ERROR_MSG_SERIAL_NUMBER_NOT_NUMERIC
        }
        guard serialNumber.count == TonWalletAppletConstants.SERIAL_NUMBER_SIZE else {
            throw ResponsesConstants.ERROR_MSG_SERIAL_NUMBER_LEN_INCORRECT
        }
        let existFlag = try isKeyForHmacExist(serialNumber : serialNumber)
        print("Key with such serial number exists: " + String(existFlag))
        if (existFlag == true) {
            setCurrentSerialNumber(serialNumber: serialNumber)
        }
        return existFlag
    }
    
    public func createKeyForHmac(authenticationPassword : String, commonSecret : String, serialNumber : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start operation: createKeyForHmac" )
        guard dataVerifier.checkPasswordSize(password: authenticationPassword, reject : reject) &&
                dataVerifier.checkPasswordFormat(password: authenticationPassword, reject : reject) &&
                dataVerifier.checkCommonSecretSize(commonSecret: commonSecret, reject : reject) &&
                dataVerifier.checkCommonSecretFormat(commonSecret: commonSecret, reject : reject) &&
                dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) else {
            return
        }
        print("Got password:" + authenticationPassword)
        print("Got commonSecret:" + commonSecret)
        print("Got serialNumber:" + serialNumber)
        do {
            let passwordBytes = ByteArrayAndHexHelper.hex(from: authenticationPassword)
            let commonSecretBytes = ByteArrayAndHexHelper.hex(from: commonSecret)
            try self.createKeyForHmac(password : passwordBytes, commonSecret : commonSecretBytes, serialNumber : serialNumber)
            resolve(jsonHelper.createJson(msg : ResponsesConstants.DONE_MSG))
        }
        catch {
            errorHelper.callRejectWith(errMsg : error as! String, reject : reject)
        }
    }
    
    func createKeyForHmac(password : Data, commonSecret : Data, serialNumber : String) throws {
        let existFlag = try isKeyForHmacExist(serialNumber : serialNumber)
        print("Key with such serial number exists: " + String(existFlag))
        let keyForHmac = hmacHelper.computeHmac(key : password.hash(), data : commonSecret)
        let status : OSStatus
        if ( existFlag == true ) {
            let query = keychainQueryHelper.createBasicQuery(serialNumber: serialNumber)
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: keyForHmac as CFData
            ]
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard status == errSecSuccess else {
                throw ResponsesConstants.ERROR_MSG_UNABLE_UPDATE_KEY_IN_IOS_KEYCHAIN
            }
            print("Updated key for hmac")
        }
        else {
            let query = keychainQueryHelper.createQueryToAddKey(serialNumber: serialNumber, keyForHmac: keyForHmac)
            var result: AnyObject?
            status = withUnsafeMutablePointer(to: &result) {
                SecItemAdd(query as CFDictionary, UnsafeMutablePointer($0))
            }
            guard status == errSecSuccess else {
                throw ResponsesConstants.ERROR_MSG_UNABLE_SAVE_KEY_INTO_IOS_KEYCHAIN
            }
            let newAttributes = result as! Dictionary<String, AnyObject>
            print("Added key for hmac:")
            print(newAttributes)
        }
        setCurrentSerialNumber(serialNumber: serialNumber)
    }
    
    public func deleteKeyForHmac(serialNumber : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter)  {
        print("Start operation: deleteKeyForHmac" )
        guard dataVerifier.checkSerialNumberFormat(serialNumber: serialNumber, reject : reject) &&
                dataVerifier.checkSerialNumberSize(serialNumber: serialNumber, reject : reject) else {
            return
        }
        do {
            let existFlag = try selectKeyForHmac(serialNumber: serialNumber)
            if (existFlag == true) {
                let query = keychainQueryHelper.createBasicQuery(serialNumber: serialNumber)
                let status = SecItemDelete(query as CFDictionary)
                guard status == errSecSuccess || status == errSecItemNotFound else {
                    throw ResponsesConstants.ERROR_MSG_UNABLE_DELETE_KEY_FROM_IOS_KEYCHAIN
                }
                if (status == errSecSuccess && hmacHelper.currentSerialNumber == serialNumber) {
                    setCurrentSerialNumber(serialNumber: TonWalletAppletConstants.EMPTY_SERIAL_NUMBER)
                }
                resolve(jsonHelper.createJson(msg : ResponsesConstants.DONE_MSG))
            }
            else {
                throw ResponsesConstants.ERROR_MSG_KEY_FOR_HMAC_DOES_NOT_EXIST_IN_IOS_KEYCHAIN
            }
        }
        catch {
            errorHelper.callRejectWith(errMsg : error as! String, reject : reject)
        }
    }
    
    public func getSault(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getSault")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                    TonWalletAppletApduCommands.GET_SAULT_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.SAULT_LENGTH) {
                        throw ResponsesConstants.ERROR_MSG_SAULT_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    public func getSerialNumber(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getSerialNumber")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                    TonWalletAppletApduCommands.GET_SERIAL_NUMBER_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.SERIAL_NUMBER_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_GET_SERIAL_NUMBER_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.makeDigitalString())
                }
        })
        apduRunner.startScan()
    }
    
    public func getTonAppletState(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getTonAppletState")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.GET_APP_INFO_LE) {
                        throw ResponsesConstants.ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT
                    }
                    //?todo: check that response.bytes[0] contains value from correct range
                    let appletState = TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                    return self.makeFinalPromise(result : appletState)
                }
        })
        apduRunner.startScan()
    }
    
    func executeTonWalletOperationAndSendBool(apdu: NFCISO7816APDU, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: apdu)
                .then{(response : Data)  -> Promise<String> in
                    let boolResponse = response.bytes[0] == 0 ? ResponsesConstants.FALSE_MSG : ResponsesConstants.TRUE_MSG
                    return self.makeFinalPromise(result : boolResponse)
                }
        })
        apduRunner.startScan()
    }
    
    func executeTonWalletOperationAndSendHex(apdu: NFCISO7816APDU, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: apdu)
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    func executeTonWalletOperationAndSendNumericStr(apdu: NFCISO7816APDU, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: apdu)
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : response.makeDigitalString())
                }
        })
        apduRunner.startScan()
    }
    
    func executeTonWalletOperation(apdu: NFCISO7816APDU, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: apdu)
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    func makeFinalPromise(result : String) -> Promise<String> {
        return Promise<String> { promise in
            let json = jsonHelper.createJson(msg: result)
            promise.fulfill(json)
        }
    }
    
    func reselectKeyForHmac() -> Promise<Data> {
        self.selectTonAppletAndGetSerialNumber().then{ (response : Data) -> Promise<Data> in
            let serialNumber = response.makeDigitalString()
            return Promise<Data> { promise in
                print("selectKeyForHmac")
                let res = try self.selectKeyForHmac(serialNumber: serialNumber)
                print(res)
                if (res == true) {
                    promise.fulfill(Data(_ : []))
                }
                else {
                    throw ResponsesConstants.ERROR_MSG_KEY_FOR_HMAC_DOES_NOT_EXIST_IN_IOS_KEYCHAIN
                }
            }
        }
    }
    
    func selectTonAppletAndGetSault() -> Promise<Data> {
        self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                                                    TonWalletAppletApduCommands.GET_SAULT_APDU)
    }
    
    func getSaultPromise() -> Promise<Data> {
        self.apduRunner.sendApdu(apduCommand:
                                    TonWalletAppletApduCommands.GET_SAULT_APDU)
    }
    
    func selectTonAppletAndGetSerialNumber() -> Promise<Data> {
        self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                                                    TonWalletAppletApduCommands.GET_SERIAL_NUMBER_APDU)
    }
    
    func checkStateAndGetSault() -> Promise<Data> {
        self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand:
                                                            TonWalletAppletApduCommands.GET_SAULT_APDU)
    }
}
