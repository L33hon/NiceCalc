//
//  InputAdapter.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

class InputAdapter: InputProtocol {
  static let shared = InputAdapter()
    
  private let brain = Brain.shared
    
  internal func enterNum(_ number: Int) {
    brain.input(number)
  }
    
  internal func enterUtility(_ symbol: Operation) {
    switch symbol {
      case .pls : input("+")
      case .mns : brain.inputMinus()
      case .mul : input("×")
      case .div : input("÷")
      case .pow : input("^")
      case .sqrt : input("√")
      case .sin : input("sin")
      case .cos : input("cos")
      case .log : input("ln")
      case .leftBracket : brain.leftBracket()
      case .rightBracket : brain.rightBracket()
      case .pi : brain.inputPi()
      case .equal : brain.equal()
      case .dot : brain.inputDot()
      case .clear : brain.clearOutput()
      case .clearS : brain.removeLastSymbol()
      default: break
    }
  }
    
  private func input(_ operation: String) {
    brain.input(operation)
  }
}
