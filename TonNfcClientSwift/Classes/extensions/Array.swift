//
//  Array.swift
//  NewTonNfcCardLib
//
//  Created by Alina Alinovna on 02.09.2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

extension Array {
  
  subscript (range r: Range<Int>) -> Array {
    return Array(self[r])
  }
  
  
  subscript (range r: ClosedRange<Int>) -> Array {
    return Array(self[r])
  }
}
