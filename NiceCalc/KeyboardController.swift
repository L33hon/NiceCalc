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
  var onUtilityTap: ((_ symbol: Int)->())?
  var onServiceTap: ((_ keyIndex: Int)->())?
    
  @IBAction func onNumericTap(button: UIButton) {
    onNumTap?(button.tag)
  }
    
  @IBAction func onOperatorTap(button: UIButton) {
    onUtilityTap?(button.tag)
  }
}

