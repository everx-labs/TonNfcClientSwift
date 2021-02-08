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

- Add into info.plist the point **com.apple.developer.nfc.readersession.formats** and for it string item **TAG**.

_Note_ : you can not work with NFC using simulator, you must run it on iPhone, so you also should set development team.

## Example

To run the example project inside this lib, clone the repo, and run `pod install` from the Example directory first.

## Usage (Simple example)

Let's suppose you want to work with NFC TON Labs security card in your Swift app. And you want to make a simple request to the card: return the maximum number of card's PIN tries. For this request there is a special APDU command supported by the card. And there is a corresponding function in TonNfcClientSwift library sending it to the card and making postprocessing of card's response for you.  To make it work you should go through the following steps.

+ Make the following import.

```swift
import TonNfcClientSwift
```

+ Add the following snippet.

```swift
var cardCoinManagerNfcApi: CardCoinManagerNfcApi = CardCoinManagerNfcApi()
cardCoinManagerNfcApi.getMaxPinTries()
```

Run application and you must get an invitation dialog to connect the card. Then wait for 1-2 seconds to get the response from the card. Check your Xcode console. You should find the following output.

    {"message":"10","status":"ok"}
    
This is a response from card wrapped into json of special format.

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

The majority of input data passed into TonNfcClientSwift library is represented by hex strings of even length > 0. These hex strings are naturally converted into byte arrays inside the library, like: "0A0A" → new byte[]{10, 10}. 

And also the payload produced by the card and wrapped into json responses is usually represented by hex strings of even length > 0.  For example, this is a response from getPublicKey function  returning ed25519 public key.

	{"message":"B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A","status":"ok"}

Here B81F0E0E07316DAB6C320ECC6BF3DBA48A70101C5251CC31B1D8F831B36E9F2A is a 32 bytes length ed25519 public key in hex format.

## Test work with the card

"folderName/screenshot.png" 

![Optional Text](../master/docs/images/Screenshot 2021-02-08 at 9.13.32 AM.png)

After you prepared the application, you may run it on your Android device (not simulator). Then you need to establish NFC connection. For this hold the card to the top of the smartphone (field near the camera) as close as possible. Usually smartphone vibrates after establishing a connection. And if you use above example, you must get the toast with the message "NFC hardware touched". It means that NFC connection is established. To keep connection alive you must not move the card and smartphone and they should have physical contact.

After NFC connection is ready we can send APDU command to the card. For above example push the button to make request getMaxPinTries. Check your Logcat console in Android Studio. You must find the following output:

		===============================================================
		===============================================================
		>>> Send apdu  00 A4 04 00 
		(SELECT_COIN_MANAGER)
		SW1-SW2: 9000, No error., response data bytes: 	6F5C8408A000000151000000A...
		===============================================================
		===============================================================
		 >>> Send apdu  80 CB 80 00 05 DFFF028103 
		(GET_PIN_TLT)
 		SW1-SW2: 9000, No error., response data bytes: 0A
 
 		Card response : {"message":"10","status":"ok"}

Here you see the log of APDU commands sent to the card and their responses in raw format. And in the end there is a final wrapped response.

## Requirements

## Author

alinaT95, alina.t@tonlabs.io

## License

TonNfcClientSwift is available under the MIT license. See the LICENSE file for more info.
