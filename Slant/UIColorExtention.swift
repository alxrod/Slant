//
//  UIColorExtention.swift
//  Slant
//
//  Created by Alex Rodriguez on 7/11/17.
//  Copyright © 2017 Alex Rodriguez. All rights reserved.
//

import Foundation
import SpriteKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    } }
