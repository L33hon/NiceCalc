//
//  InputAdapter.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

class IntputAdapter: InputProtocol {
    static let shared = IntputAdapter()
    
    let brain = Brain.shared
    
    func input(value: Int) {
        // Conversion if needed
        brain.input(number: value)
    }
    
    func input(operation: Operation) {
        brain.input(operation: operation)
    }
}

