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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 1, delay: 0.2, animations: {
            self.scroll.setContentOffset(.init(x: 20, y: 0), animated: false)
        }) { _ in
            UIView.animate(withDuration: 1, animations: { 
                self.scroll.setContentOffset(.init(x: 0, y: 0), animated: false)
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.updateViewConstraints()
    }
}

