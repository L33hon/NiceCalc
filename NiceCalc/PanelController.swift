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
            keyboard.onServiceTap = { [weak self] tag in
                self?.onServiceTap(tag)
            }
        }
    }
    
    func onNumericTap(_ num: Int) {
        inputAdapter.input(num)
    }
    
    func onOperatorTap(_ tag: Int) {
        inputAdapter.input(operationTag: tag)
    }

    func onServiceTap(_ tag: Int) {
        inputAdapter.onServiseTap(tag: tag)
    }
}
