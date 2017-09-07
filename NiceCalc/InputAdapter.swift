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
        case .pls : input(StrOperation.plus.rawValue)
        case .mns : brain.inputMinus()
        case .mul : input(StrOperation.multiply.rawValue)
        case .div : input(StrOperation.divide.rawValue)
        case .pow : input(StrOperation.power.rawValue)
        case .sqrt : input(StrOperation.sqrt.rawValue)
        case .sin : input(StrOperation.sin.rawValue)
        case .cos : input(StrOperation.cos.rawValue)
        case .log : input(StrOperation.ln.rawValue)
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
