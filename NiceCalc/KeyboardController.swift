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
    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBAction func onNumericTap(button: UIButton) {
        onNumTap?(button.tag)
    }
    
    @IBAction func onOperatorTap(button: UIButton) {
        onUtilityTap?(button.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.scroll.setContentOffset(.init(x: 20, y: 0), animated: false)
        }) { _ in
            self.scroll.setContentOffset(.init(x: 0, y: 0), animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.updateViewConstraints()
    }
}

