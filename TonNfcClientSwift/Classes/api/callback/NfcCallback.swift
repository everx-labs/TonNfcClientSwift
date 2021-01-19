//
//  NfcCallback.swift
//  CocoaAsyncSocket
//
//  Created by Alina Alinovna on 15.01.2021.
//

import Foundation

typealias NfcResolver = ((Any) -> Void)
typealias NfcRejecter = ((String, NSError) -> Void)

class NfcCallback {
    var resolve: NfcResolver?
    var reject: NfcRejecter?

    public static var callback : NfcCallback = NfcCallback()

    private init() {
    }

    func set(resolve: @escaping NfcResolver, reject: @escaping NfcRejecter) {
        self.resolve = resolve
        self.reject = reject
    }

    func clear() {
        self.resolve = nil
        self.reject = nil
    }

}
