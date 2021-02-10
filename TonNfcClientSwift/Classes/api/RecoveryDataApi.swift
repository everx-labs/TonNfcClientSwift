//
//  RecoveryDataApi.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 09.09.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//
import Foundation
import PromiseKit
import Foundation
import CoreNFC


@available(iOS 13.0, *)
public class RecoveryDataApi: TonNfcApi {
    public override init() {}
    
    public func resetRecoveryData(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: resetRecoveryData")
        executeTonWalletOperation(apdu: TonWalletAppletApduCommands.RESET_RECOVERY_DATA_APDU, resolve : resolve, reject : reject)
    }

    public func isRecoveryDataSet(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: isRecoveryDataSet")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                    TonWalletAppletApduCommands.IS_RECOVERY_DATA_SET_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.IS_RECOVERY_DATA_SET_LE) {
                        throw ResponsesConstants.ERROR_IS_RECOVERY_DATA_SET_RESPONSE_LEN_INCORRECT
                    }
                    let boolResponse = response.bytes[0] == 0 ? ResponsesConstants.FALSE_MSG : ResponsesConstants.TRUE_MSG
                    return self.makeFinalPromise(result : boolResponse)
                }
        })
        apduRunner.startScan()
    }
    
    public func getRecoveryDataHash(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getRecoveryDataHash")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                    TonWalletAppletApduCommands.GET_RECOVERY_DATA_HASH_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.SHA_HASH_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_RECOVERY_DATA_HASH_RESPONSE_LEN_INCORRECT
                    }
                    return self.makeFinalPromise(result : response.hexEncodedString())
                }
        })
        apduRunner.startScan()
    }
    
    public func getRecoveryDataLen(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getRecoveryDataLen")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand:
                    TonWalletAppletApduCommands.GET_RECOVERY_DATA_LEN_APDU)
                .then{(response : Data)  -> Promise<String> in
                    if (response.count != TonWalletAppletConstants.GET_RECOVERY_DATA_LEN_LE) {
                        throw ResponsesConstants.ERROR_MSG_RECOVERY_DATA_LENGTH_RESPONSE_LEN_INCORRECT
                    }
                    let len = ByteArrayAndHexHelper.makeShort(src: response.bytes, srcOff: 0)
                    if (len <= 0 || len > TonWalletAppletConstants.RECOVERY_DATA_MAX_SIZE) {
                        throw ResponsesConstants.ERROR_MSG_RECOVERY_DATA_LENGTH_RESPONSE_INCORRECT
                    }
            
                    return self.makeFinalPromise(result : String(len))
                }
        })
        apduRunner.startScan()
    }
    
    public func addRecoveryData(recoveryData: String, resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: addRecoveryData")
        guard dataVerifier.checkRecoveryDataSize(recoveryData: recoveryData, reject : reject) &&
                dataVerifier.checkRecoveryDataFormat(recoveryData: recoveryData, reject : reject) else {
            return
        }
        print("Got recoveryData:" + recoveryData)
        let recoveryDataBytes = ByteArrayAndHexHelper.hexStrToUInt8Array(hexStr: recoveryData)
        let recoveryDataSize = UInt16(recoveryDataBytes.count)
        print("recoveryDataSize = " + String(recoveryDataSize))
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.addRecoveryData(recoveryDataBytes: recoveryDataBytes)
                .then{(response : Data)  -> Promise<String> in
                    return self.makeFinalPromise(result : ResponsesConstants.DONE_MSG)
                }
        })
        apduRunner.startScan()
    }
    
    private func addRecoveryData(recoveryDataBytes: [UInt8]) -> Promise<Data> {
        let numberOfFullPackets = recoveryDataBytes.count / TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE
        print("numberOfFullPackets = " + String(numberOfFullPackets))
        var sendRecoveryDataPromise = self.apduRunner.sendApdu(apduCommand:
                                                            TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
        
        for index in 0..<numberOfFullPackets {
            let newSendRecoveryDataPromise = sendRecoveryDataPromise.then{(response : Data) -> Promise<Data> in
                print("#packet " + String(index))
                let chunk = recoveryDataBytes[range: index * TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE..<(index + 1) * TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE]
                return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getAddRecoveryDataPartApdu(p1: index == 0 ? 0x00 : 0x01, data : chunk))
            }
            sendRecoveryDataPromise = newSendRecoveryDataPromise
        }
        
        let tailLen = recoveryDataBytes.count % TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE
        if tailLen > 0 {
            sendRecoveryDataPromise = sendRecoveryDataPromise.then{(response : Data) -> Promise<Data> in
                let chunk = recoveryDataBytes[range: numberOfFullPackets * TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE..<numberOfFullPackets * TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE + tailLen]
                return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getAddRecoveryDataPartApdu(p1: numberOfFullPackets == 0 ? 0x00 : 0x01, data : chunk))
            }
        }
        
        return sendRecoveryDataPromise.then{(response : Data) -> Promise<Data> in
            self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getAddRecoveryDataPartApdu(p1: 0x02, data: Data(_ : recoveryDataBytes).hash().bytes))
        }
    }
    
    public func getRecoveryData(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) {
        print("Start card operation: getRecoveryData")
        apduRunner.setCallback(resolve : resolve, reject : reject)
        apduRunner.setCardOperation(cardOperation: { () in
            self.apduRunner.sendTonWalletAppletApdu(apduCommand: TonWalletAppletApduCommands.GET_RECOVERY_DATA_LEN_APDU)
                .then{(response : Data) -> Promise<String> in
                    let recoveryDataLen = ByteArrayAndHexHelper.makeShort(src : response.bytes, srcOff : 0)
                    print("Recovery data len = " + String(recoveryDataLen))
                    return self.getRecoveryData(recoveryDataLen : recoveryDataLen)
                }
        })
        apduRunner.startScan()
    }
    
    private func getRecoveryData(recoveryDataLen : Int) -> Promise<String> {
        let numberOfFullPackets = recoveryDataLen / TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE
        print("numberOfFullPackets = " + String(numberOfFullPackets))
        var getRecoveryDataPromise = self.apduRunner.sendApdu(apduCommand:
                                                                TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
        var startPos: UInt16 = 0
        var recoveryData = Data(_ : [])
        
        for index in 0..<numberOfFullPackets {
            let newGetRecoveryDataPromise = getRecoveryDataPromise.then{(response : Data) -> Promise<Data> in
                print("packet# " + String(index))
                return self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getGetRecoveryDataPartApdu(startPositionBytes: [UInt8(startPos >> 8), UInt8(startPos)], le: TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE))
            }
            .then{(chunk : Data) -> Promise<Data> in
                guard chunk.count == TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE else {
                    throw ResponsesConstants.ERROR_RECOVERY_DATA_PORTION_INCORRECT_LEN + String(TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE) + "."
                }
                startPos = startPos + UInt16(TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE)
                recoveryData.append(chunk)
                return Promise { promise in promise.fulfill(Data(_ : []))}
            }
            getRecoveryDataPromise = newGetRecoveryDataPromise
        }
        
        let tailLen = recoveryDataLen % TonWalletAppletConstants.DATA_RECOVERY_PORTION_MAX_SIZE
        if tailLen > 0 {
            getRecoveryDataPromise = getRecoveryDataPromise.then{(response : Data) -> Promise<Data> in
                return  self.apduRunner.sendAppletApduAndCheckAppletState(apduCommand: try TonWalletAppletApduCommands.getGetRecoveryDataPartApdu(startPositionBytes: [UInt8(startPos >> 8), UInt8(startPos)], le: tailLen))
            }
            .then{(chunk : Data) -> Promise<Data> in
                //TODO: check chunk size, do the same for Android
                guard chunk.count == tailLen else {
                    throw ResponsesConstants.ERROR_RECOVERY_DATA_PORTION_INCORRECT_LEN + String(tailLen) + "."
                }
                recoveryData.append(chunk)
                return Promise<Data> { promise in promise.fulfill(recoveryData)}
            }
        }
        return getRecoveryDataPromise.then{(recoveryData : Data) -> Promise<String> in
            return self.makeFinalPromise(result : recoveryData .hexEncodedString())
        }
    }
}
