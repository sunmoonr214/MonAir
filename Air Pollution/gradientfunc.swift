//
//  gradientfunc.swift
//  Air Pollution
//
//  Created by Ray Wan on 2020/7/8.
//  Copyright © 2020 Ray Wan. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func setgradient(colorOne: UIColor, colorTwo:UIColor)
    {
        let gradientlayer = CAGradientLayer()
        
        gradientlayer.frame = bounds
        gradientlayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientlayer.locations = [0.0, 1.0]
        gradientlayer.startPoint = CGPoint(x:0.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradientlayer, at: 0)
        
    }
}
