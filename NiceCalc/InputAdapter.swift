//
//  InputAdapter.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import Foundation

class InputAdapter {
    static let shared = InputAdapter()
    
    let brain = Brain.shared
    
    func input(_ value: Int) {
        // Conversion if needed
        brain.input(value)
    }
    
    func input(_ operation: String) {
        brain.input(operation)
    }
    
    func input(operation: Operation) {
        brain.input(operation: operation)
    }
}

