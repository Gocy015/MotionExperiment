//
//  UILabel+CustomInit.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/18.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

extension UILabel{
    static func descriptionLabel(withDescription des:String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        label.text = des
        label.sizeToFit()
        return label
    }
}


extension UIColor{
    static func colorWithAbsolute(red r:Float ,green g:Float , blue b:Float , alpha a:Float) -> UIColor{
        let red = self.normalizeColor(r) / 255.0
        let green = self.normalizeColor(g) / 255.0
        let blue = self.normalizeColor(b) / 255.0
        let alpha = max(0, min(a,1))
        
        return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
    }
    
    static private func normalizeColor(_ value:Float) -> Float{
        let normallized = max(0, min(value, 255))
        return normallized
    }
}
