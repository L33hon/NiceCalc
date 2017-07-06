//
//  PanelController.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import UIKit

class PanelController: UIViewController {

    var display: DisplayController!
    var keyboard: KeyboardController!
    let inputAdapter = InputAdapter.shared
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplayControllerSegue", let controller = segue.destination as? DisplayController {
            
            display = controller
        } else if segue.identifier == "KeyboardControllerSegue", let controller = segue.destination as? KeyboardController {
            
            keyboard = controller
            keyboard.onNumTap = { [weak self] num in
                self?.onNumericTap(num)
            }
            keyboard.onUtilityTap = { [weak self] tag in
                self?.onOperatorTap(tag)
            }
        }
    }
    
    func onNumericTap(_ num: Int) {
        inputAdapter.input(num)
    }
    
    func onOperatorTap(_ tag: Int) {
        switch tag {
        case Operation.pls.rawValue : inputAdapter.input("+")
        case Operation.mns.rawValue : inputAdapter.input("-")
        case Operation.mul.rawValue : inputAdapter.input("×")
        case Operation.div.rawValue : inputAdapter.input("÷")
        case Operation.pow.rawValue : inputAdapter.input("^")
        case Operation.sqrt.rawValue : inputAdapter.input("√")
        case Operation.sin.rawValue : inputAdapter.input("sin")
        case Operation.cos.rawValue : inputAdapter.input("cos")
        case Operation.log.rawValue : inputAdapter.input("log")
        case Operation.leftBracket.rawValue : inputAdapter.input("(")
        case Operation.rightBracket.rawValue : inputAdapter.input(")")
        case Operation.pi.rawValue : inputAdapter.input("π")
        case Operation.equal.rawValue : inputAdapter.input("=")
        case Operation.dot.rawValue : inputAdapter.input(".")
        default:
            break
        }
    }

}
