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
import CommonCrypto
import CryptoKit

extension Data {
  func authenticationCode(secretKey: Data) -> Data {
    let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity:Int(CC_SHA256_DIGEST_LENGTH))
    defer { hashBytes.deallocate() }
    withUnsafeBytes { (bytes) -> Void in
      secretKey.withUnsafeBytes { (secretKeyBytes) -> Void in
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), secretKeyBytes, secretKey.count, bytes, count, hashBytes)
      }
    }
    return Data(bytes: hashBytes, count: Int(CC_SHA256_DIGEST_LENGTH))
  }
  
  func hash() -> Data {
    let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
    defer { hashBytes.deallocate() }
    withUnsafeBytes { (buffer) -> Void in
      CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), hashBytes)
    }
    return Data(bytes: hashBytes, count: Int(CC_SHA256_DIGEST_LENGTH))
  }
  
}

@available(iOS 13.0, *)
class HmacHelper {
    static var hmacHelper : HmacHelper?
    static func getInstance() -> HmacHelper {
        if (hmacHelper == nil) {
            hmacHelper = HmacHelper()
        }
        return hmacHelper!
    }
    
    let dictionaryHelper = KeychainQueryHelper.getInstance()
    var currentSerialNumber : String = TonWalletAppletConstants.EMPTY_SERIAL_NUMBER
    
    func computeHmac(key : Data, data : Data) -> Data {
        let key256 = SymmetricKey(data: key)
        let sha512MAC = HMAC<SHA256>.authenticationCode(
          for: data, using: key256)
        print(String(describing: sha512MAC))
        let authenticationCodeData = Data(sha512MAC)
        print(authenticationCodeData)
        return authenticationCodeData
    }
    
    func computeHmac(data : Data) throws -> Data {
        print("currentSerialNumber = " + currentSerialNumber)
        guard currentSerialNumber != TonWalletAppletConstants.EMPTY_SERIAL_NUMBER else {
            throw ResponsesConstants.ERROR_MSG_CURRENT_SERIAL_NUMBER_IS_NOT_SET_IN_IOS_KEYCHAIN
        }
        let dict = dictionaryHelper.createQueryToGetKey(serialNumber: currentSerialNumber)
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(dict as CFDictionary, UnsafeMutablePointer($0))
        }
        guard status == errSecSuccess else {            
            throw ResponsesConstants.ERROR_MSG_KEY_FOR_HMAC_DOES_NOT_EXIST_IN_IOS_KEYCHAIN
        }
        // Don't keep this in memory for long!!
        let key = queryResult as! Data // = String(data: queryResult as! Data, encoding: .utf8)!
        print("KEY:")
        print(key.hexEncodedString())
        return computeHmac(key: key, data: data)
    }
}

/*class HmacHelper {
  static var key : Data?
  
  static func setKey(key : Data) {
    self.key = key
  }
  
  static func computeHmac(data : Data) throws -> Data {
    if let key = key {
      return data.authenticationCode(secretKey: key)
    }
    else {
      throw "Key for hmac is not set."
    }
  }
  
  static func computeHmac(key : Data, data : Data) -> Data {
    data.authenticationCode(secretKey: key)
  }
}*/

struct AES {
  private let key: Data
  private let iv: Data
  
  
  /*
   init?(key: String, iv: String) {
   guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
   debugPrint("Error: Failed to set a key.")
   return nil
   }
   
   guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
   debugPrint("Error: Failed to set an initial vector.")
   return nil
   }
   
   
   self.key = keyData
   self.iv  = ivData
   }*/
  
  init?(key: Data, iv: Data) {
    guard key.count == kCCKeySizeAES128  else {
      debugPrint("Error: Failed to set a key.")
      return nil
    }
    
    guard iv.count == kCCBlockSizeAES128 else {
      debugPrint("Error: Failed to set an initial vector.")
      return nil
    }
    
    self.key = key
    self.iv  = iv
  }
  
  /*func encrypt(string: String) -> Data? {
   return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
   }*/
  
  func encrypt(msg: Data) -> Data? {
    return crypt(data: msg, option: CCOperation(kCCEncrypt))
  }
  
  /*func decrypt(data: Data?) -> String? {
   guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
   return String(bytes: decryptedData, encoding: .utf8)
   }*/
  
  func crypt(data: Data?, option: CCOperation) -> Data? {
    guard let data = data else { return nil }
    
    let cryptLength = data.count + kCCBlockSizeAES128
    var cryptData   = Data(count: cryptLength)
    
    print(" cryptLength = " + String(cryptLength))
    print(" data.count = " + String(data.count) )
    
    let keyLength = key.count
    let options   = CCOptions(kCCOptionPKCS7Padding)
    
    var bytesLength = Int(0)
    
    let status = cryptData.withUnsafeMutableBytes { cryptBytes in
      data.withUnsafeBytes { dataBytes in
        iv.withUnsafeBytes { ivBytes in
          key.withUnsafeBytes { keyBytes in
            CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
          }
        }
      }
    }
    
    guard UInt32(status) == UInt32(kCCSuccess) else {
      debugPrint("Error: Failed to crypt data. Status \(status)")
      return nil
    }
    cryptData.removeSubrange(data.count..<cryptData.count)
    return cryptData
  }
}
