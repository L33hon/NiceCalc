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
    
    private let operationPriorities = [
        "^": 4,
        "√": 5,
        "-": 5,
        "×": 3,
        "÷": 3,
        "+": 2,
        "﹣": 2,
        "sin": 5,
        "cos": 5,
        "ln": 5,
      ]
    
    private func needAMultiplySign() -> Bool {
        let last = display.characters.last!
        return (last >= "0" && last <= "9") || last == ")" || last == "π"
    }
    
    private func lastSymbolIsANumber() -> Bool {
        let lastCharacter = display.characters.last!
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
                    display += " ÷ \(number)"
                case ")":
                    display += " × \(number)"
                default:
                    display += "\(number)"
                }
            }
        }
        process()
    }
    
    func input(_ operation: String) {
        if isBinary[operation]! {
            validatedBinaryInput(operation)
        } else {
            validatedUnaryInput(operation)
            process()
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
            } else if lastSymbolIsANumber() || display.characters.last! == "π" ||
                display.characters.last! == ")" {
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
            let char = display.characters.last!
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
                display = "-"
                process()
            } else {
                display += " ﹣ "
                process()
            }
        } else {
            let last = String(display.characters.last!)
            let unaryMinusRequired = [ "(", "√", "n", "s"]
            if last == " " {
                display.characters.removeLast()
                display = display.components(separatedBy: " ").dropLast().joined(separator: " ") + " ﹣ "
                process()
            } else if last == "." {
                display.characters.removeLast()
                display += " ﹣ "
                process()
            } else if lastSymbolIsANumber() || last == "π" || last == ")" {
                display += " ﹣ "
                process()
            } else if unaryMinusRequired.contains(last) {
                display += "-"
                process()
            }
        }
    }
    
    func leftBracket() {
        leftBracketsCount += 1
        if isStartingNewEquation {
            display = "("
        } else {
            let char = String(display.characters.last!)
            if char != " " {
                if char == "." {
                    display.characters.removeLast()
                    display += " × ("
                } else if !lastSymbolIsANumber() || char == "π" {
                    display += "("
                } else {
                    display += " × ("
                }
            } else {
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
            if needAMultiplySign() || display.characters.last! == "." {
                if display.characters.last! == "." {
                    display.characters.removeLast()
                }
                display += " × π"
            } else {
                display += "π"
            }
        } else {
            display = "π"
        }
        process()
    }
    
    func inputDot() {
        if display.characters.last! != "π" {
            if !lastSymbolIsANumber() && display.characters.last != "." {
                display += "0."
            } else {
                let number = display.components(separatedBy: " ").last!
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
                if display.characters.last! == "l" {
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
        let unaryOperations = ["sin", "-", "cos", "ln", "√"]
        for word in equationInPNMode.reversed() {
            if Double(word) != nil {
                stack += [word]
            } else if unaryOperations.contains(word) {
                let number = Double(stack.removeLast())
                switch word {
                    case "sin": stack += [String(sin(number!))]
                    case "cos": stack += [String(cos(number!))]
                    case "ln": stack += [String(log(number!))]
                    case "√": stack += [String(sqrt(number!))]
                    case "-" : stack += [String(number! * (-1))]
                    default: break
                }
            } else {
                let firstNumber = Double(stack.removeLast())
                let secondNumber = Double(stack.removeLast())
                switch word {
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
