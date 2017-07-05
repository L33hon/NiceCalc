//
//  KeyboardController.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/2/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import UIKit

class KeyboardController: UIViewController {
    var onNumTap: ((_ num: Int)->())?
    var onUtilityTap: ((_ symbol: String)->())?
    var onServiceTap: ((_ keyIndex: Int)->())?
    
    @IBAction func onNumericTap(sender: UIButton) {
        onNumTap?(sender.tag)
        print(sender.tag)
    }
    
    @IBAction func onOperatorTap(_ sender: UIButton) {
        onUtilityTap?(sender.currentTitle!)
    }
    
    @IBAction func onServiceTap(_ sender: UIButton) {
        onServiceTap?(sender.tag)
    }
}

