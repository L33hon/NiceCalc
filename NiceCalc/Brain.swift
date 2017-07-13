//
//  Brain.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

class Brain: Model {
    static let shared = Brain()
    let output = OutputAdapter.shared
    var equation = ""
    var display = "0"
    var isStartingNewEquation = true
    var leftBracketsCount = 0
    var rightBracketsCount = 0
    
    let isBinary = [
        "^": true,
        "√": false,
        "×": true,
        "÷": true,
        "+": true,
        "﹣": true,
        "-": false,
        "sin": false,
        "cos": false,
        "ln": false,
        "(": false,
        ")": false,
    ]
    
    let operationPriorities = [
        "^": 4,
        "√": 5,
        "-": 5,
        "×": 3,
        "÷": 3,
        "+": 2,
        "﹣": 2,
        "sin": 5,
        "cos": 5,
        "ln": 4,
    ]
    
    func needAMultiplySign() -> Bool {
        let lastCharacter = display.characters.last!
        return (lastCharacter >= "0" && lastCharacter <= "9") || lastCharacter == ")"
    }
    
    func lastSymbolIsANumber() -> Bool {
        let lastCharacter = display.characters.last!
        return lastCharacter >= "0" && lastCharacter <= "9"
    }
    
    func caseOfAction(_ char: String) -> Int {
        if char == "^" || char == "-" || char == "√" || char == "×" || char == "÷" || char == "+" || char == "﹣" || char == "(" || char == ")" {
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
        if isStartingNewEquation {
            display = "\(number)"
        }
        else {
            if display.characters.last! == "π" {
                display += " ÷ \(number)"
            }
            else {
                display += "\(number)"
            }
        }
        process()
    }
    
    func input(_ operation: String) {
        if isBinary[operation]! {
            validatedBinaryInput(operation)
        }
        else {
            validatedUnaryInput(operation)
            process()
        }
    }
    
    func validatedBinaryInput(_ operation: String) {
        if isStartingNewEquation {
            if equation != "" {
                display += " " + operation + " "
                process()
            }
        }
        else {
            if display.characters.last == " " {
                display.characters.removeLast()
                display = display.components(separatedBy: " ").dropLast().joined(separator: " ") + " " + operation + " "
                process()
            }
            else if display.characters.last == "." {
                display.characters.removeLast()
                display += " " + operation + " "
                process()
            }
            else if lastSymbolIsANumber() || display.characters.last! == "π" || display.characters.last! == ")" {
                display += " " + operation + " "
                process()
            }
        }
    }
    
    func validatedUnaryInput(_ operation: String) {
        if isStartingNewEquation {
            display = operation
        }
        else {
            display += operation
        }
    }
    
//    func input(_ operation: String) {
//        if isBinary[operation]! {
//            display += " " + operation + " "
//        }
//        else {
//            display += operation
//        }
//        process()
//    }
    
    func inputMinus() {
        if isStartingNewEquation {
            if equation == "" {
                display = "-"
                process()
            }
            else {
                display += " ﹣ "
                process()
            }
        }
        else {
            let last = String(display.characters.last!)
            if last == " " {
                display.characters.removeLast()
                display = display.components(separatedBy: " ").dropLast().joined(separator: " ") + " ﹣ "
                process()
            }
            else if last == "." {
                display.characters.removeLast()
                display += " ﹣ "
                process()
            }
            else if lastSymbolIsANumber() || last == "π" || last == ")" {
                display += " ﹣ "
                process()
            }
            else if last == "(" || last == "√" || last == "sin" || last == "cos" || last == "ln" {
                display += "-"
                process()
            }
        }
    }
    
    func leftBracket() {
        leftBracketsCount += 1
        if isStartingNewEquation {
            display = "("
        }
        else {
            let char = String(display.characters.last!)
            if char != " " {
                if char == "." {
                    display.characters.removeLast()
                    display += " × ("
                }
                else if !lastSymbolIsANumber() {
                    display += "("
                }
                else {
                    display += " × ("
                }
            }
            else {
                display += "("
            }
        }
        process()
    }
    
    func rightBracket() {
        if leftBracketsCount > rightBracketsCount {
            let char = String(display.characters.last!)
            if char != "(" {
                if char == "π" || lastSymbolIsANumber() || char == ")" {
                    display += ")"
                    rightBracketsCount += 1
                }
                else if char == "." {
                    display.characters.removeLast()
                    display += ")"
                    rightBracketsCount += 1
                }
            }
        }
        process()
    }
    
    func inputPi() {
        if !isStartingNewEquation {
            if needAMultiplySign() {
                display += " × π"
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
        if display.characters.last! != "π" {
            if !lastSymbolIsANumber() && display.characters.last != "." {
                display += "0."
            }
            else {
                let number = display.components(separatedBy: " ").last!
                if number.range(of: ".") == nil {
                    display += "."
                }
            }
            process()
        }
    }
    
    func containsANumber() -> Bool {
        if display.characters.contains("0") ||
            display.characters.contains("1") ||
            display.characters.contains("2") ||
            display.characters.contains("3") ||
            display.characters.contains("4") ||
            display.characters.contains("5") ||
            display.characters.contains("6") ||
            display.characters.contains("7") ||
            display.characters.contains("8") ||
            display.characters.contains("9") {
            return true
        }
        else {
            return false
        }
    }
    
    func clearOutput() {
        display = "0"
        equation = ""
        leftBracketsCount = 0
        rightBracketsCount = 0
        process()
        isStartingNewEquation = true
    }
    
    func removeLastSymbol() {
        if display.characters.count > 1 {
            let char = display.characters.removeLast()
            switch char {
            case " ": display = display.components(separatedBy: " ").dropLast().joined(separator: " ")
            case "(": leftBracketsCount -= 1
            case ")": rightBracketsCount -= 1
            default:
                break
            }
        }
        else {
            display = "0"
            isStartingNewEquation = true
        }
        process()
    }
    
    func process() {
        output.presentResult(result: display)
        isStartingNewEquation = false
    }
    
    func equal() {
        if containsANumber() || display.characters.contains("π") {
            while !lastSymbolIsANumber() && display.characters.last! != "π" {
                if display.characters.last! == ")" {
                    rightBracketsCount -= 1
                }
                if display.characters.last! == "(" {
                    leftBracketsCount -= 1
                }
                display.characters.removeLast()
            }
            var neededBrackets = leftBracketsCount - rightBracketsCount
            while neededBrackets > 0 {
                neededBrackets -= 1
                display += ")"
            }
            enterEquation(equation: display)
            equation = calculateResult()
            display = equation
            process()
            leftBracketsCount = 0
            rightBracketsCount = 0
            isStartingNewEquation = true
        }
    }
    
    func enterEquation(equation: String) {
        self.equation = ""
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
    
    func calculateResult() -> String {
        let equationInPNMode = toPolandNotation(tokens: toTokens(equation))
        var stack : [String] = [] // buffer for digit
        
        for token in equationInPNMode.reversed() {
            if Double(token) != nil {
                stack += [token]
                
            } else if token == "sin" || token == "-" || token == "cos" || token == "ln" || token == "√"{
                let number = Double(stack.removeLast())
                
                switch token {
                case "sin": stack += [String(sin(number!))]
                case "cos": stack += [String(cos(number!))]
                case "ln": stack += [String(log(number!))]
                case "√": stack += [String(sqrt(number!))]
                case "-" : stack += [String(-number!)]
                default: break
                }
            } else {
                let firstNumber = Double(stack.removeLast())
                let secondNumber = Double(stack.removeLast())
                
                switch token {
                case "+": stack += [String(firstNumber! + secondNumber!)]
                case "﹣": stack += [String(firstNumber! - secondNumber!)]
                case "÷": stack += [String(firstNumber! / secondNumber!)]
                case "×": stack += [String(firstNumber! * secondNumber!)]
                case "^": stack += [String(pow(firstNumber!,secondNumber!))]
                default: break
                }
            }
        }
        let res = round(Double(stack.removeLast())! * pow(10, 10)) / pow(10, 10)
        if res < 0 {
            
            return "-" + (-res).cleanValue
        }
        else {
            return res.cleanValue
        }
    }
}
