//
//  DataVerifier.swift
//  react-native-new-ton-nfc-card-lib
//
//  Created by Alina Alinovna on 10.01.2021.
//

import Foundation

class DataVerifier {
    static var dataVerifier : DataVerifier?
    
    static func getInstance() -> DataVerifier{
        if (dataVerifier == nil) {
            dataVerifier = DataVerifier()
        }
        return dataVerifier!
    }
    
    let errorHelper = ErrorHelper.getInstance()
    
    func checkPasswordSize(password : String, callback: NfcCallback) -> Bool {
        guard password.count == 2 * TonWalletAppletConstants.PASSWORD_SIZE else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_PASSWORD_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkPinSize(pin : String, callback: NfcCallback) -> Bool {
        guard pin.count == TonWalletAppletConstants.PIN_SIZE else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_PIN_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkPinFormat(pin : String, callback: NfcCallback) -> Bool {
        guard pin.isNumeric == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_PIN_FORMAT_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkHdIndexSize(hdIndex : String, callback: NfcCallback) -> Bool {
        guard  hdIndex.count > 0 && hdIndex.count <= TonWalletAppletConstants.MAX_IND_SIZE else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_HD_INDEX_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkHdIndexFormat(hdIndex : String, callback: NfcCallback) -> Bool {
        guard  hdIndex.isNumeric == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_HD_INDEX_FORMAT_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkDataFormat(data : String, callback: NfcCallback) -> Bool {
        guard data.isHex == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_DATA_FOR_SIGNING_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkDataSizeForCaseWithPath(data : String, callback: NfcCallback) -> Bool {
        guard data.count <= (2 * TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE_FOR_CASE_WITH_PATH) && data.count > 0 else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_DATA_FOR_SIGNING_WITH_PATH_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkDataSize(data : String, callback: NfcCallback) -> Bool {
        guard data.count <= (2 * TonWalletAppletConstants.DATA_FOR_SIGNING_MAX_SIZE) && data.count > 0 else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_DATA_FOR_SIGNING_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkLabelSize(label : String, callback: NfcCallback) -> Bool {
        guard label.count == 2 * CoinManagerConstants.LABEL_LENGTH else{
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_DEVICE_LABEL_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkLabelFormat(label : String, callback: NfcCallback) -> Bool {
        guard label.isHex == true else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_DEVICE_LABEL_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkRecoveryDataSize(recoveryData : String, callback: NfcCallback) -> Bool {
        guard recoveryData.count <= TonWalletAppletConstants.RECOVERY_DATA_MAX_SIZE && recoveryData.count > 0 else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_RECOVERY_DATA_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkRecoveryDataFormat(recoveryData : String, callback: NfcCallback) -> Bool {
        guard recoveryData.isHex == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_RECOVERY_DATA_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkSerialNumberSize(serialNumber : String, callback: NfcCallback) -> Bool {
        guard serialNumber.count == TonWalletAppletConstants.SERIAL_NUMBER_SIZE else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_SERIAL_NUMBER_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkSerialNumberFormat(serialNumber : String, callback: NfcCallback) -> Bool {
        guard serialNumber.isNumeric == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_SERIAL_NUMBER_NOT_NUMERIC, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkPasswordFormat(password : String, callback: NfcCallback) -> Bool {
        guard password.isHex == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_PASSWORD_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkInitialVectorFormat(initialVector : String, callback: NfcCallback) -> Bool {
        guard initialVector.isHex == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_INITIAL_VECTOR_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkInitialVectorSize(initialVector : String, callback: NfcCallback) -> Bool {
        guard initialVector.count == 2 * TonWalletAppletConstants.IV_SIZE else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_INITIAL_VECTOR_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkCommonSecretSize(commonSecret : String, callback: NfcCallback) -> Bool {
        guard commonSecret.count == 2 * TonWalletAppletConstants.COMMON_SECRET_SIZE else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_COMMON_SECRET_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkCommonSecretFormat(commonSecret : String, callback: NfcCallback) -> Bool {
        guard commonSecret.isHex == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_COMMON_SECRET_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkKeyFormat(key : String, callback: NfcCallback) -> Bool {
        guard key.isHex == true else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_KEY_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkKeySize(key : String, callback: NfcCallback) -> Bool {
        guard key.count > 0 && key.count <= 2 * TonWalletAppletConstants.MAX_KEY_SIZE_IN_KEYCHAIN else {
            errorHelper.callRejectWith(errMsg :  ResponsesConstants.ERROR_MSG_KEY_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkMacSize(mac : String, callback: NfcCallback) -> Bool {
        guard mac.count == 2 * TonWalletAppletConstants.HMAC_SHA_SIG_SIZE else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_KEY_HMAC_LEN_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkMacFormat(mac : String, callback: NfcCallback) -> Bool {
        guard mac.isHex == true else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_KEY_HMAC_NOT_HEX, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkKeySizeVal(keySizeVal : UInt16, callback: NfcCallback) -> Bool {
        guard keySizeVal > 0  && keySizeVal <= TonWalletAppletConstants.MAX_KEY_SIZE_IN_KEYCHAIN else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_KEY_SIZE_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkKeyIndexFormat(index : String, callback: NfcCallback) -> Bool {
        guard index.isNumeric == true else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_KEY_INDEX_STRING_NOT_NUMERIC, reject: callback.reject)
            return false
        }
        return true
    }
    
    func checkKeyIndexSize(index : UInt16, callback: NfcCallback) -> Bool {
        guard index >= 0 && index < TonWalletAppletConstants.MAX_NUMBER_OF_KEYS_IN_KEYCHAIN else {
            errorHelper.callRejectWith(errMsg : ResponsesConstants.ERROR_MSG_KEY_INDEX_VALUE_INCORRECT, reject: callback.reject)
            return false
        }
        return true
    }
}
