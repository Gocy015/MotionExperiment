//
//  CALayer+Extensions.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/29.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

extension CAShapeLayer{
    static func cleanLayer() -> CAShapeLayer{
        let layer = self.init()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        return layer
    }
}
