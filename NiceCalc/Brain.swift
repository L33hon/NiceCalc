//
//  Brain.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

class Brain: Model {
    static let shared = Brain()
    let output = OutputAdapter.shared
    var equation = ""
    var display = "0"
    var IsStartingNewEquation = true
    
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
    
    func needAMultiplySign() -> Bool {
        let lastCharacter = display.characters.last!
        return (lastCharacter >= "0" && lastCharacter <= "9") || lastCharacter == ")"
    }
    
    func lastSymbolIsAnOperator() -> Bool {
        let lastCharacter = display.characters.last!
        return !(lastCharacter >= "0" && lastCharacter <= "9")
    }
    
    func caseOfAction(_ char: String) -> Int {
        if char == "^" || char == "√" || char == "×" || char == "÷" || char == "+" || char == "-" || char == "(" || char == ")" {
            return 1    //need equation += " * "
        }
        else if char == "c" || char == "s"  {
            return 2    //need equation += "*** "
        }
        else if char == "l" {
            return 3    //need equation += "** "
        }
        else if char == "π" {
            return 4    //π
        }
        else {
            return 0    //need equation += "*"
        }
    }
    
    func input(_ number: Int) {
        if IsStartingNewEquation {
            display = "\(number)"
        }
        else {
            display += "\(number)"
        }
        process()
    }
    
    func input(_ operation: String) {
        display += operation
        process()
    }
    
    func inputPi() {
        if !IsStartingNewEquation {
            if needAMultiplySign() {
                display += "×π"
            }
            else {
                display += "π"
            }
        }
        else {
            display = "π"
        }
        process()
    }
    
    func inputDot() {
        if lastSymbolIsAnOperator() {
            display += "0."
        }
        else {
            display += "."
        }
        process()
    }
    
    func clearOutput() {
        display = "0"
        process()
        IsStartingNewEquation = true
    }
    
    func removeLastSymbol() {
        if display.characters.count > 1 {
            display.characters.removeLast()
        }
        else {
            display = "0"
            IsStartingNewEquation = true
        }
        process()
    }
    
    func process() {
        output.preseneqtResult(result: display)
        IsStartingNewEquation = false
    }
    
    func equal() {
        enterEquation(equation: display)
        equation = String(calculateResult())
        display = equation
        equation = ""
        process()
        IsStartingNewEquation = true
        
    }
    
    func enterEquation(equation: String) {
        var example = equation
        while example.characters.count > 0 {
            let fisrtDisplaySymbol = String(example.characters.removeFirst())
            let myCase = caseOfAction(fisrtDisplaySymbol)
            switch myCase {
            case 0:
                self.equation += fisrtDisplaySymbol
            case 1:
                self.equation += " " + fisrtDisplaySymbol + " "
            case 2:
                self.equation += fisrtDisplaySymbol + String(example.characters.removeFirst()) + String(example.characters.removeFirst()) + " "
            case 3:
                self.equation += fisrtDisplaySymbol + String(example.characters.removeFirst()) + " "
            case 4:
                self.equation += String(Double.pi)
            default:
                break
            }
        }
        process()
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
    
    func calculateResult() -> Double {
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
