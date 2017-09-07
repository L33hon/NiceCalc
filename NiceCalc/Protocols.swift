//
//  Protocols.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/2/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

protocol InputProtocol {
    func enterNum(_ number: Int)
    func enterUtility(_ symbol: Operation)
}

protocol OutputProtocol {
    func presentResult(result: String)
}

protocol Model {
    func enterEquation(equation: String)
}

enum Operation: Int {
    case pls = 10001
    case mns = 10002
    case mul = 10003
    case div = 10004
    case pow = 10005
    case sqrt = 10006
    case sin = 10007
    case cos = 10008
    case log = 10009
    case leftBracket = 10010
    case rightBracket = 10011
    case pi = 10012
    case equal = 10013
    case clear = 10014
    case dot = 10015
    case sign = 10016
    case per = 10017
    case e = 10018
    case tan = 10019
    case factor = 10020
    case log10 = 10021
    case exp = 10022
    case ctg = 10023
    case clearS = 10024
}

enum StrOperation: String {
    case power = "^"
    case sqrt = "√"
    case multiply = "×"
    case divide = "÷"
    case plus = "+"
    case binaryMinus = "﹣"
    case unaryMinus = "-"
    case sin = "sin"
    case cos = "cos"
    case ln = "ln"
    case leftBracket = "("
    case rightBracket = ")"
}
