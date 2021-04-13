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
    let MALFORMED_JON_MSG: String = "Malformed data for json."
    let STATUS_FIELD: String = "status"
    let SERIAl_NUMBERS_FIELD = "serial_numbers"
    let ERROR_CODE_FIELD: String = "errorCode"
    let ERROR_TYPE_FIELD: String = "errorType"
    let ERROR_TYPE_ID_FIELD: String = "errorTypeId"
    let MESSAGE_FIELD: String = "message"
    let CARD_INSTRUCTION_FIELD: String = "cardInstruction"
    let APDU_FIELD: String = "apdu"
    let KEY_INDEX_FIELD: String = "index"
    let KEY_LENGTH_FIELD: String = "length"
    
    static var jsonHelper : JsonHelper?
    
    static func getInstance() -> JsonHelper{
        if (jsonHelper == nil) {
            jsonHelper = JsonHelper()
        }
        return jsonHelper!
    }
    
    func createJson(msg : String) -> String {
        var data: [String : String] = [:]
        data[MESSAGE_FIELD] = msg
        data[STATUS_FIELD] = ResponsesConstants.SUCCESS_STATUS
        return makeJsonString(data: data)
    }
    
    func createJsonWithSerialNumbers(serialNumbers : [String]) -> String {
        let data : [String : Any] = [SERIAl_NUMBERS_FIELD : serialNumbers, STATUS_FIELD : ResponsesConstants.SUCCESS_STATUS]
        return makeJsonString(data: data)
    }
    
    func createJson(index : Int, len : Int) -> String {
        let data : [String : Any] = [KEY_INDEX_FIELD : index, KEY_LENGTH_FIELD : len]
        return makeJsonString(data: data)
    }
    
    @available(iOS 13.0, *)
    func createErrorJsonForCardException(sw : UInt16, apdu : NFCISO7816APDU) -> String {
        var data: [String : String] = [:]
        if let msg = CardErrorCodes.getErrorMsg(sw: sw) {
            data[MESSAGE_FIELD] = msg
        }
        data[STATUS_FIELD] = ResponsesConstants.FAIL_STATUS
        data[ERROR_TYPE_ID_FIELD] = ResponsesConstants.CARD_ERROR_TYPE_ID
        data[ERROR_TYPE_FIELD] = ResponsesConstants.CARD_ERROR_TYPE_MSG
        data[ERROR_CODE_FIELD] = String(format:"%02X", sw)
        if let apduName = TonWalletAppletApduCommands.getApduCommandName(ins: apdu.instructionCode) {
            data[CARD_INSTRUCTION_FIELD] = apduName
        }
        data[APDU_FIELD] = apdu.toHexString()
        
        return makeJsonString(data: data)
    }
    
    func createErrorJsonMap(msg : String) -> [String : String] {
        var data: [String : String] = [:]
        data[MESSAGE_FIELD] = msg
        data[STATUS_FIELD] = ResponsesConstants.FAIL_STATUS
        
        let errCode = ResponsesConstants.getErrorCode(errMsg: msg) ?? ResponsesConstants.SWIFT_INTERNAL_ERROR_TYPE_ID
        let errTypeId = errCode.substring(with: 0..<1)
        
        data[ERROR_TYPE_ID_FIELD] = errTypeId
        
        if let errTypeMsg = ResponsesConstants.getErrorTypeMsg(typeId: errTypeId) {
            data[ERROR_TYPE_FIELD] = errTypeMsg
        }
        
        if errCode != ResponsesConstants.SWIFT_INTERNAL_ERROR_TYPE_ID {
            data[ERROR_CODE_FIELD] = errCode
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
