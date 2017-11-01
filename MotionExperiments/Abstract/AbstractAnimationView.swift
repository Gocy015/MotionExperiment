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
    var timeUntilStop : TimeInterval = 0 
    
    required init(){
        
        super.init(frame:.zero)
        self.backgroundColor = UIColor.white
        animationLayer.fillColor = UIColor.clear.cgColor
        animationLayer.strokeColor = UIColor.clear.cgColor
        self.layer.addSublayer(animationLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.addSublayer(animationLayer) 
    }
    
    func prepare(){
        
    }
    
    func start(){
        isAnimating = true
    }
    
    @objc func stop(){
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
