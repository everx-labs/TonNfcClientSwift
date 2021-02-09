//
//  NfcCallback.swift
//  CocoaAsyncSocket
//
//  Created by Alina Alinovna on 15.01.2021.
//

import Foundation

public typealias NfcResolver = ((Any) -> Void)
public typealias NfcRejecter = ((String, NSError) -> Void)

