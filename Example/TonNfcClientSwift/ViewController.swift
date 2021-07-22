//
//  ViewController.swift
//  TonNfcClientSwift
//
//  Created by alinaT95 on 01/19/2021.
//  Copyright (c) 2021 alinaT95. All rights reserved.
//

import UIKit
import TonNfcClientSwift
import PromiseKit

@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    let DEFAULT_PIN = "5555"
    let SERIAL_NUMBER = "504394802433901126813236"
    let COMMON_SECRET = "7256EFE7A77AFC7E9088266EF27A93CB01CD9432E0DB66D600745D506EE04AC4"
    let IV = "1A550F4B413D0E971C28293F9183EA8A"
    let PASSWORD  = "F4B072E1DF2DB7CF6CD0CD681EC5CD2D071458D278E6546763CBB4860F8082FE14418C8A8A55E2106CBC6CB1174F4BA6D827A26A2D205F99B7E00401DA4C15ACC943274B92258114B5E11C16DA64484034F93771547FBE60DA70E273E6BD64F8A4201A9913B386BCA55B6678CFD7E7E68A646A7543E9E439DD5B60B9615079FE"
    
    let cardCryptoNfcApi : CardCryptoNfcApi = CardCryptoNfcApi()
    let cardCoinManagerNfcApi: CardCoinManagerNfcApi = CardCoinManagerNfcApi()
    let cardActivationApi : CardActivationNfcApi = CardActivationNfcApi()
    let cardKeyChainNfcApi : CardKeyChainNfcApi = CardKeyChainNfcApi()
    let nfcApi : NfcApi = NfcApi()
    
    @IBAction func checkIsNfcSupported(_ sender: Any) {
        Promise<String> { promise in
            nfcApi.checkIfNfcSupported(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("checkIsNfcSupported result : " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func generateSeed(_ sender: Any) {
        Promise<String> { promise in
            cardCoinManagerNfcApi.generateSeed(pin: "5555", resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("Generate seed result : " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    @IBAction func getTonAppletState(_ sender: Any) {
        Promise<String> { promise in
            cardKeyChainNfcApi.getTonAppletState(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("applet state : " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func getKeyChainInfo(_ sender: Any) {
        Promise<String> { promise in
            cardKeyChainNfcApi.getKeyChainInfo(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("KeyChain info : " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @objc func catchNotification() {
        print("Nfc connected!!!!!!!!!!")
    }
    
    @IBAction func verifyPIN(_ sender: Any) {
        let pin = "5555"
        Promise<String> { promise in
            cardCryptoNfcApi.createKeyForHmac(authenticationPassword: PASSWORD, commonSecret: COMMON_SECRET, serialNumber: SERIAL_NUMBER, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .then{(response : String)  -> Promise<String> in
            print("Response from createKeyForHmac : " + response)
            return Promise<String> { promise in
                self.cardCryptoNfcApi.verifyPin(pin: pin, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
            }
        }
        .done{response in
            print("Pin verified : "  + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func addChangeKey(_ sender: Any) {
        Promise<String> { promise in
            cardKeyChainNfcApi.resetKeyChain(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .then{(response : String)  -> Promise<String> in
            print("Response from resetKeyChain : " + response)
            let key = "0000"
            sleep(5)
            return Promise<String> { promise in
                self.cardKeyChainNfcApi.addKeyIntoKeyChain(newKey: key,  resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
            }
        }
        .then{(response : String)  -> Promise<String> in
            print("Response from addKeyIntoKeyChain : " + response)
            let mac = try self.extractMessage(jsonStr : response)
            let key = "0011"
            sleep(5)
            return Promise<String> { promise in
                self.cardKeyChainNfcApi.changeKeyInKeyChain(newKey: key, oldKeyHMac: mac,  resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
            }
        }
        .done{response in
            print("Response from changeKeyInKeyChain : " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func getKeysInfo(_ sender: Any) {
        Promise<String> { promise in
            cardKeyChainNfcApi.getKeyChainDataAboutAllKeys(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("KeyChainDataAboutAllKeys : " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func getMaxPinTries(_ sender: Any) {
        Promise<String> { promise in
            cardCoinManagerNfcApi.getRemainingPinTries(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("Got PIN tries : " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func getHashes(_ sender: Any) {
        Promise<String> { promise in
            self.cardActivationApi.generateSeedAndGetHashes(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("Response from getHashes: " + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func activateCard(_ sender: Any) {
        Promise<String> { promise in
            self.cardActivationApi.turnOnWallet(/*newPin: self.DEFAULT_PIN,*/ authenticationPassword: self.PASSWORD, commonSecret: self.COMMON_SECRET, initialVector: self.IV, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("Response from getTonAppletState : " + response)
            let message = try self.extractMessage(jsonStr : response)
            if (message != TonWalletAppletConstants.PERSONALIZED_STATE_MSG) {
                throw "Applet state is not personalized. Incorrect applet state : " + message
            }
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    func extractMessage(jsonStr : String) throws -> String  {
        let data = Data(jsonStr.utf8)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let message = json["message"] as! String
        print("message : " + message)
        return message
    }
    
    @IBAction func sign(_ sender: Any) {
        let hdIndex = "65"
        let msg = "A456"
        let pin = "5555"
        Promise<String> { promise in
            cardCryptoNfcApi.createKeyForHmac(authenticationPassword: PASSWORD, commonSecret: COMMON_SECRET, serialNumber: SERIAL_NUMBER, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .then{(response : String)  -> Promise<String> in
            print("Response from createKeyForHmac : " + response)
            return Promise<String> { promise in
                self.cardCryptoNfcApi
                   .checkSerialNumberAndVerifyPinAndSign(serialNumber: self.SERIAL_NUMBER, data: msg, hdIndex: hdIndex, pin: pin,  resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
              /* .checkSerialNumberAndVerifyPinAndSignForDefaultHdPath(serialNumber: self.SERIAL_NUMBER, data: msg, pin: pin,  resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })*/
               /* self.cardCryptoNfcApi.checkSerialNumberAndSignForDefaultHdPath(serialNumber: self.SERIAL_NUMBER, data: msg, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })*/
                /*self.cardCryptoNfcApi.verifyPinAndSign(data: msg, hdIndex: hdIndex, pin: pin, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })*/
            }
        }
        .done{response in
            print("Got signature : "  + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    @IBAction func getPublicKey(_ sender: Any) {
        let hdIndex = "65"
        Promise<String> { promise in
            cardCryptoNfcApi.checkSerialNumberAndGetPublicKey(serialNumber: SERIAL_NUMBER, hdIndex: hdIndex, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
            
            /*getPublicKeyForDefaultPath(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })*/
                
                //.getPublicKey(hdIndex: hdIndex, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
        }
        .done{response in
            print("Got public key : "  + response)
        }
        .catch{ error in
            print("Error happened : " + error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApduRunner.setNotificator(observer: self, notificationAction: #selector(self.catchNotification))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

