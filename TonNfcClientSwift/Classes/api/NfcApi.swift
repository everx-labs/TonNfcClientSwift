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

@available(iOS 13.0, *)
public class NfcApi {
    
    let jsonHelper = JsonHelper.getInstance()
    
    public init() {}
    
    public func checkIfNfcSupported(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) -> Void {
        let msg = NFCTagReaderSession.readingAvailable ? ResponsesConstants.TRUE_MSG : ResponsesConstants.FALSE_MSG
        resolve(jsonHelper.createJson(msg : msg))
    }
}
