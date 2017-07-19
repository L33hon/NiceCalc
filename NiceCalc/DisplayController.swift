//
//  DisplayController.swift
//  NiceCalc
//
//  Created by Yaroslav Luchyt on 7/3/17.
//  Copyright © 2017 Yaroslav Luchyt. All rights reserved.
//

import UIKit

class DisplayController: UIViewController {

    @IBOutlet  var display: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let output = OutputAdapter.shared
    
    func present(_ value: String) {
        if display.text!.characters.count < value.characters.count {
            scrollView.scrollRectToVisible(display.bounds, animated: true)
        }
        display.text = value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.resultDisplay = { [weak self] display in
            self?.present(display)
        }
        
    }
}
