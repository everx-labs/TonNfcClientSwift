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

// It is for handling errors that happen inside promises, but does not relate directly to card's response
class ErrorHelper: NSObject {
    
    static var errorHelper : ErrorHelper?
    
    static func getInstance() -> ErrorHelper{
        if (errorHelper == nil) {
            errorHelper = ErrorHelper()
        }
        return errorHelper!
    }
    
    let jsonHelper = JsonHelper.getInstance()
    
    func callRejectWith(_ errMsg :  String, _ reject: NfcRejecter?){
        let data = jsonHelper.createErrorJsonMap(msg: errMsg)
        let errorId = data[JsonHelper.ERROR_TYPE_ID_FIELD]!
        let errorCode = Int(data[JsonHelper.ERROR_CODE_FIELD] ?? "0") ?? 0x00
        let errorName = ResponsesConstants.getErrorTypeName(typeId: errorId) ?? ResponsesConstants.SWIFT_INTERNAL_ERROR_TYPE
        let json = jsonHelper.makeJsonString(data: data)
        let error = NSError(domain: errorName, code: errorCode, userInfo: [NSLocalizedDescriptionKey: json])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            reject?(errorName, error)
        }
    }
}
