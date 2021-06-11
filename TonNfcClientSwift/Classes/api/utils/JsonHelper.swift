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
import CoreNFC

class JsonHelper {
    static let MALFORMED_JON_MSG: String = "Malformed data for json."
    static let STATUS_FIELD: String = "status"
    static let ERROR_CODE_FIELD: String = "code"
    static let ERROR_TYPE_FIELD: String = "errorType"
    static let ERROR_TYPE_ID_FIELD: String = "errorTypeId"
    static let MESSAGE_FIELD: String = "message"
    static let CARD_INSTRUCTION_FIELD: String = "cardInstruction"
    static let APDU_FIELD: String = "apdu"
    static let KEY_INDEX_FIELD: String = "index"
    static let KEY_LENGTH_FIELD: String = "length"
    
    static var jsonHelper : JsonHelper?
    
    static func getInstance() -> JsonHelper{
        if (jsonHelper == nil) {
            jsonHelper = JsonHelper()
        }
        return jsonHelper!
    }
    
    func createJson(msg : String) -> String {
        var data: [String : String] = [:]
        data[JsonHelper.MESSAGE_FIELD] = msg
        data[JsonHelper.STATUS_FIELD] = ResponsesConstants.SUCCESS_STATUS
        return makeJsonString(data: data)
    }
    
    func createJsonWithSerialNumbers(serialNumbers : [String]) -> String {
        let data : [String : Any] = [JsonHelper.MESSAGE_FIELD : serialNumbers, JsonHelper.STATUS_FIELD : ResponsesConstants.SUCCESS_STATUS]
        return makeJsonString(data: data)
    }
    
    func createJson(index : Int, len : Int) -> String {
        let data : [String : Any] = [JsonHelper.KEY_INDEX_FIELD : index, JsonHelper.KEY_LENGTH_FIELD : len]
        return makeJsonString(data: data)
    }
    
    @available(iOS 13.0, *)
    func createErrorJsonForCardException(sw : UInt16, apdu : NFCISO7816APDU) -> String {
        var data: [String : String] = [:]
        if let msg = CardErrorCodes.getErrorMsg(sw: sw) {
            data[JsonHelper.MESSAGE_FIELD] = msg
        }
        data[JsonHelper.STATUS_FIELD] = ResponsesConstants.FAIL_STATUS
        data[JsonHelper.ERROR_TYPE_ID_FIELD] = ResponsesConstants.CARD_ERROR_TYPE_ID
        data[JsonHelper.ERROR_TYPE_FIELD] = ResponsesConstants.CARD_ERROR_TYPE_MSG
        data[JsonHelper.ERROR_CODE_FIELD] = String(format:"%02X", sw)
        if let apduName = TonWalletAppletApduCommands.getApduCommandName(ins: apdu.instructionCode) {
            data[JsonHelper.CARD_INSTRUCTION_FIELD] = apduName
        }
        data[JsonHelper.APDU_FIELD] = apdu.toHexString()
        
        return makeJsonString(data: data)
    }
    
    func createErrorJsonMap(msg : String) -> [String : String] {
        var data: [String : String] = [:]
        data[JsonHelper.MESSAGE_FIELD] = msg
        data[JsonHelper.STATUS_FIELD] = ResponsesConstants.FAIL_STATUS
        
        let errCode = ResponsesConstants.getErrorCode(errMsg: msg) ?? ResponsesConstants.SWIFT_INTERNAL_ERROR_TYPE_ID
        let errTypeId = errCode.substring(with: 0..<1)
        
        data[JsonHelper.ERROR_TYPE_ID_FIELD] = errTypeId
        
        if let errTypeMsg = ResponsesConstants.getErrorTypeMsg(typeId: errTypeId) {
            data[JsonHelper.ERROR_TYPE_FIELD] = errTypeMsg
        }
        
        if errCode != ResponsesConstants.SWIFT_INTERNAL_ERROR_TYPE_ID {
            data[JsonHelper.ERROR_CODE_FIELD] = errCode
        }
        
        return data
    }
    
    func createErrorJson(msg : String) -> String {
        let data: [String : String] = createErrorJsonMap(msg : msg)
        return makeJsonString(data: data)
    }
    
    func makeJsonString(data : [String : Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            return jsonString
        }
        catch {
            return "Malformed json: \(error)."
        }
    }
    
    func makeJsonString(data : [[String: String]]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            return jsonString
        }
        catch {
            return "Malformed json: \(error)."
        }
    }
}
