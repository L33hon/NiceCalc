//
//  OutputAdapter.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

class OutputAdapter: OutputProtocol {
  static let shared = OutputAdapter()
    
  var resultDisplay: ((String)->())?
    
  internal func presentResult(result: String) {
    resultDisplay?(result)
  }
}
