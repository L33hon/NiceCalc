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
    private let output = OutputAdapter.shared
    private var equation = ""
    private var display = "0"
    private var isStartingNewEquation = true
    private var leftBracketsCount = 0
    private var rightBracketsCount = 0
    
    private let isBinary = [
        StrOperation.power.rawValue: true,
        StrOperation.sqrt.rawValue: false,
        StrOperation.multiply.rawValue: true,
        StrOperation.divide.rawValue: true,
        StrOperation.plus.rawValue: true,
        StrOperation.binaryMinus.rawValue: true,
        StrOperation.unaryMinus.rawValue: false,
        StrOperation.sin.rawValue: false,
        StrOperation.cos.rawValue: false,
        StrOperation.ln.rawValue: false,
        StrOperation.leftBracket.rawValue: false,
        StrOperation.rightBracket.rawValue: false,
    ]
    
    private let operationPriorities = [
        StrOperation.power.rawValue: 4,
        StrOperation.sqrt.rawValue: 5,
        StrOperation.unaryMinus.rawValue: 5,
        StrOperation.multiply.rawValue: 3,
        StrOperation.divide.rawValue: 3,
        StrOperation.plus.rawValue: 2,
        StrOperation.binaryMinus.rawValue: 2,
        StrOperation.sin.rawValue: 5,
        StrOperation.cos.rawValue: 5,
        StrOperation.ln.rawValue: 5,
      ]
    
    private func needAMultiplySign() -> Bool {
        let last = display.characters.last ?? " "
        return (last >= "0" && last <= "9") || last == ")" || last == "π"
    }
    
    private func lastSymbolIsANumber() -> Bool {
        let lastCharacter = display.characters.last ?? " "
        return lastCharacter >= "0" && lastCharacter <= "9"
    }
    
    private func caseOfAction(_ char: String) -> Int {
        let firstCaseCharacters = "^-√×÷+﹣()"
        if firstCaseCharacters.characters.contains(Character(char)) {
            return 1    //need equation += " * "
        } else if char == "c" || char == "s"  {
            return 2    //need equation += "*** "
        } else if char == "l" {
            return 3    //need equation += "** "
        } else if char == "π" {
            return 4    //π
        } else {
            return 0    //need equation += "*"
        }
    }
    
    func input(_ number: Int) {
        if isStartingNewEquation {
            display = "\(number)"
        } else {
            if let lastChar = display.characters.last {
                switch lastChar {
                case "π":
                    display += " " + StrOperation.divide.rawValue + "\(number)"
                case ")":
                    display += " " + StrOperation.multiply.rawValue + "\(number)"
                default:
                    display += "\(number)"
                }
            }
        }
        process()
    }
    
    func input(_ operation: String) {
        if let isBinary = isBinary[operation] {
            if isBinary {
                validatedBinaryInput(operation)
            } else {
                validatedUnaryInput(operation)
                process()
            }
        }
    }
    
    private func validatedBinaryInput(_ operation: String) {
        if isStartingNewEquation {
            if equation != "" {
                display += " " + operation + " "
                process()
            }
        } else {
            if display.characters.last == " " {
                display.characters.removeLast()
                display = display.components(separatedBy: " ").dropLast()
                    .joined(separator: " ") + " " + operation + " "
                process()
            } else if display.characters.last == "." {
                display.characters.removeLast()
                display += " " + operation + " "
                process()
            } else if lastSymbolIsANumber() || display.characters.last == "π" ||
                display.characters.last == ")" {
                display += " " + operation + " "
                process()
            }
        }
    }
    
    private func validatedUnaryInput(_ operation: String) {
        if isStartingNewEquation {
            display = operation
        }
        else {
            let char = display.characters.last
            if lastSymbolIsANumber() || char == "π" || char == ")" {
                display += " × " + operation
            } else if char == "." {
                display.characters.removeLast()
                display += " × " + operation
            } else {
                display += operation
            }
        }
    }
    
    func inputMinus() {
        if isStartingNewEquation {
            if equation == "" {
                display = StrOperation.unaryMinus.rawValue
                process()
            } else {
                display += " " + StrOperation.binaryMinus.rawValue + " "
                process()
            }
        } else {
            let lastCharacter = display.characters.last ?? " "
            let last = String(lastCharacter)
            let unaryMinusRequired = [ "(", StrOperation.sqrt.rawValue, "n", "s"]
            if last == " " {
                display.characters.removeLast()
                display = display.components(separatedBy: " ").dropLast().joined(separator: " ") + " " + StrOperation.binaryMinus.rawValue + " "
                process()
            } else if last == "." {
                display.characters.removeLast()
                display += " " + StrOperation.binaryMinus.rawValue + " "
                process()
            } else if lastSymbolIsANumber() || last == "π" || last == ")" {
                display += " " + StrOperation.binaryMinus.rawValue + " "
                process()
            } else if unaryMinusRequired.contains(last) {
                display += StrOperation.unaryMinus.rawValue
                process()
            }
        }
    }
    
    func leftBracket() {
        leftBracketsCount += 1
        if isStartingNewEquation {
            display = "("
        } else {
            let lastCharacter = display.characters.last ?? " "
            let last = String(lastCharacter)
            if last != " " {
                if last == "." {
                    display.characters.removeLast()
                    display += " " + StrOperation.multiply.rawValue + " ("
                } else if !lastSymbolIsANumber(), last != "π" {
                    display += "("
                } else {
                    display += " " + StrOperation.multiply.rawValue + " ("
                }
            } else {
                display += "("
            }
        }
        process()
    }
    
    func rightBracket() {
        if leftBracketsCount > rightBracketsCount {
            let lastCharacter = display.characters.last ?? " "
            let char = String(lastCharacter)
            if char != "(" {
                if char == "π" || lastSymbolIsANumber() || char == ")" {
                    display += ")"
                    rightBracketsCount += 1
                } else if char == "." {
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
            let lastCharacter = display.characters.last ?? " "
            if needAMultiplySign() || lastCharacter == "." {
                if lastCharacter == "." {
                    display.characters.removeLast()
                }
                display += " " + StrOperation.multiply.rawValue + " π"
            } else {
                display += "π"
            }
        } else {
            display = "π"
        }
        process()
    }
    
    func inputDot() {
        let lastCharacter = display.characters.last ?? " "
        if lastCharacter != "π" {
            if !lastSymbolIsANumber() && lastCharacter != "." {
                display += "0."
            } else {
                let number = display.components(separatedBy: " ").last ?? " "
                if number.range(of: ".") == nil {
                    display += "."
                }
            }
            process()
        }
    }
    
    private func containsANumber() -> Bool {
        let numbers = "0123456789"
        for char in numbers.characters {
            if display.characters.contains(char) {
                return true
            }
        }
        return false
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
        let char = display.characters.removeLast()
        switch char {
            case " ": display = display.components(separatedBy: " ").dropLast().joined(separator: " ")
            case "(": leftBracketsCount -= 1
            case ")": rightBracketsCount -= 1
            case "n":
                let lastCharacter = display.characters.last ?? " "
                if lastCharacter == "l" {
                    display.characters.removeLast()
                } else {
                    let indexForThirdLast = display.index(display.startIndex, offsetBy: display.characters.count - 2)
                    display = display.substring(to: indexForThirdLast)
            }
            case "s": let indexForThirdLast = display.index(display.startIndex, offsetBy: display.characters.count - 2)
                display = display.substring(to: indexForThirdLast)
            case "f": let indexForThirdLast = display.index(display.startIndex, offsetBy: display.characters.count - 2)
                display = display.substring(to: indexForThirdLast)
            default:
                break
        }
        if display.characters.count == 0 {
            display = "0"
            process()
            isStartingNewEquation = true
        } else {
            process()
        }
    }
    
    private func process() {
        output.presentResult(result: display)
        isStartingNewEquation = false
    }
    
    func equal() {
        if containsANumber() || display.characters.contains("π") {
            var lastCharacter = display.characters.last ?? " "
            while !lastSymbolIsANumber() && lastCharacter != "π" {
                if lastCharacter == ")" {
                    rightBracketsCount -= 1
                }
                if lastCharacter == "(" {
                    leftBracketsCount -= 1
                }
                display.characters.removeLast()
                lastCharacter = display.characters.last ?? " "
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
            if equation == "inf" || equation == "-inf" || equation == "nan" {
                equation = ""
            }
            isStartingNewEquation = true
        }
    }
    
    internal func enterEquation(equation: String) {
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
                    let indexForThird = example.index(example.startIndex, offsetBy: 2)
                    self.equation += fisrtDisplaySymbol + example.substring(to: indexForThird) + " "
                    example = example.substring(from: indexForThird)
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
    
    private func toWords(_ parsedEquation: String) -> [String] {
        let words = parsedEquation.components(separatedBy: " ")
        return words
    }
    
    private func toPolandNotation(words: [String]) -> [String] {
        var preficsNotation: [String] = [] //main String array
        var Operators : [String] = [] // buffer for operations
        for word in words.reversed() {
            if word != "" {
                switch word {
                    case ")":
                        Operators += [word]
                    case "(":
                        while !Operators.isEmpty {
                            let operatorInStack = Operators.removeLast()
                            if operatorInStack == ")" {
                                break
                            } else {
                                preficsNotation = [operatorInStack] + preficsNotation
                            }
                      }
                    default:
                        if let currentOperatorPriority = operationPriorities[word] {// if this is an Operator
                            for operatorInStack in Operators.reversed() {
                                if let stackOperatorPriority = operationPriorities[operatorInStack] {
                                    if !(currentOperatorPriority > stackOperatorPriority) {
                                        let lastElement = [Operators.removeLast()]
                                        preficsNotation = lastElement + preficsNotation
                                        continue
                                    }
                                }
                                break
                            }
                            Operators += [word]
                        } else {//if this is a Number
                            preficsNotation = [word] + preficsNotation
                        }
                }
            }
        }
        return (Operators + preficsNotation)// adding all operations that left in the stack
    }
    
    private func calculateResult() -> String {
        let equationInPNMode = toPolandNotation(words: toWords(equation))
        var stack : [String] = [] // buffer for digit
        let unaryOperations = [StrOperation.sin.rawValue,
                               StrOperation.unaryMinus.rawValue,
                               StrOperation.cos.rawValue,
                               StrOperation.ln.rawValue,
                               StrOperation.sqrt.rawValue]
        for word in equationInPNMode.reversed() {
            if Double(word) != nil {
                stack += [word]
            } else if unaryOperations.contains(word) {
                let number = Double(stack.removeLast()) ?? 0
                switch word {
                    case StrOperation.sin.rawValue: stack += [String(sin(number))]
                    case StrOperation.cos.rawValue: stack += [String(cos(number))]
                    case StrOperation.ln.rawValue: stack += [String(log(number))]
                    case StrOperation.sqrt.rawValue: stack += [String(sqrt(number))]
                    case StrOperation.unaryMinus.rawValue : stack += [String(number * (-1))]
                    default: break
                }
            } else {
                let firstNumber = Double(stack.removeLast()) ?? 0
                let secondNumber = Double(stack.removeLast()) ?? 0
                switch word {
                    case StrOperation.plus.rawValue: stack += [String(firstNumber + secondNumber)]
                    case StrOperation.binaryMinus.rawValue: stack += [String(firstNumber - secondNumber)]
                    case StrOperation.divide.rawValue: stack += [String(firstNumber / secondNumber)]
                    case StrOperation.multiply.rawValue: stack += [String(firstNumber * secondNumber)]
                    case StrOperation.power.rawValue: stack += [String(pow(firstNumber,secondNumber))]
                    default: break
                }
            }
        }
        let remaining = Double(stack.removeLast()) ?? 0
        let res = round(remaining * pow(10, 10)) / pow(10, 10)
        if res == -res {
            return "0"
        } else {
            return res.cleanValue
        }
    }
}

extension Double {
    
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ?
            String(format: "%.0f", self) : String(self)
    }
}
