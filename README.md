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

## Requirements



## Author

alinaT95, alina.t@tonlabs.io

## License

TonNfcClientSwift is available under the MIT license. See the LICENSE file for more info.
