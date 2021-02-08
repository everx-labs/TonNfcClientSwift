//
//  NfcCallback.swift
//  CocoaAsyncSocket
//
//  Created by Alina Alinovna on 15.01.2021.
//

import Foundation

public typealias NfcResolver = ((Any) -> Void)
public typealias NfcRejecter = ((String, NSError) -> Void)

public class NfcCallback {
    var resolve: NfcResolver?
    var reject: NfcRejecter?

    public init(resolve: @escaping NfcResolver, reject: @escaping NfcRejecter) {
        set(resolve: resolve, reject: reject)
    }

    public func set(resolve: @escaping NfcResolver, reject: @escaping NfcRejecter) {
        self.resolve = resolve
        self.reject = reject
    }

    public func clear() {
        self.resolve = nil
        self.reject = nil
    }

}
