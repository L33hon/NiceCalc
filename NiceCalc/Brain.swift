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
    var equation = "0.0"
    var display = "0.0"
    
    let operationPriorities = [
        "^": 4,
        "√": 5,
        "×": 3,
        "÷": 3,
        "+": 2,
        "-": 2,
        "sin": 5,
        "cos": 5,
        "ln": 4,
    ]
    
    func input(_ number: Int) {
        if !(equation == "0" || equation == "0.0") {
            equation += "\(number)"
            display += "\(number)"
        }
        else {
            equation = "\(number)"
            display = "\(number)"
        }
        process()
    }
    
    func input(_ operation: String) {
        equation += " " + operation + " "
        display += operation
        process()
    }
    
    func EnterEquation(equation: String) {
        self.equation = equation
        process()
    }
    
    func inputDot() {
        equation += "."
        display += "."
    }
    
    func clearOutput() {
        equation = "0.0"
        display = "0.0"
        process()
    }
    
    func removeLastSymbol() {
        if !(equation == "0.0" || equation == "") {
            if equation.characters.count > 1 {
                if equation.characters.removeLast() == " " {
                    equation.characters.removeLast()
                    equation.characters.removeLast()
                }
                display.characters.removeLast()
            }
            else {
                equation = "0"
                display = "0"
            }
            process()
        }
    }
    
    func equal() {
        if equation != "" {
            equation = String(CalculateResult())
            display = equation
            process()
        }
    }
    
    func input(operation: Operation) {
        
    }
    
    func toTokens(_ equationStr: String) -> [String] {
        let tokens = equationStr.characters.split{ $0 == " " }.map(String.init)
        return tokens
    }
    
    func toPolandNotation(tokens: [String]) -> [String] {
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
        //if equation == "" || equation == "0.0"
        output.output(value: display)
    }
    
    func CalculateResult() -> Double {
        let equationInPNMode = toPolandNotation(tokens: toTokens(equation))
        var stack : [String] = [] // buffer for digit
        
        for token in equationInPNMode.reversed() {
            if Double(token) != nil {
                stack += [token]
                
            } else if token == "sin" || token == "cos" || token == "ln" || token == "√"{
                let number = Double(stack.removeLast())
                
                switch token {
                case "sin": stack += [String(sin(number!))]
                case "cos": stack += [String(cos(number!))]
                case "ln": stack += [String(log(number!))]
                case "√": stack += [String(sqrt(number!))]
                default: break
                }
            } else {
                let firstNumber = Double(stack.removeLast())
                let secondNumber = Double(stack.removeLast())
                
                switch token {
                case "+": stack += [String(firstNumber! + secondNumber!)]
                case "-": stack += [String(firstNumber! - secondNumber!)]
                case "÷": stack += [String(firstNumber! / secondNumber!)]
                case "×": stack += [String(firstNumber! * secondNumber!)]
                case "^": stack += [String(pow(firstNumber!,secondNumber!))]
                default: break
                }
            }
        }
        return Double(stack.removeLast())!
    }
}
