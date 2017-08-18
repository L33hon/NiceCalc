//
//  RoundButton.swift
//  Calculator
//
//  Created by Kristina Del Rio Albrechet on 7/8/17.
//  Copyright © 2017 Kristina Del Rio Albrechet. All rights reserved.
//

import UIKit

/// This class make round/circle UIButtons
@IBDesignable
class RoundButton: UIButton {
    
    /// This is property that set corner radius for element
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadious
        }
    }
    
    /// This is property that set border size
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    /// This is property that set border color
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
