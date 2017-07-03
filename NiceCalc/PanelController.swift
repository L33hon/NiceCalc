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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplayControllerSegue", let controller = segue.destination as? DisplayController {
            
            display = controller
        } else if segue.identifier == "KeyboardControllerSegue", let controller = segue.destination as? KeyboardController {
            
            keyboard = controller
            keyboard.onNumTap = { [weak self] num in
                self?.onNumericTap(num: num)
            }
        }
    }
    
    func onNumericTap(num: Int) {
        IntputAdapter.shared.input(value: num)
    }

}