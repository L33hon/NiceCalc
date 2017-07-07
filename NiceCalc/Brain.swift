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
    
    let operationPriorities = [
        "^": 4,
        "√": 5,
        "×": 3,
        "÷": 3,
        "+": 2,
        "−": 2,
        "sin": 5,
        "cos": 5,
        "ln": 4,
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
    
    func ReverseToPolandNotation(tokens: [String]) -> [String] {
        var preficsNotation: [String] = [] //main String array
        var stackWithOperators : [String] = [] // buffer for operations
        for token in tokens.reversed() {
            switch token {
            case ")":
                stackWithOperators += [token]
            case "(":
                while !stackWithOperators.isEmpty {
                    let operatorInStack = stackWithOperators.removeLast()
                    if operatorInStack == ")" {
                        break
                    } else {
                        preficsNotation = [operatorInStack] + preficsNotation
                    }
                }
            default:
                if let currentOperatorPriority = operationPriorities[token] {// if this is an Operator
                    for operatorInStack in stackWithOperators.reversed() {
                        if let stackOperatorPriority = operationPriorities[operatorInStack] {
                            if !(currentOperatorPriority > stackOperatorPriority) {
                                let lastElement = [stackWithOperators.removeLast()]
                                preficsNotation = lastElement + preficsNotation
                                continue
                            }
                        }
                        break
                    }
                    stackWithOperators += [token]
                } else {//if this is a Number
                    preficsNotation = [token] + preficsNotation
                }
            }
        }
        return (stackWithOperators + preficsNotation)// adding all operations that left in the stack
    }

    
    func process() {
        //....
        output.output(value: equation)
    }
}
