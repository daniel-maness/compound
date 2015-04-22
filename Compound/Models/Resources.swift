//
//  ColorPalette.swift
//  Compound
//
//  Created by Daniel Maness on 3/18/15.
//  Copyright (c) 2015 Daniel Maness. All rights reserved.
//

import Foundation
import SpriteKit

struct ColorPalette {
    static let pink = SKColor(red: CGFloat(247.0 / 255.0), green: CGFloat(29.0 / 255.0), blue: CGFloat(150.0 / 255.0), alpha: CGFloat(1.0))
    static let blue = SKColor(red: CGFloat(59.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(152.0 / 255.0), alpha: CGFloat(1.0))
    static let darkGrey = SKColor(red: CGFloat(131.0 / 255.0), green: CGFloat(131.0 / 255.0), blue: CGFloat(131.0 / 255.0), alpha: CGFloat(1.0))
    static let lightGrey = SKColor(red: CGFloat(222.0 / 255.0), green: CGFloat(222.0 / 255.0), blue: CGFloat(222.0 / 255.0), alpha: CGFloat(1.0))
    static let white = SKColor.whiteColor()
    static let black = SKColor.blackColor()
}

struct FontSize {
    static let small: CGFloat = 16
    static let medium: CGFloat = 32
    static let large: CGFloat = 48
}

struct FontName {
    static let DinCondensed = "DINCondensed-Bold"
}