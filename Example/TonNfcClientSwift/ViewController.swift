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
    
    @IBAction func activateCard(_ sender: Any) {
        Promise<String> { promise in
             cardCoinManagerNfcApi.getRootKeyStatus(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
         }
         .then{(response : String)  -> Promise<String> in
             print("Response from getRootKeyStatus : " + response)
             let message = try self.extractMessage(jsonStr : response)
             if (message == "generated") {
                 return Promise<String> { promise in promise.fulfill("Seed exists already")}
             }
             sleep(5)
             return Promise<String> { promise in
                 self.cardCoinManagerNfcApi.generateSeed(pin : self.DEFAULT_PIN, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
             }
         }
         .then{(response : String)  -> Promise<String> in
             print("Response from generateSeed : " + response)
             sleep(5)
             return Promise<String> { promise in
                 self.cardActivationApi.getTonAppletState(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
             }
         }
         .then{(response : String)  -> Promise<String> in
             print("Response from getTonAppletState : " + response)
             let message = try self.extractMessage(jsonStr : response)
             if (message != "TonWalletApplet waits two-factor authorization.") {
                 throw "Incorrect applet state : " + message
             }
             sleep(5)
             return Promise<String> { promise in
                 self.cardActivationApi.getHashOfEncryptedCommonSecret(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
             }
         }
         .then{(response : String)  -> Promise<String> in
             print("Response from getHashOfEncryptedCommonSecret : " + response)
             //check hashOfEncryptedCommonSecret
             sleep(5)
             return Promise<String> { promise in
                 self.cardActivationApi.getHashOfEncryptedPassword(resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
             }
         }
         .then{(response : String)  -> Promise<String> in
             print("Response from getHashOfEncryptedPassword : " + response)
             //check hashOfEncryptedPassword
             sleep(5)
             return Promise<String> { promise in
                self.cardActivationApi.turnOnWallet(newPin: self.DEFAULT_PIN, authenticationPassword: self.PASSWORD, commonSecret: self.COMMON_SECRET, initialVector: self.IV, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
             }
         }
         .done{response in
             print("Response from getTonAppletState : " + response)
             let message = try self.extractMessage(jsonStr : response)
             if (message != "TonWalletApplet is personalized.") {
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
                self.cardCryptoNfcApi.verifyPinAndSign(data: msg, hdIndex: hdIndex, pin: pin, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
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
            cardCryptoNfcApi.getPublicKey(hdIndex: hdIndex, resolve: { msg in promise.fulfill(msg as! String) }, reject: { (errMsg : String, err : NSError) in promise.reject(err) })
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
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

