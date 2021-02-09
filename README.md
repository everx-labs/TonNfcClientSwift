# TonNfcClientSwift

[![CI Status](https://img.shields.io/travis/alinaT95/TonNfcClientSwift.svg?style=flat)](https://travis-ci.org/alinaT95/TonNfcClientSwift)
[![Version](https://img.shields.io/cocoapods/v/TonNfcClientSwift.svg?style=flat)](https://cocoapods.org/pods/TonNfcClientSwift)
[![License](https://img.shields.io/cocoapods/l/TonNfcClientSwift.svg?style=flat)](https://cocoapods.org/pods/TonNfcClientSwift)
[![Platform](https://img.shields.io/cocoapods/p/TonNfcClientSwift.svg?style=flat)](https://cocoapods.org/pods/TonNfcClientSwift)

The library is developed to handle communication of iPhones with NFC TON Labs Security cards. It provides a useful API to work with all functionality (i.e. APDU commands) supported by NFC TON Labs Security card.

## Installation

TonNfcClientSwift is available through [CocoaPods](https://cocoapods.org). To install
it, add the following line to your Podfile:

```ruby
pod 'TonNfcClientSwift'
```
And then run `pod install` from the directory of your project.

Also you must go through the following steps to make NFC working for you.

- Go to Signing & Capabilities tab and add capability **Near Field Communication Tag Reading**.

- Add into info.plist the point **Privacy - NFC Scan Usage Description** and value for it **Test NFC**.

- Add into info.plist the point **ISO7816 application identifiers for NFC Tag Reader Session** and add for it the following items: 313132323333343435353636, A000000151000000.

- Add into info.plist the point **com.apple.developer.nfc.readersession.formats** and add for it string item **TAG**.

_Note_ : you can not work with NFC using simulator, you must run it on iPhone, so you also should set development team.

## Exemplary app 

To run the example project inside this lib, clone the repo, and run `pod install` from the Example directory first.

## Simple example

For each NFC card operation there is a function in TonNfcClientSwift API. These functions use callbacks mechanism to output results into the caller. We defined the following callback types for this.

```swift
public typealias NfcResolver = ((Any) -> Void)
public typealias NfcRejecter = ((String, NSError) -> Void)
```

Any function from the API returns void and has the lasts two arguments: _resolve : @escaping NfcResolver, reject : @escaping NfcRejecter_. It passes the postprocessed card's response into _resolve_ and it passes error message and error object into _reject_ in the case of any exception. So to use the API you must define your _NfcRejecter_ and _NfcResolver_ callback functions.

Let's look at simple exemplary function _getMaxPinTries_ from class _CardCoinManagerNfcApi_. It returns the maximum number of PIN tries from the card. It has the following signature.

```swift
public func getMaxPinTries(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter)
```
To make it work you should go through the following steps.

+ Make the import.

```swift
import TonNfcClientSwift
```

+ Add the snippet.

```swift
var cardCoinManagerNfcApi: CardCoinManagerNfcApi = CardCoinManagerNfcApi()

let resolve : NfcResolver = {(msg : Any) -> Void  in
	print("Caught msg : ")
	print(msg)
}
let reject : NfcRejecter = {(errMsg : String, err : NSError) -> Void in
	print("Error happened : " + errMsg)
}

cardCoinManagerNfcApi.getMaxPinTries(resolve: resolve, reject: reject)
```

Run application and you get an invitation dialog to connect the card. Wait for 1-2 seconds to get the response from the card. Check your Xcode console. You should find the following output.

```
Caught msg :

{"message":"10","status":"ok"}
```
    
This is a response from NFC card wrapped into json.

## Work with promises

TonNfcClientSwift library uses [PromiseKit](https://cocoapods.org/pods/PromiseKit). So you may also use PromiseKit in the project. It gives a convinient way to make the chain of NFC card operations and avoid callback hell. So let's rewrite above example using promises.

```swift
import TonNfcClientSwift
import PromiseKit

...

let cardCoinManagerNfcApi: CardCoinManagerNfcApi = CardCoinManagerNfcApi()

...

Promise<String> { promise in
	cardCoinManagerNfcApi.getRemainingPinTries(
		resolve: { msg in promise.fulfill(msg as! String) }, 
		reject: { (errMsg : String, err : NSError) in promise.reject(err) }
	)
}
.done{response in
	print("Got PIN tries : " + response)
}
.catch{ error in
	print("Error happened : " + error.localizedDescription)
}
```
Below you will find more examples and some gory details of NFC card operations chaining for iPhone.

## More about responses format

### Case of successful operation

In the case of successful operation with the card any function of TonNfcClientSwift library always creates json string with two fields "message" and "status". "status" will contain "ok". In the field "message" you will find an expected payload. So jsons may look like this.

	{"message":"done","status":"ok"}
	{"message":"generated","status":"ok"}
	{"message":"HMac key to sign APDU data is generated","status":"ok"}
	{"message":"980133A56A59F3A59F174FD457EB97BE0E3BAD59E271E291C1859C74C795A83368FD8C7405BC37E1C4146F4D175CF36421BF6AD2AFF4329F5A6C6D772247ED03","status":"ok"}
	etc.

### Case of error

If some error happened then functions of TonNfcClientSwift library produce error messages wrapped into json strings of special format. The structure of json depends on the  error class. There are two main classes of errors.

#### Applet (card) errors

It is the case when applet (installed on the card) threw some error status word (SW). So Swift code just catches it and throws away. The exemplary error json looks like this.

	{
		"message":"Incorrect PIN (from Ton wallet applet).",
		"status":"fail",
		"errorCode":"6F07",
		"errorTypeId":0,
		"errorType":"Applet fail: card operation error",
		"cardInstruction":"VERIFY_PIN",
		"apdu":"B0 A2 00 00 44 35353538EA579CD62F072B82DA55E9C780FCD0610F88F3FA1DD0858FEC1BB55D01A884738A94113A2D8852AB7B18FFCB9424B66F952A665BF737BEB79F216EEFC3A2EE37 FFFFFFFF "
	}
	
Here:
+ *errorCode* — error status word (SW) produced by the card (applet)

+ *cardInstruction* — title of APDU command that failed

+ *errorTypeId* — id of error type ( it will always be zero here)

+ *errorType* — description of error type 

+ *message* — contains error message corresponding to errorCode thrown by the card.

+ *apdu* — full text of failed APDU command in hex format

#### Swift errors

It is the case when error happened in Swift code itself. The basic examples: troubles with NFC connection or incorrect format of input data passed into TonNfcClientSwift library from the outside world. The exemplary error json looks like this.

	{
		"errorType": "Native code fail: incorrect format of input data",
		"errorTypeId": "3",
		"errorCode": "30006",
		"message": "Pin must be a numeric string of length 4.",
		"status": "fail"
	}
	
In this [document](https://github.com/tonlabs/TonNfcClientSwift/blob/master/docs/ErrorrList.md) you may find the full list of json error messages (and their full classification) that can be thrown by the library.

### String format

The majority of input data passed into TonNfcClientSwift library is represented by hex strings of even length > 0. These hex strings are naturally converted into byte arrays inside the library, like: "0A0A" → [10, 10] as [UInt8]. 

And also the payload produced by the card and wrapped into json responses is usually represented by hex strings of even length > 0.  For example, this is a response from getPublicKey function  returning ed25519 public key.

	{"message":"B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A","status":"ok"}

Here B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A is a 32 bytes length ed25519 public key in hex format.

## Test work with the card

After you prepared the application, you may run it on your iPhone. Then you need to establish NFC connection. For this you should call the necessary function from TonNfcClientSwift API (like getMaxPinTries). It will start NFC session and you will get invitation to connect the card.

<p align="center">
<img src="../master/docs/images/Screenshot2.png" width="200">
</p>

To establish connection hold the card to the top of iPhone (field near the camera) as close as possible. After that iPhone sends APDU commands to the card. In above example it sends request getMaxPinTries. To keep connection alive you must not move the card and iPhone and they should have physical contact. Wait until you see the following picture.

<p align="center">
<img src="../master/docs/images/Screenshot1.png" width="200">
</p>

Check your Xcode console. You must find the following output:

```
Start card operation: getMaxPinTries
Nfc session is active
Nfc Tag is connected.


===============================================================
===============================================================
>>> Send apdu  00 A4 04 00 a000000151000000FFFFFFFF 
(SELECT_COIN_MANAGER)
SW1-SW2: 90, 00
APDU Response: 6f5c8408a000000151000000a550734a06072a864886fc6b01600c060a2a864886fc6b02020101630906072a864886fc6b03640b06092a864886fc6b040255650b06092b8510864864020103660c060a2b060104012a026e01029f6501ff
===============================================================


===============================================================
===============================================================
>>> Send apdu  80 CB 80 00 dfff028103100 
(GET_PIN_TLT)
SW1-SW2: 90, 00
APDU Response: 0a
===============================================================
{
  "message" : "10",
  "status" : "ok"
}
```

Here you see the log of APDU commands sent to the card and their responses in raw format. And in the end there is a final wrapped response.



## Card activation

When user gets NFC TON Labs security card  at the first time, the applet on the card is in a special state.  The main functionality of applet is blocked for now. Applet waits for user authentication. To pass authentication user must have three secret hex strings **authenticationPassword, commonSecret, initialVector**. The tuple **(authenticationPassword, commonSecret, initialVector)** is called _card activation data._  The user is going to get (using debots) his activation data from Tracking Smartcontract deployed for his security card.

At this step not only the card waits for user authentication. The user also authenticates the card by verification of some hashes.

*Note:* There is a bijection between serial number (SN) printed on the card and activation data.

The detailed info about card activation and related workflow is [here]().

For now let's suppose the user somehow got activation data into his application from debot (the details of working with debot will be given later). Then to activate the card he may use the following exemplary snippets.

```swift
let DEFAULT_PIN = "5555"
let SERIAL_NUMBER = "504394802433901126813236"
let COMMON_SECRET = "7256EFE7A77AFC7E9088266EF27A93CB01CD9432E0DB66D600745D506EE04AC4"
let IV = "1A550F4B413D0E971C28293F9183EA8A"
let PASSWORD  = "F4B072E1DF2DB7CF6CD0CD681EC5CD2D071458D278E6546763CBB4860F8082FE14418C8A8A55E2106CBC6CB1174F4BA6D827A26A2D205F99B7E00401DA4C15ACC943274B92258114B5E11C16DA64484034F93771547FBE60DA70E273E6BD64F8A4201A9913B386BCA55B6678CFD7E7E68A646A7543E9E439DD5B60B9615079FE"
let cardCoinManagerNfcApi: CardCoinManagerNfcApi = CardCoinManagerNfcApi()
let cardActivationApi : CardActivationNfcApi = CardActivationNfcApi()

Promise<String> { promise in
	cardCoinManagerNfcApi.getRootKeyStatus(
		resolve: { msg in promise.fulfill(msg as! String) }, 
		reject: { (errMsg : String, err : NSError) in promise.reject(err) }
	)
}
.then{(response : String)  -> Promise<String> in
	print("Response from getRootKeyStatus : " + response)
	let message = try self.extractMessage(jsonStr : response)
	if (message == "generated") {
		return Promise<String> { promise in promise.fulfill("Seed exists already")}
	}
	sleep(5)
        return Promise<String> { promise in
		self.cardCoinManagerNfcApi.generateSeed(
			pin : self.DEFAULT_PIN, 
			resolve: { msg in promise.fulfill(msg as! String) }, 
			reject: { (errMsg : String, err : NSError) in promise.reject(err) }
		)
        }
}
.then{(response : String)  -> Promise<String> in
	print("Response from generateSeed : " + response)
	sleep(5)
	return Promise<String> { promise in
		self.cardActivationApi.getTonAppletState(
			resolve: { msg in promise.fulfill(msg as! String) }, 
			reject: { (errMsg : String, err : NSError) in promise.reject(err) }
		)
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
		self.cardActivationApi.getHashOfEncryptedCommonSecret(
			resolve: { msg in promise.fulfill(msg as! String) }, 
			reject: { (errMsg : String, err : NSError) in promise.reject(err) }
		)
        }
}
.then{(response : String)  -> Promise<String> in
	print("Response from getHashOfEncryptedCommonSecret : " + response)
	//check hashOfEncryptedCommonSecret
	sleep(5)
	return Promise<String> { promise in
		self.cardActivationApi.getHashOfEncryptedPassword(
			resolve: { msg in promise.fulfill(msg as! String) }, 
			reject: { (errMsg : String, err : NSError) in promise.reject(err) }
		)
        }
}
.then{(response : String)  -> Promise<String> in
	print("Response from getHashOfEncryptedPassword : " + response)
	//check hashOfEncryptedPassword
	sleep(5)
	return Promise<String> { promise in
		self.cardActivationApi.turnOnWallet(
			newPin: self.DEFAULT_PIN, password: self.PASSWORD, commonSecret: self.COMMON_SECRET, initialVector: self.IV, 
			resolve: { msg in promise.fulfill(msg as! String) }, 
			reject: { (errMsg : String, err : NSError) in promise.reject(err) }
		)
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
	print(" !Error happened : " + error.localizedDescription)
}
```
Here there is a chain of NFC card operations built using promises. To make each card operation you must reconnect the card. Each time you will get invitation dialog to establish the connection (see previous section _Test work with the card_). iPhones have peculiarities of working with NFC. After one NFC session is finished, it may be not possible to establish new session immediately (at least for iPhone 7 and 8 it is true). So if you write the following code you may get a error.

```swift
cardCoinManagerNfcApi.getRootKeyStatus(resolve: resolve, reject: reject)
cardCoinManagerNfcApi.generateSeed(pin: DEFAULT_PIN, resolve: resolve, reject: reject)
```
Here the first call of _getRootKeyStatus_ will work, but attempt to call _generateSeed_ immediately will throw a error _"System resource is unavailable"_. We need to make a short delay (approximately 3-5 seconds) before we start new NFC session. So these two calls must be separated for example by the call of _sleep_ function. That is why in above snippet demonstrating card activation before each API call there is a string _sleep(5)_.   

## About applet states and provided functionality

Applet installed onto NFC TON Labs security card may be in the one of the following states (modes):

1. TonWalletApplet waits two-factor authorization.
2. TonWalletApplet is personalized.
3. TonWalletApplet is blocked.
4. TonWalletApplet is personalized and waits finishing key deleting from keychain.

**Some details of states transitions:**

- When user gets the card at the first time, applet must be in the state 1 (see previous section).
- If user would try to pass incorrect activation data more than 20 times, then applet state will be switched on state 3. And this is irreversable. In this state all functionality of applet is blocked and one may call only getTonAppletState and getSerialNumber (see the below section Full functions list for more details).
- After correct activation (≤ 20 attempts to pass activation data) applet goes into state 2. And after this one can not go back to state 1. State 1 becomes unreachable. And at state 2 the main applet functionality is available.
- If user started operation of deleting a key from card's keychain, then applet is switched on state 4. And it stays in this state until the current delete operation will not be finished. After correct finishing of delete operation applet goes back into state 2. The other way to go back into state 2 is to call resetKeychain function (see the details below).
- Applet in states 2, 4 may be switched into state 3 in the case if HMAC SHA256 signature verification was failed by applet 20 times successively (more details below).

The functionality provided by NFC TON Labs security card can be divided into several groups.

- Module for card activation (available in state 1).
- Crypto module providing ed22519 signature  (available in states 2, 4).
- Module for maintaining recovery data  (available in states 2, 4).
- Keychain module  (available in states 2, 4).
- CoinManager module providing some auxiliary functions (available in any state).

## Protection against MITM

We protect the most critical card operations (APDU commands) against MITM attack by HMAC SHA256 signature. In this case the data field of such APDU is extended by 32-bytes sault generated by the card and the final byte array is signed. The obtained signature is added to the end of APDU data, i.e. its data field has the structure: payload || sault ||  sign(payload || sault). When the card gets such APDU, first it verifies sault and signature.  

The secret key for HMAC SHA256 is produced based on card activation data (see above section). This key is saved into Android keystore under alias "hmac_key_alias_SN" (SN is replaced by serial number printed on the card) and then it is used by the app to sign APDU commands data fields. Usually after correct card activation in the app (call of cardActivationApi.turnOnWalletAndGetJson) this key is produced and saved into keystore. So no extra code is required it work.

Another situation is possible. Let's suppose you activated the card earlier. After that you reinstalled the app working with NFC TON Labs security card or you started using new Android device. Then Android keystore does not have the key to sign APDU commands. So you must create it.

     cardCryptoApi.createKeyForHmacAndGetJson(authenticationPassword, commonSecret, serialNumber));
     
You may work with multiple NFC TON Labs security cards. In this case in your Android keystore there is a bunch of keys. Each keys is marked by corresponding SN. And you can get the list of serial numbers for which you have the key in keystore

The list of operations protected by HMAC SHA256:

- verifyPin, signForDefaultHdPath, sign (see below sections)
- all functions related to card keychain

## Request ED25519 signature

The basic functionality provided by NFC TON Labs security card is Ed25519 signature. You may request public key and request the signature for some message.

_Note:_ Functions signForDefaultHdPath, sign are protected by HMAC SHA256 signature (see previous section). But also there is an additional protection for them by PIN code. You have 10 attempts to enter PIN, after 10th fail you will not be able to use existing seed (keys for ed25519) . The only way to unblock these functions is to reset the seed (see resetWallet function) and generate new seed (see generateSeed). After resetting the seed PIN will be also reset to default value 5555.

## Card keychain

Inside NFC TON Labs security card we implemented small flexible independent keychain. It allows to store some user's keys and secrets. The maximum number of keys is 1023, maximum key size — 8192 bytes and the total available volume of storage — 32767 bytes.

Each key has its unique id. This is its HMAC SHA256 signature created using the key elaborated based on card activation data. So id is a hex a string of length 64.

The below snippet demonstrates the work with the keychain. We add one key, then retrieve it from the card. Then we replace it by a new key of the same key. At the end we delete the key.

_Note:_ This test is quite long working. So take care of your NFC connection. To keep it alive your screen must not go out. You may increase timeout for your Android device to achieve this.

## Recovery module

This module is to store/maintain the data for recovering service: multisignature wallet address (hex string of length 64), TON Labs Surf public key (hex string of length 64) and part of card's activation data: authenticationPassword (hex string of length 256), commonSecret(hex string of length 64). This data will allow to recover access to multisignature wallet in the case when user has lost Android device with installed Surf application and also a seed phrase for Surf account. More details about recovery service can be found here.

There is an snippet demonstrating the structure of recovery data and the way of adding it into NFC TON Labs security card.


	
## Full functions list 

The full list of functions provided by the library to communicate with the card you will find [here](https://github.com/tonlabs/TonNfcClientAndroid/blob/master/docs/FuntionsList.md)

## Requirements

## Author

alinaT95, alina.t@tonlabs.io

## License

TonNfcClientSwift is available under the MIT license. See the LICENSE file for more info.
