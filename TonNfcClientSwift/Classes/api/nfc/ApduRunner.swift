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
import CoreNFC

@available(iOS 13.0, *)
extension NFCISO7816APDU {
    func toHexString() -> String {
        let dataFieldInHex = (self.data ?? Data(_ : [])).hexEncodedString()
        return String(format:"%02X %02X %02X %02X", self.instructionClass, self.instructionCode, self.p1Parameter, self.p2Parameter) + " " + dataFieldInHex + String(format:"%02X", self.expectedResponseLength) + " "
    }
}


@available(iOS 13.0, *)
public class ApduRunner: NSObject, NFCTagReaderSessionDelegate {
    public static let NFC_TAG_CONNECTED_EVENT:String = "nfcTagConnected"
    
    var sessionEx: NFCTagReaderSession?
    var cardOperation: (() -> Promise<String>)?
    var resolve: NfcResolver?
    var reject: NfcRejecter?
    let errorHelper = ErrorHelper.getInstance()
    var resultPromise: Promise<String>?
    var callbackUsed: Bool = false
    
    func setCardOperation(cardOperation: @escaping () -> Promise<String>) {
        self.cardOperation = cardOperation
        
    }
    
    func setCallback(resolve: @escaping NfcResolver, reject: @escaping NfcRejecter) {
        self.resolve = resolve
        self.reject = reject
        self.callbackUsed = false
    }
    
    public static func setNotificator(observer: Any, notificationAction: Selector) {
        NotificationCenter.default.addObserver(observer, selector: notificationAction, name: NSNotification.Name(rawValue: NFC_TAG_CONNECTED_EVENT), object: nil)
    }
    
    func startScan() {
        self.sessionEx = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.sessionEx?.begin()
    }
    

    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard self.resolve != nil && self.reject != nil else {
            print("NfcCallback is empty.")
            return
        }
        guard self.sessionEx != nil else {
            self.callRejectCallback(errMsg: ResponsesConstants.ERROR_MSG_NFC_SESSION_IS_NIL)
            return
        }
        guard self.cardOperation != nil else {
            self.callRejectCallback(errMsg: ResponsesConstants.ERROR_MSG_CARD_OPERATION_EMPTY)
            return
        }
        guard tags.count > 0 else {
            self.callRejectCallback(errMsg: ResponsesConstants.ERROR_MSG_NFC_TAG_NOT_DETECTED)
            return
        }
        if case NFCTag.iso7816(_) = tags.first! {
            sessionEx?.connect(to: tags.first!) { (error: Error?) in
                if let err = error {
                    print( "Error connecting to Nfc Tag" + err.localizedDescription)
                    self.callRejectCallback(errMsg: ResponsesConstants.ERROR_MSG_NFC_TAG_NOT_CONNECTED)
                    return
                }
                
                print("Nfc Tag is connected.")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ApduRunner.NFC_TAG_CONNECTED_EVENT), object: nil)
                //NfcEventEmitter.emitter.sendEvent(withName: NfcEventEmitter.NFC_TAG_CONNECTED_EVENT, body: nil)
                
                self.handleApduResponse(apduResponse : self.cardOperation!())
            }
        }
    }
    
    
    
    private func handleApduResponse(apduResponse: Promise<String>) {
       // Promise in
        self.resultPromise = Promise<String> { promise in
        apduResponse.done{response in
            if (self.callbackUsed == false){
                self.resolve!(response)
                self.invalidateSession()
                self.callbackUsed = true
                promise.fulfill(response)
            }
        }.catch{ error in
            switch error {
                case is NSError: // we throw NSError from sendApdu if card sent error response
                    if (self.callbackUsed == false){
                        self.reject!(ResponsesConstants.CARD_ERROR_TYPE_MSG,/* error.localizedDescription,*/ error as NSError)
                        self.callbackUsed = true
                    }
                    
                default:
                    self.callRejectCallback(errMsg: error.localizedDescription)
                }
            print(error.localizedDescription)
            self.invalidateSession(msg: "Application failure: " +  error.localizedDescription)
            
        }
        }
    }
    
    func sendCoinManagerAppletApdu(apduCommand: NFCISO7816APDU) -> Promise<Data> {
        self.sendApdu(apduCommand: CoinManagerApduCommands.SELECT_COIN_MANAGER_APDU)
            .then{_ in self.sendApdu(apduCommand: apduCommand)}
    }
    
    func sendTonWalletAppletApdu(apduCommand: NFCISO7816APDU) -> Promise<Data> {
        self.sendApdu(apduCommand: TonWalletAppletApduCommands.SELECT_TON_WALLET_APPLET_APDU)
            .then{_ in
                self.sendAppletApduAndCheckAppletState(apduCommand: apduCommand)
            }
    }

    func sendAppletApduAndCheckAppletState(apduCommand: NFCISO7816APDU) -> Promise<Data> {
        let cardPromise = self.sendApdu(apduCommand: TonWalletAppletApduCommands.GET_APP_INFO_APDU)
        if apduCommand.instructionCode == TonWalletAppletApduCommands.INS_GET_APP_INFO {
            return cardPromise
        }
        return cardPromise.then{ (response : Data) -> Promise<Data> in
            guard response.count == TonWalletAppletConstants.GET_APP_INFO_LE else {
                throw ResponsesConstants.ERROR_MSG_STATE_RESPONSE_LEN_INCORRECT
            }
            if TonWalletAppletApduCommands.APPLET_COMMAND_STATE_MAPPING[apduCommand.instructionCode]?.contains(response.last!) ?? false {
                return self.sendApdu(apduCommand: apduCommand)
            }
            throw ResponsesConstants.ERROR_MSG_APDU_NOT_SUPPORTED + " : " + TonWalletAppletApduCommands.APDU_COMMAND_NAMES[apduCommand.instructionCode]! + " in " + TonWalletAppletConstants.APPLET_STATES[response.last!]!
        }
    }
    
    func sendApdu(apduCommand: NFCISO7816APDU) -> Promise<Data> {
        return Promise { promise in
            print("\n\r===============================================================")
            print("===============================================================")
            print(">>> Send apdu  " + apduCommand.toHexString())
            if let commandName = TonWalletAppletApduCommands.APDU_COMMAND_NAMES[apduCommand.instructionCode] {
                print("(" + commandName + ")")
            }
            if let commandName = CoinManagerApduCommands.getApduName(apdu: apduCommand){
                print("(" + commandName + ")")
            }
            if case let NFCTag.iso7816(nfcTag) = self.sessionEx!.connectedTag! {
                nfcTag.sendCommand(apdu: apduCommand) { (response: Data, sw1: UInt8, sw2: UInt8, error: Error?)
                    in
                    
                    print("SW1-SW2: " + String(format: "%02X, %02X", sw1, sw2))
                    
                    guard sw1 == 0x90 && sw2 == 0x00 else {
                        let swCode : Int =  CardErrorCodes.convertSw1Sw2IntoOneSw(sw1 : sw1, sw2 : sw2)
                        let swMessage = CardErrorCodes.CARD_ERROR_MSGS[UInt16(swCode)] ?? "Uknown error"
                        print("Card error message:" + swMessage)
                        print("===============================================================")
                        
                        if let session = self.sessionEx {
                            session.invalidate(errorMessage: "Application failure: " + String(format: "%02X, %02X", sw1, sw2) + ", " + swMessage)
                        }
                        
                        let json = JsonHelper.getInstance().createErrorJsonForCardException(sw: UInt16(swCode), apdu: apduCommand)
                        let error = NSError(domain: ResponsesConstants.CARD_ERROR_TYPE_MSG, code: swCode, userInfo: [NSLocalizedDescriptionKey: json])
                        promise.reject(error)
                        return
                    }
                    
                    if response.count > 0 {
                        print("APDU Response: " + response.hexEncodedString())
                    }
                    print("===============================================================")
                    promise.fulfill(response)
                }
            }
            else {
                print("Tag is empty, make card scanning first")
                throw ResponsesConstants.ERROR_MSG_NFC_TAG_NOT_CONNECTED
            }
        }
    }
    
    func invalidateSession() {
        sessionEx?.invalidate()
    }
    
    func invalidateSession(msg : String) {
        sessionEx?.invalidate(errorMessage: msg)
    }
    
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Nfc session is active")
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Error happend: " + error.localizedDescription)
        callRejectCallback(errMsg: ResponsesConstants.ERROR_NFC_CONNECTION_INTERRUPTED)
    }
    
    private func callRejectCallback(errMsg: String) {
        if (self.callbackUsed == false) {
            errorHelper.callRejectWith(errMsg, reject)
            self.callbackUsed = true
        }
    }
    
}

