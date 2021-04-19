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

 public class CardKeyChainNfcApi: TonNfcApi {
    let HMAC_FIELD: String = "hmac"
    let KEY_LENGTH_FIELD: String = "length"
    let NUMBER_OF_KEYS_FIELD: String = "numberOfKeys"
    let OCCUPIED_SIZE_FIELD: String = "occupiedSize"
    let FREE_SIZE_FIELD: String = "freeSize"
    var keyMacs: [Data] = []
    
    public override init() {}
    
    public func getKeyChainDataAboutAllKeys(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getAllHmacsOfKeysFromCard")
        var keyHmacsAndLens = [[String: String]]()
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault.bytes))
                }
                .then{(numOfKeys : Data) -> Promise<Data> in
                    let numOfKeys = ByteArrayAndHexHelper.makeShort(src: numOfKeys.bytes, srcOff: 0)
                    var hmacPromise = Promise<Data> { promise in promise.fulfill(Data(_ : []))}
                    //
                    for ind in 0..<numOfKeys {
                        hmacPromise = hmacPromise.then{ (response : Data) -> Promise<Data> in
                            self.getHmac(keyIndex: UInt16(ind))
                        }
                        .then { (hmacAndLen : Data) -> Promise<Data> in
                           // self.keyMacs.append(Data(_ : hmacAndLen.bytes[range : 0..<TonWalletAppletConstants.HMAC_SHA_SIG_SIZE]))
                            let hmac = Data(_ : hmacAndLen.bytes[range : 0..<TonWalletAppletConstants.HMAC_SHA_SIG_SIZE]).hexEncodedString()
                            let len = String(ByteArrayAndHexHelper.makeShort(src: hmacAndLen.bytes, srcOff: TonWalletAppletConstants.HMAC_SHA_SIG_SIZE))
                            keyHmacsAndLens.append([self.HMAC_FIELD : hmac, self.KEY_LENGTH_FIELD : len
])
                            return Promise<Data> { promise in promise.fulfill(Data(_ : []))}
                        }
                    }
                    
                    return hmacPromise
                }
                .then{(response : Data) -> Promise<String> in
                    Promise<String> { promise in
                        promise.fulfill(self.jsonHelper.makeJsonString(data: keyHmacsAndLens))
                    }
                }
        })
        apduRunner.startScan()
    }
    
    public func getKeyChainInfo(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getKeyChainInfo")
        var keyChainInfo: [String : String] = [:]
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault.bytes))
                }
                .then{(numOfKeys : Data) -> Promise<Data> in
                    keyChainInfo[self.NUMBER_OF_KEYS_FIELD] = String(ByteArrayAndHexHelper.makeShort(src: numOfKeys.bytes, srcOff: 0))
                    return self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getGetOccupiedSizeApdu(sault.bytes))
                }
                .then{(occupiedSize : Data) -> Promise<Data> in
                    keyChainInfo[self.OCCUPIED_SIZE_FIELD] = String(ByteArrayAndHexHelper.makeShort(src: occupiedSize.bytes, srcOff: 0))
                    return self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getGetFreeSizeApdu(sault.bytes))
                }
                .then{(freeSize : Data) -> Promise<Data> in
                    keyChainInfo[self.FREE_SIZE_FIELD] = String(ByteArrayAndHexHelper.makeShort(src: freeSize.bytes, srcOff: 0))
                    return self.getSaultPromise()
                }
                .then{(response : Data) -> Promise<String> in
                    Promise<String> { promise in
                        promise.fulfill(self.jsonHelper.makeJsonString(data: keyChainInfo))
                    }
                }
        })
        apduRunner.startScan()
    }
    
    public func addKeyIntoKeyChain(newKey: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter){
        print("Start card operation: addKeyIntoKeyChain" )
        guard dataVerifier.checkKeySize(key: newKey, reject : reject) &&
                dataVerifier.checkKeyFormat(key: newKey, reject : reject) else {
            return
        }
        print("Got newKey to add:" + newKey)
        //Todo: add verificaion that key was not added already
        let newKeyBytes = ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: newKey)
        let keySize = UInt16(newKeyBytes.count)
        let keySizeBytes = withUnsafeBytes(of: keySize.bigEndian, Array.init)
        print(keySizeBytes.count)
        print(keySizeBytes[0])
        print(keySizeBytes[1])
        print("keySize = " + String(keySize))
        var macOfKey = Data(_ : [])
        var oldNumOfKeys: Int = 0
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.selectTonAppletAndCheckPersonalizedState()
                .then{(response : Data)  -> Promise<Data> in
                    self.reselectKeyForHmac()
                }
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault.bytes))
                }
                .then{(numOfKeys : Data) -> Promise<Data> in
                    oldNumOfKeys = ByteArrayAndHexHelper.makeShort(src: numOfKeys.bytes, srcOff: 0)
                    return self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getCheckAvailableVolForNewKeyApdu(keySize: keySizeBytes , sault: sault.bytes))
                }
                .then{(response : Data) -> Promise<Int> in
                    macOfKey.append(try self.hmacHelper.computeHmac(data: Data(_ : newKeyBytes)))
                    return self.addKey(keyBytes: newKeyBytes, macOfKey: macOfKey.bytes)
                }
                .then{(newNumberOfKeys : Int) -> Promise<String> in
                    if (newNumberOfKeys != (oldNumOfKeys + 1)) {
                        throw ResponsesConstants.ERROR_MSG_NUM_OF_KEYS_INCORRECT_AFTER_ADD
                    }
                    return self.makeFinalPromise(result : macOfKey.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    public func changeKeyInKeyChain(newKey : String, oldKeyHMac : String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: changeKeyInKeyChain" )
        guard dataVerifier.checkMacSize(mac: oldKeyHMac, reject : reject) &&
                dataVerifier.checkMacFormat(mac: oldKeyHMac, reject : reject) &&
                dataVerifier.checkKeySize(key: newKey, reject : reject) &&
                dataVerifier.checkKeyFormat(key: newKey, reject : reject) else {
            return
        }
        print("Got newKey: " + newKey)
        print("Got oldKeyHMac: " + oldKeyHMac)
        let newKeyBytes = ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: newKey)
        var macOfNewKey = Data(_ : [])
        print("newKeySize = " + String(newKeyBytes.count))
        var keyIndexToChange: [UInt8] = []
        var oldNumOfKeys: Int = 0
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.selectTonAppletAndCheckPersonalizedState()
                .then{(response : Data)  -> Promise<Data> in
                    self.reselectKeyForHmac()
                }
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault.bytes))
                }
                .then{(numOfKeys : Data) -> Promise<Data> in
                    oldNumOfKeys = ByteArrayAndHexHelper.makeShort(src: numOfKeys.bytes, srcOff: 0)
                    return self.getIndexAndLenOfKeyInKeyChainPromise(keyHmac: oldKeyHMac)
                }
                .then{(response : Data) -> Promise<Data> in
                    let keyIndex = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 0)
                    let keyLen = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 2)
                    print("keyIndex = " + String(keyIndex))
                    print("keyLen = " + String(keyLen))
                    guard keyLen == newKeyBytes.count else {
                        throw ResponsesConstants.ERROR_MSG_NEW_KEY_LEN_INCORRECT + String(keyLen) + "."
                    }
                    keyIndexToChange = response.bytes[range : 0...1]
                    return Promise<Data> {promise in promise.fulfill(Data(_ : []))}
                }
                .then{(response : Data) -> Promise<Data> in
                    self.checkStateAndGetSault()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getInitiateChangeOfKeyApdu(index: keyIndexToChange, sault: sault.bytes))
                }
                .then{(response : Data) -> Promise<Int> in
                    macOfNewKey.append(try self.hmacHelper.computeHmac(data: Data(_ : newKeyBytes)))
                    return self.changeKey(keyBytes : newKeyBytes, macOfKey: macOfNewKey.bytes)
                }
                .then{(newNumberOfKeys : Int) -> Promise<String> in
                    if (newNumberOfKeys != oldNumOfKeys) {
                        throw ResponsesConstants.ERROR_MSG_NUM_OF_KEYS_INCORRECT_AFTER_CHANGE
                    }
                    return self.makeFinalPromise(result : macOfNewKey.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    private func changeKey(keyBytes : [UInt8], macOfKey: [UInt8])  -> Promise<Int> {
        sendKey(keyBytes : keyBytes, macOfKey: macOfKey, ins : TonWalletAppletApduCommands.INS_CHANGE_KEY_CHUNK)
    }
    
    private func addKey(keyBytes : [UInt8], macOfKey: [UInt8])  -> Promise<Int> {
        sendKey(keyBytes : keyBytes, macOfKey: macOfKey, ins : TonWalletAppletApduCommands.INS_ADD_KEY_CHUNK)
    }
    
    private func sendKey(keyBytes : [UInt8], macOfKey: [UInt8], ins : UInt8) -> Promise<Int> {
        let numberOfFullPackets = keyBytes.count / TonWalletAppletConstants.DATA_PORTION_MAX_SIZE
        print("numberOfFullPackets = " + String(numberOfFullPackets))
        var sendKeyPromise = self.apduRunner.sendApdu(apduCommand:
                                                        TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
        for index in 0..<numberOfFullPackets {
            let newSendKeyPromise = sendKeyPromise.then{(response : Data) -> Promise<Data> in
                self.checkStateAndGetSault()
            }
            .then{(sault : Data) -> Promise<Data> in
                print("#packet " + String(index))
                let keyChunk = keyBytes[range: index * TonWalletAppletConstants.DATA_PORTION_MAX_SIZE..<(index + 1) * TonWalletAppletConstants.DATA_PORTION_MAX_SIZE]
                return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1: index == 0 ? 0x00 : 0x01, keyChunkOrMacBytes: keyChunk, sault: sault.bytes))
            }
            sendKeyPromise = newSendKeyPromise
        }
        
        let tailLen = keyBytes.count % TonWalletAppletConstants.DATA_PORTION_MAX_SIZE
        if tailLen > 0 {
            sendKeyPromise = sendKeyPromise.then{(response : Data) -> Promise<Data> in
                self.checkStateAndGetSault()
            }
            .then{(sault : Data) -> Promise<Data> in
                let keyChunk = keyBytes[range: numberOfFullPackets * TonWalletAppletConstants.DATA_PORTION_MAX_SIZE..<numberOfFullPackets * TonWalletAppletConstants.DATA_PORTION_MAX_SIZE + tailLen]
                return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1: numberOfFullPackets == 0 ? 0x00 : 0x01, keyChunkOrMacBytes: keyChunk, sault: sault.bytes))
            }
        }
        
        return sendKeyPromise.then{(response : Data) -> Promise<Data> in
            self.checkStateAndGetSault()
        }
        .then{(sault : Data) -> Promise<Data> in
            return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getSendKeyChunkApdu(ins : ins, p1: 0x02, keyChunkOrMacBytes: macOfKey, sault: sault.bytes))
        }
        .then{(response : Data) -> Promise<Int> in
            if (response.count != TonWalletAppletConstants.SEND_CHUNK_LE) {
                throw ResponsesConstants.ERROR_MSG_SEND_CHUNK_RESPONSE_LEN_INCORRECT
            }
            let numOfKeys = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 0)
            if (numOfKeys <= 0 || numOfKeys > TonWalletAppletConstants.MAX_NUMBER_OF_KEYS_IN_KEYCHAIN) {
                throw ResponsesConstants.ERROR_MSG_NUMBER_OF_KEYS_RESPONSE_INCORRECT
            }
            return Promise<Int>{promise in promise.fulfill(numOfKeys)}
        }
    }
    
    public func getKeyFromKeyChain(keyMac: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getKeyFromKeyChain" )
        guard dataVerifier.checkMacSize(mac: keyMac, reject : reject) &&
                dataVerifier.checkMacFormat(mac: keyMac, reject : reject) else {
            return
        }
        print("Got mac: " + keyMac)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.getIndexAndLenOfKeyInKeyChainPromise(keyHmac: keyMac)
            .then{(response : Data) -> Promise<String> in
                let keyLen = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 2)
                print("keyIndex = " + String(ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 0)))
                print("keyLen = " + String(keyLen))
                return self.getKeyFromKeyChain(keyLen : keyLen, ind: response.bytes[range : 0...1])
            }
        })
        apduRunner.startScan()
    }
    
    
    private func getKeyFromKeyChain(keyLen : Int, ind : [UInt8]) -> Promise<String> {
        let numberOfFullPackets = keyLen / TonWalletAppletConstants.DATA_PORTION_MAX_SIZE
        print("numberOfFullPackets = " + String(numberOfFullPackets))
        var getKeyPromise = self.apduRunner.sendApdu(apduCommand:
                                                        TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
        var startPos: UInt16 = 0
        var key = Data(_ : [])
        
        for index in 0..<numberOfFullPackets {
            let newGetKeyPromise = getKeyPromise.then{(response : Data) -> Promise<Data> in
                self.checkStateAndGetSault()
            }
            .then{(sault : Data) -> Promise<Data> in
                print("packet# " + String(index))
                return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getGetKeyChunkApdu(ind: ind, startPos: startPos, sault: sault.bytes, le: TonWalletAppletConstants.DATA_PORTION_MAX_SIZE))
                
            }
            .then{(keyChunk : Data) -> Promise<Data> in
                guard keyChunk.count == TonWalletAppletConstants.DATA_PORTION_MAX_SIZE else {
                    throw ResponsesConstants.ERROR_KEY_DATA_PORTION_INCORRECT_LEN + String(TonWalletAppletConstants.DATA_PORTION_MAX_SIZE) + "."
                }
                startPos = startPos + UInt16(TonWalletAppletConstants.DATA_PORTION_MAX_SIZE)
                key.append(keyChunk)
                return Promise { promise in promise.fulfill(key)}
            }
            getKeyPromise = newGetKeyPromise
        }
        
        let tailLen = keyLen % TonWalletAppletConstants.DATA_PORTION_MAX_SIZE
        if tailLen > 0 {
            getKeyPromise = getKeyPromise.then{(response : Data) -> Promise<Data> in
                self.checkStateAndGetSault()
            }
            .then{(sault : Data) -> Promise<Data> in
                return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getGetKeyChunkApdu(ind: ind, startPos: startPos, sault: sault.bytes, le: tailLen))
            }
            .then{(keyChunk : Data) -> Promise<Data> in
                guard keyChunk.count == tailLen else {
                    throw ResponsesConstants.ERROR_KEY_DATA_PORTION_INCORRECT_LEN + String(tailLen) + "."
                }
                key.append(keyChunk)
                return Promise<Data> { promise in promise.fulfill(key)}
            }
        }
        return getKeyPromise.then{(key : Data) -> Promise<String> in
            print("KEY = " + key.hexEncodedString())
            return self.makeFinalPromise(result : key.hexEncodedString())
        }
    }
    
    public func deleteKeyFromKeyChain(keyMac: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: deleteKeyFromKeyChain" )
        guard dataVerifier.checkMacSize(mac: keyMac, reject : reject) &&
                dataVerifier.checkMacFormat(mac: keyMac, reject : reject) else {
            return
        }
        print("Got mac: " + keyMac)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.selectTonAppletAndCheckDeleteState()
            .then{(response : Data)  -> Promise<Data> in
                self.reselectKeyForHmac()
            }
            .then{(result : Data) -> Promise<Data> in
                self.getIndexAndLenOfKeyInKeyChainPromise(keyHmac: keyMac)
            }
            .then{(response : Data) -> Promise<Data> in
                let keyLen = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 2)
                print("keyIndex = " + String(ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 0)))
                print("keyLen = " + String(keyLen))
                return self.initiateDeleteOfKeyPromise(keyIndex: response.bytes[range : 0...1])
            }
            .then{(response : Data) -> Promise<Int> in
                self.getDeleteKeyChunkNumOfPacketsPromise()
            }
            .then{(deleteKeyChunkNumOfPackets : Int)  -> Promise<Data> in
                print("deleteKeyChunkNumOfPackets = " + String(deleteKeyChunkNumOfPackets))
                var deleteKeyChunkPromise = self.apduRunner.sendApdu(apduCommand:
                    TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
                for index in 0...deleteKeyChunkNumOfPackets {
                    let newDeleteKeyChunkPromise = deleteKeyChunkPromise.then{(response : Data) -> Promise<Data> in
                        self.checkStateAndGetSault()
                    }
                    .then{(sault : Data) -> Promise<Data> in
                        print("#iteration " + String(index))
                        return self.deleteKeyChunkPromise(sault: sault)
                    }
                    deleteKeyChunkPromise = newDeleteKeyChunkPromise
                }
                
                return deleteKeyChunkPromise
            }
            .then{(response : Data) -> Promise<Int> in
                self.getDeleteKeyRecordNumOfPacketsPromise()
            }
            .then{(deleteKeyRecordNumOfPackets : Int)  -> Promise<Data> in
                print("deleteKeyRecordNumOfPackets = " + String(deleteKeyRecordNumOfPackets))
                var deleteKeyRecordPromise = self.apduRunner.sendApdu(apduCommand:
                    TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
                for index in 0...deleteKeyRecordNumOfPackets {
                    let newDeleteKeyRecordPromise = deleteKeyRecordPromise.then{(response : Data) -> Promise<Data> in
                        self.checkStateAndGetSault()
                    }
                    .then{(sault : Data) -> Promise<Data> in
                        print("#iteration " + String(index))
                        return self.deleteKeyRecordPromise(sault: sault)
                    }
                    deleteKeyRecordPromise = newDeleteKeyRecordPromise
                }
                
                return deleteKeyRecordPromise
            }
            .then{(response : Data) -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault.bytes))
            }
            .then{(response : Data)  -> Promise<String> in
                return self.makeFinalPromise(result : String(ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)))
                
            }
        })
        
        apduRunner.startScan()
    }
    
    public func finishDeleteKeyFromKeyChainAfterInterruption(keyMac: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: finishDeleteKeyFromKeyChainAfterInterruption" )
        guard dataVerifier.checkMacSize(mac: keyMac, reject : reject) &&
                dataVerifier.checkMacFormat(mac: keyMac, reject : reject) else {
            return
        }
        print("Got mac: " + keyMac)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.selectTonAppletAndCheckDeleteState()
            .then{(response : Data)  -> Promise<Data> in
                self.reselectKeyForHmac()
            }
            .then{(response : Data)  -> Promise<Int> in
                self.getDeleteKeyChunkNumOfPacketsPromise()
            }
            .then{(deleteKeyChunkNumOfPackets : Int)  -> Promise<Data> in
                print("deleteKeyChunkNumOfPackets = " + String(deleteKeyChunkNumOfPackets))
                var deleteKeyChunkPromise = Promise<Data> {promise in promise.fulfill(Data(_ : []))}
                var deleteKeyChunkIsDone = 0
                for index in 0...deleteKeyChunkNumOfPackets {
                    let newDeleteKeyChunkPromise = deleteKeyChunkPromise.then{(response : Data) -> Promise<Data> in
                        if deleteKeyChunkIsDone == 1 {
                            return Promise<Data> { promise in promise.fulfill(Data(_:[1]))}
                        }
                        else {
                            return self.checkStateAndGetSault()
                        }
                    }
                    .then{(sault : Data) -> Promise<Data> in
                        print("#iteration " + String(index))
                        return self.deleteKeyChunkPromise(sault: sault)
                    }
                    .then{(response : Data)  -> Promise<Data> in
                        deleteKeyChunkIsDone = Int(response.bytes[0])
                        print("deleteKeyChunkIsDone = " + String(deleteKeyChunkIsDone))
                        return Promise<Data> { promise in promise.fulfill(Data(_:[]))}
                    }
                    
                    deleteKeyChunkPromise = newDeleteKeyChunkPromise
                }
                
                return deleteKeyChunkPromise
            }
            .then{(response : Data) -> Promise<Int> in
                self.getDeleteKeyRecordNumOfPacketsPromise()
            }
            .then{(deleteKeyRecordNumOfPackets : Int)  -> Promise<Data> in
                print("deleteKeyRecordNumOfPackets = " + String(deleteKeyRecordNumOfPackets))
                var deleteKeyRecordPromise = Promise<Data> {promise in promise.fulfill(Data(_ : []))}
                var deleteKeyRecordIsDone = 0
                for index in 0...deleteKeyRecordNumOfPackets {
                    let newDeleteKeyRecordPromise = deleteKeyRecordPromise.then{(response : Data) -> Promise<Data> in
                        if deleteKeyRecordIsDone == 1 {
                            return Promise<Data> { promise in promise.fulfill(Data(_:[1]))}
                        }
                        else {
                            return self.checkStateAndGetSault()
                        }
                    }
                    .then{(sault : Data) -> Promise<Data> in
                        print("#iteration " + String(index))
                        return self.deleteKeyRecordPromise(sault: sault)
                    }
                    .then{(response : Data)  -> Promise<Data> in
                        deleteKeyRecordIsDone = Int(response.bytes[0])
                        print("deleteKeyRecordIsDone = " + String(deleteKeyRecordIsDone))
                        return Promise<Data> { promise in promise.fulfill(Data(_:[]))}
                    }
                    deleteKeyRecordPromise = newDeleteKeyRecordPromise
                }
                
                return deleteKeyRecordPromise
            }
            .then{(response : Data) -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault.bytes))
            }
            .then{(response : Data)  -> Promise<String> in
                return self.makeFinalPromise(result : String(ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)))
            }
        })
        
        apduRunner.startScan()
    }
    
    private func initiateDeleteOfKeyPromise(keyIndex: [UInt8]) -> Promise<Data> {
        return self.selectTonAppletAndCheckPersonalizedState()
            .then{(response : Data)  -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getInitiateDeleteOfKeyApdu(index:keyIndex, sault: sault.bytes))
            }
            .then{(response : Data) -> Promise<Data> in
                if (response.count != TonWalletAppletConstants.INITIATE_DELETE_KEY_LE) {
                    throw ResponsesConstants.ERROR_MSG_INITIATE_DELETE_KEY_RESPONSE_LEN_INCORRECT
                }
                let len = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 2)
                if (len <= 0 || len > TonWalletAppletConstants.MAX_KEY_SIZE_IN_KEYCHAIN) {
                    throw ResponsesConstants.ERROR_MSG_KEY_LENGTH_INCORRECT
                }
                return Promise{promise in promise.fulfill(Data(_ : []))}
            }
    }
    
    private func deleteKeyChunkPromise(sault : Data) -> Promise<Data>{
        return Promise{promise in promise.fulfill(Data(_ : []))}
            .then{_ in self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getDeleteKeyChunkApdu(sault.bytes))
            }
            .then{(response : Data) -> Promise<Data> in
                if (response.count != TonWalletAppletConstants.DELETE_KEY_CHUNK_LE) {
                    throw ResponsesConstants.ERROR_MSG_DELETE_KEY_CHUNK_RESPONSE_LEN_INCORRECT
                }
                let status = response.bytes[0]
                if (status < 0 || status > 2) {
                    throw ResponsesConstants.ERROR_MSG_DELETE_KEY_CHUNK_RESPONSE_INCORRECT
                }
                return Promise { promise in promise.fulfill(response)}
            }
    }
    
    private func deleteKeyRecordPromise(sault : Data) -> Promise<Data> {
        return Promise{promise in promise.fulfill(Data(_ : []))}
            .then{_ in self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getDeleteKeyRecordApdu(sault.bytes))
            }
            .then{(response : Data) -> Promise<Data> in
                if (response.count != TonWalletAppletConstants.DELETE_KEY_RECORD_LE) {
                    throw ResponsesConstants.ERROR_MSG_DELETE_KEY_RECORD_RESPONSE_LEN_INCORRECT
                }
                let status = response.bytes[0]
                if (status < 0 || status > 2) {
                    throw ResponsesConstants.ERROR_MSG_DELETE_KEY_RECORD_RESPONSE_INCORRECT
                }
                return Promise { promise in promise.fulfill(response)}
            }
    }
    
    public func getDeleteKeyRecordNumOfPackets(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getDeleteKeyRecordNumOfPackets")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            return self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Int> in
                    self.getDeleteKeyRecordNumOfPacketsPromise()
                }
                .then{(response : Int)  -> Promise<String> in
                    return self.makeFinalPromise(result : String(response))
                }
        })
        apduRunner.startScan()
    }
    
    private func getDeleteKeyRecordNumOfPacketsPromise() -> Promise<Int> {
        self.selectTonAppletAndGetSault()
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getDeleteKeyRecordNumOfPacketsApdu(sault.bytes))
            }
            .then{(response : Data)  -> Promise<Int> in
                if (response.count != TonWalletAppletConstants.GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_LE) {
                    throw ResponsesConstants.ERROR_MSG_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_RESPONSE_LEN_INCORRECT
                }
                let num = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 0)
                if (num < 0) {
                    throw ResponsesConstants.ERROR_MSG_GET_DELETE_KEY_RECORD_NUM_OF_PACKETS_RESPONSE_INCORRECT
                }
                return Promise<Int>{promise in promise.fulfill(ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0))}
            }
    }
    
    public func getDeleteKeyChunkNumOfPackets(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getDeleteKeyChunkNumOfPackets")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            return self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Int> in
                    self.getDeleteKeyChunkNumOfPacketsPromise()
                }
                .then{(response : Int)  -> Promise<String> in
                    return self.makeFinalPromise(result : String(response))
                }
        })
        apduRunner.startScan()
    }
    
    private func getDeleteKeyChunkNumOfPacketsPromise() -> Promise<Int> {
        self.selectTonAppletAndGetSault()
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getDeleteKeyChunkNumOfPacketsApdu(sault.bytes))
            }
            .then{(response : Data)  -> Promise<Int> in
                if (response.count != TonWalletAppletConstants.GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_LE) {
                    throw ResponsesConstants.ERROR_MSG_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_RESPONSE_LEN_INCORRECT
                }
                let num = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 0)
                if (num < 0) {
                    throw ResponsesConstants.ERROR_MSG_GET_DELETE_KEY_CHUNK_NUM_OF_PACKETS_RESPONSE_INCORRECT
                }
                return Promise<Int>{promise in promise.fulfill(ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0))}
            }
    }
    
    public func resetKeyChain(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation resetKeyChain" )
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            return self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getResetKeyChainApdu(sault.bytes))
                }
                .then{(response : Data)  -> Promise<String> in
                    self.keyMacs = []
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    
    public func getNumberOfKeys(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getNumberOfKeys" )
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            return self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getNumberOfKeysApdu(sault.bytes))
                }
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.GET_NUMBER_OF_KEYS_LE) {
                        throw ResponsesConstants.ERROR_MSG_GET_NUMBER_OF_KEYS_RESPONSE_LEN_INCORRECT
                    }
                    let numOfKeys = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)
                    if (numOfKeys < 0 || numOfKeys > TonWalletAppletConstants.MAX_NUMBER_OF_KEYS_IN_KEYCHAIN) {
                        throw ResponsesConstants.ERROR_MSG_NUMBER_OF_KEYS_RESPONSE_INCORRECT
                    }
                    return self.makeFinalPromise(result : String(numOfKeys))
                }
        })
        apduRunner.startScan()
    }
    
    public func getOccupiedStorageSize(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getOccupiedSize")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            return self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getGetOccupiedSizeApdu(sault.bytes))
                }
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.GET_OCCUPIED_SIZE_LE){
                        throw ResponsesConstants.ERROR_MSG_GET_OCCUPIED_SIZE_RESPONSE_LEN_INCORRECT
                    }
                    let size = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)
                    if (size < 0) {
                        throw ResponsesConstants.ERROR_MSG_OCCUPIED_SIZE_RESPONSE_INCORRECT
                    }
                    return self.makeFinalPromise(result : String(size))
                }
        })
        apduRunner.startScan()
    }
    
    public func getFreeStorageSize(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getFreeSize")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            return self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getGetFreeSizeApdu(sault.bytes))
                }
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.GET_FREE_SIZE_LE){
                        throw ResponsesConstants.ERROR_MSG_GET_FREE_SIZE_RESPONSE_LEN_INCORRECT
                    }
                    let size = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)
                    if (size < 0) {
                        throw ResponsesConstants.ERROR_MSG_FREE_SIZE_RESPONSE_INCORRECT
                    }
                    return self.makeFinalPromise(result : String(size))
                }
        })
        apduRunner.startScan()
    }
    
    public func checkKeyHmacConsistency(keyHmac: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter){
        print("Start card operation: checkKeyHmacConsistency" )
        guard dataVerifier.checkMacSize(mac: keyHmac, reject : reject) &&
                dataVerifier.checkMacFormat(mac: keyHmac, reject : reject) else {
            return
        }
        print("Got keyHmac:" + keyHmac)
        let keyHmacBytes = ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: keyHmac)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            return self.reselectKeyForHmac()
                .then{(response : Data) -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getCheckKeyHmacConsistencyApdu(keyHmac: keyHmacBytes, sault: sault.bytes))
                }
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    public func getIndexAndLenOfKeyInKeyChain(keyHmac: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter){
        print("Start card operation: getIndexAndLenOfKeyInKeyChain" )
        guard dataVerifier.checkMacSize(mac: keyHmac, reject : reject) &&
                dataVerifier.checkMacFormat(mac: keyHmac, reject : reject) else {
            return
        }
        print("Got keyHmac:" + keyHmac)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.getIndexAndLenOfKeyInKeyChainPromise(keyHmac: keyHmac)
                .then{(response : (Data))  -> Promise<String> in
                    let index = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)
                    let len = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 2)
                    return self.makeFinalPromise(result : self.jsonHelper.createJson(index : index, len : len))
                }
        })
        apduRunner.startScan()
    }
    
    private func getIndexAndLenOfKeyInKeyChainPromise(keyHmac: String) -> Promise<Data>{
        let keyHmacBytes = ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: keyHmac)
        return self.reselectKeyForHmac()
            .then{(response : Data) -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getGetIndexAndLenOfKeyInKeyChainApdu(keyHmac: keyHmacBytes, sault: sault.bytes))
            }
            .then{(response : Data)  -> Promise<Data> in
                if (response.count != TonWalletAppletConstants.GET_KEY_INDEX_IN_STORAGE_AND_LEN_LE) {
                    throw ResponsesConstants.ERROR_MSG_GET_KEY_INDEX_IN_STORAGE_AND_LEN_RESPONSE_LEN_INCORRECT
                }
                let index = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)
                if (index < 0 || index > TonWalletAppletConstants.MAX_NUMBER_OF_KEYS_IN_KEYCHAIN - 1) {
                    throw ResponsesConstants.ERROR_MSG_KEY_INDEX_INCORRECT
                }
                let len = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 2)
                if (len <= 0 || len > TonWalletAppletConstants.MAX_KEY_SIZE_IN_KEYCHAIN) {
                    throw ResponsesConstants.ERROR_MSG_KEY_LENGTH_INCORRECT
                }
                return Promise{promise in promise.fulfill(response)}
            }
    }
    
    public func checkAvailableVolForNewKey(keySize: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter){
        print("Start card operation: checkAvailableVolForNewKey")
        let keySizeVal = UInt16(keySize) ?? 0
        guard dataVerifier.checkKeySizeVal(keySizeVal : keySizeVal, reject : reject) else {
            return
        }
        print("Got keySize:" + keySize)
        let keySize = UInt16(keySize)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.selectTonAppletAndCheckPersonalizedState()
                .then{(response : Data)  -> Promise<Data> in
                    self.getSaultPromise()
                }
                .then{(sault : Data) -> Promise<Data> in
                    self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getCheckAvailableVolForNewKeyApdu(keySize: [UInt8(keySize! >> 8), UInt8(keySize!)], sault: sault.bytes))
                }
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    private func getHmac(keyIndex: UInt16) -> Promise<Data> {
        self.reselectKeyForHmac()
            .then{(response : Data) -> Promise<Data> in
                self.getSaultPromise()
            }
            .then{(sault : Data) -> Promise<Data> in
                self.apduRunner.sendApdu(apduCommand: try TonWalletAppletApduCommands.getGetHmacApdu(ind: [UInt8(keyIndex >> 8), UInt8(keyIndex)], sault: sault.bytes))
            }
            .then{(response : Data)  -> Promise<Data> in
                if (response.count != TonWalletAppletConstants.HMAC_SHA_SIG_SIZE + 2){
                    throw ResponsesConstants.ERROR_MSG_GET_HMAC_RESPONSE_LEN_INCORRECT
                }
                return Promise {promise in promise.fulfill(response)}
            }
    }
    
    public func getHmac(index: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter){
        print("Start card operation: getHmac" )
        guard dataVerifier.checkKeyIndexFormat(index : index, reject : reject) else {
            return
        }
        let keyIndex = UInt16(index) ?? 0
        guard dataVerifier.checkKeyIndexSize(index : keyIndex, reject : reject) else {
            return
        }
        print("Got index of key:" + index)
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.getHmac(keyIndex: keyIndex)
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    private func selectTonAppletAndCheckPersonalizedState() -> Promise<Data> {
        self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
            .then{(response : Data)  -> Promise<Data> in
                if (response.count != TonWalletAppletConstants.GET_APP_INFO_LE) {
                    throw ResponsesConstants.ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT
                }
                let appletState = response.bytes[0]
                guard appletState == TonWalletAppletConstants.APP_PERSONALIZED else {
                    throw ResponsesConstants.ERROR_MSG_APPLET_IS_NOT_PERSONALIZED + TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                }
                return Promise { promise in promise.fulfill(Data())}
            }
    }
    
    private func selectTonAppletAndCheckDeleteState() -> Promise<Data> {
        self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
            .then{(response : Data)  -> Promise<Data> in
                if (response.count != TonWalletAppletConstants.GET_APP_INFO_LE) {
                    throw ResponsesConstants.ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT
                }
                let appletState = response.bytes[0]
                guard appletState == TonWalletAppletConstants.APP_DELETE_KEY_FROM_KEYCHAIN_MODE else {
                    throw ResponsesConstants.ERROR_MSG_APPLET_DOES_NOT_WAIT_TO_DELETE_KEY + TonWalletAppletConstants.APPLET_STATES[response.bytes[0]]!
                }
                return Promise { promise in promise.fulfill(Data())}
            }
    }
}
