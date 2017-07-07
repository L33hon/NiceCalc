//
//  InputAdapter.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

class InputAdapter {
    static let shared = InputAdapter()
    
    let brain = Brain.shared
    
    func input(_ value: Int) {
        // Conversion if needed
        brain.input(value)
    }
    
    func input(operationTag: Int) {
        switch operationTag {
            case Operation.pls.rawValue : input("+")
            case Operation.mns.rawValue : input("-")
            case Operation.mul.rawValue : input("×")
            case Operation.div.rawValue : input("÷")
            case Operation.pow.rawValue : input("^")
            case Operation.sqrt.rawValue : input("√")
            case Operation.sin.rawValue : input("sin")
            case Operation.cos.rawValue : input("cos")
            case Operation.log.rawValue : input("log")
            case Operation.leftBracket.rawValue : input("(")
            case Operation.rightBracket.rawValue : input(")")
            case Operation.pi.rawValue : input("π")
            case Operation.equal.rawValue : brain.equal()
            case Operation.dot.rawValue : input(".")
        default:
            break
        }

    }
    
    func input(_ operation: String) {
        brain.input(operation)
    }
    
    func input(operation: Operation) {
        brain.input(operation: operation)
    }
    
}

