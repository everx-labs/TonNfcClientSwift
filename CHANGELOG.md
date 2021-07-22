# Release Notes

All notable changes to this project will be documented in this file.

## [0.0.2] – 2021-01-28

### New

- Added all necessary functionality to communicate with TON NFC security smart cards. And also we prepared a simple example of using the library.

## [0.0.3] – 2021-02-10

### New

- Added several new errors.
- Added samples of library usage for ed25519 and card activation stuff.
- Added basic readme (need to be extended by more samples for keychain and recovery soon), added error list (only internal errors list is not finished), added list of API functions.

### Fixed

- Fixed some error messages.
- Updated work with callbacks.

## [0.0.4] – 2021-03-12

### New

- Added some error messages.
- Add auxiliary public classes and constants.

## [0.1.0] – 2021-06-02

### New

- Add getHashes and turnOnWallet without PIN argument.


## [1.0.0] – 2021-06-11

### Fixed

- errorCode -> code in json error responses
- Change const "TonWalletApplet waits two-factor authorization." -> "TonWalletApplet waits two-factor authentication."
- Change const "HMac keys are not found in iOS keychain." ->"HMAC-SHA256 keys are not found."

## [1.0.1] – 2021-06-21

### Fixed

- Fix usage of error message ERROR_MSG_APDU_NOT_SUPPORTED.

## [1.1.0] – 2021-06-28

### New

- Add functions: checkSerialNumberAndGetPublicKeyForDefaultPath, checkSerialNumberAndGetPublicKey, checkSerialNumberAndSignForDefaultHdPath, checkSerialNumberAndSign, checkSerialNumberAndVerifyPinAndSignForDefaultHdPath, checkSerialNumberAndVerifyPinAndSign. They get SN as input and check that SN from card equals to it. If it is then it makes ed25519 operations.

## [1.1.1] – 2021-06-29

### Fixed

- Make NfcApi public.

## [1.1.2] – 2021-06-29

### Fixed

- checkIfNfcSupported returns json.

## [1.1.3] – 2021-07-06

### New

- Add NFC connection notification

## [1.1.4] – 2021-07-22

### New

- Add generateSeedAndGetHashes + add final check state into turnOnWallet. This was done to reduce the number of card reconnects during card activation.
