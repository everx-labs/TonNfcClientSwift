//
//  ErrorHelper.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 02.09.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

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
    
    func callRejectWith(errMsg :  String, reject: NfcRejecter?){
        let data = jsonHelper.createErrorJsonMap(msg: errMsg)
        let errorId = data[jsonHelper.ERROR_TYPE_ID_FIELD]!
        let errorCode = Int(data[jsonHelper.ERROR_CODE_FIELD] ?? "0") ?? 0x00
        let errorName = ResponsesConstants.getErrorTypeName(typeId: errorId) ?? ResponsesConstants.SWIFT_INTERNAL_ERROR_TYPE
        let json = jsonHelper.makeJsonString(data: data)
        let error = NSError(domain: errorName, code: errorCode, userInfo: [NSLocalizedDescriptionKey: json])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            reject?(errorName, error)
        }
    }
}
