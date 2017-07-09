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
    
    let brain = Brain.shared
    
    func enterNum(_ number: Int) {
        brain.input(number)
    }
    
    func enterUtility(_ symbol: Int) {
        switch symbol {
        case 10 : brain.removeLastSymbol()
        case 11 : brain.clearOutput()
        case Operation.pls.rawValue : input("+")
        case Operation.mns.rawValue : input("-")
        case Operation.mul.rawValue : input("×")
        case Operation.div.rawValue : input("÷")
        case Operation.pow.rawValue : input("^")
        case Operation.sqrt.rawValue : input("√")
        case Operation.sin.rawValue : input("sin")
        case Operation.cos.rawValue : input("cos")
        case Operation.log.rawValue : input("ln")
        case Operation.leftBracket.rawValue : input("(")
        case Operation.rightBracket.rawValue : input(")")
        case Operation.pi.rawValue : brain.inputPi()
        case Operation.equal.rawValue : brain.equal()
        case Operation.dot.rawValue : brain.inputDot()
        default : break
        }
    }
    
    func input(_ operation: String) {
        brain.input(operation)
    }
}

