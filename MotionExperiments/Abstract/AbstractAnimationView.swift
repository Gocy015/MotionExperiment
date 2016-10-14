//
//  AbstractAnimationView.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/13.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

protocol AnimationViewDelegate : class {
    func animationDidStart()
    func animationDidFinished()
}

class AbstractAnimationView: UIView {
    
    let animationLayer = CAShapeLayer()
    weak var delegate : AnimationViewDelegate?
    var isAnimating : Bool = false
    
    required init(){
        
        super.init(frame:.zero)
        self.backgroundColor = UIColor.white
        self.layer.addSublayer(animationLayer)
        prepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.addSublayer(animationLayer)
        prepare()
    }
    
    func prepare(){
        
    }
    
    func start(){
        isAnimating = true
    }
    
    func stop(){
        isAnimating = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationLayer.frame = self.layer.bounds
    }
}
