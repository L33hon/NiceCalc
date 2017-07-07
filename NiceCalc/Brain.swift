//
//  Brain.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

class Brain/*: Model*/ {
    static let shared = Brain()
    let output = OutputAdapter.shared
    var equation = ""
    var operand: String = ""
    
    let operation = [
        "^": (prec: 4, rAssoc: true),
        "√": (prec: 5, rAssoc: true),
        "×": (prec: 3, rAssoc: false),
        "÷": (prec: 3, rAssoc: false),
        "+": (prec: 2, rAssoc: false),
        "−": (prec: 2, rAssoc: false),
        "sin": (prec: 5, rAssoc: true),
        "cos": (prec: 5, rAssoc: true),
        "ln": (prec: 4, rAssoc: true),
    ]
    
    func input(_ number: Int) {
        equation += "\(number)"
        process()
    }
    
    func input(_ operation: String) {
        equation += operation
        process()
    }
    
    func EnterEquation(equation: String) {
        self.equation = equation
        process()
    }
    
    func input(operation: Operation) {
        
    }
    
    func toTokens(_ equationStr: String) -> [String] {
        let tokens = equationStr.characters.split{ $0 == " " }.map(String.init)
        return tokens
    }
    
    func toPolandNotation(tokens: [String]) -> [String] {
        var polandNotation: [String] = []
        var stack : [String] = [] // buffer for operation
        for token in tokens.reversed() {
            switch token {
            case ")":
                stack += [token]
            case "(":
                while !stack.isEmpty {
                    if stack.removeLast() == ")" {
                        break
                    } else {
                        polandNotation = [stack.removeLast()] + polandNotation
                    }
                }
            default:
                if let firstOperand = operation[token] {
                    for op in stack.reversed() {
                        if let secondOperand = operation[op] {
                            if !(firstOperand.prec > secondOperand.prec || (firstOperand.prec == secondOperand.prec && firstOperand.rAssoc)) {
                                let lastOperator = [stack.removeLast()]
                                polandNotation = lastOperator + polandNotation
                                continue
                            }
                        }
                        break
                    }
                    stack += [token]
                    
                } else {
                    polandNotation = [token] + polandNotation
                }
            }
        }
        return (stack + polandNotation)
    }
    
    func process() {
        //....
        output.output(value: equation)
    }
}
