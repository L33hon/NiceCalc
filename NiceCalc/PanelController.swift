//
//  PanelController.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import UIKit

class PanelController: UIViewController {

    private var display: DisplayController!
    private var keyboard: KeyboardController!
    private let inputAdapter = InputAdapter.shared
    
    internal func onUtilityTap(symbol: Int) {
        let op = Operation(rawValue: symbol)
        inputAdapter.enterUtility(op!)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplayControllerSegue", let controller = segue.destination as? DisplayController {
                
            display = controller
        } else if segue.identifier == "KeyboardControllerSegue", let controller = segue.destination as? KeyboardController {
                
            keyboard = controller
            keyboard.onNumTap = { [weak self] num in
                self?.inputAdapter.enterNum(num)
            }
            keyboard.onUtilityTap = { [weak self] symbol in
                self?.onUtilityTap(symbol: symbol)
            }
        }
    }
}
