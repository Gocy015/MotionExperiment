//
//  GradientView.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/3.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradientLayer = CAGradientLayer()
    
    init(fromColor from:UIColor ,toColor to:UIColor ,startPoint start:CGPoint , endPoint end:CGPoint) {
        super.init(frame:.zero)
        gradientLayer.colors = [from.cgColor,to.cgColor]
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
    }
}
