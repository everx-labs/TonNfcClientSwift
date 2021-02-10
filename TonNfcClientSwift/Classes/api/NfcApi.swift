//
//  NfcApi.swift
//  TonNfcClientSwift
//
//  Created by Alina Alinovna on 10.02.2021.
//

import Foundation
import CoreNFC

@available(iOS 13.0, *)
public class NfcApi {
    func checkIfNfcSupported(resolve : @escaping NfcResolver, reject : @escaping NfcRejecter) -> Void {
            resolve(NFCTagReaderSession.readingAvailable ? ResponsesConstants.TRUE_MSG : ResponsesConstants.FALSE_MSG);
        }
}
