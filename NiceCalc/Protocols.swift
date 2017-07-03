//
//  Protocols.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/2/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

enum Operation {
    case pls
    case min
    case mul
    case div
    case equal
}

protocol InputProtocol {
    func input(value: Int)
    func input(operation: Operation)
}

protocol OutputProtocol {
    func output(value: String)
}

protocol Model {
    func input(operation: Operation)
}
