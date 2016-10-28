//
//  SpinnerView.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/13.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SpinnerView: AbstractAnimationView ,CAAnimationDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var frame: CGRect{
        didSet{
            prepare()
        }
    }
    
    let duration : TimeInterval = 0.8
    let radius : CGFloat = 30;
    let lineWidth : CGFloat = 4;
    
    let startAngle : CGFloat = CGFloat.pi * 3 / 2
    
    var startAnim : CAAnimation!
    var spinAnim : CAAnimationGroup!
    var completeAnim : CAAnimation!
     
    
    override func prepare(){

        //setup layer
        self.animationLayer.lineWidth = 0
        self.animationLayer.strokeColor = UIColor.black.cgColor
        self.animationLayer.fillColor = UIColor.clear.cgColor
        self.animationLayer.transform = CATransform3DMakeRotation(startAngle, 0, 0, 1)
        self.animationLayer.strokeStart = 0.95
        self.animationLayer.strokeEnd = 1
        
        let centerRect = CGRect(x: 0, y: 0, width: 2*radius, height: 2*radius)
        let circlePath = UIBezierPath(ovalIn: centerRect)
        self.animationLayer.path = circlePath.cgPath
        
        //start animation (line width grow)
        let lineGrowAnim = AnimationHelper.animation(keyPath: "lineWidth", from: 0, to: lineWidth, duration: 0.3)
        startAnim = lineGrowAnim
        
        //loading animation
        let strokeEndAnim = AnimationHelper.animation(keyPath: "strokeEnd", from: 0.05, to: 1, duration: self.duration)
        strokeEndAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.28, 0.19, 0.68, 0.93)
        let strokeStartAnim = AnimationHelper.animation(keyPath: "strokeStart", from: 0, to: 0.95, duration: self.duration)
        strokeStartAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.68, 0.03, 0.7, 0.9)
        
        let rotateAnim = AnimationHelper.animation(keyPath: "transform.rotation.z", from: startAngle, to: startAngle + 0.1 * CGFloat.pi, duration: self.duration/6)
        rotateAnim.beginTime = self.duration - self.duration / 12
        rotateAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.38, 0.08, 0.87, 0.75)
        
        let lowerGroup = CAAnimationGroup()
        
        lowerGroup.animations = [strokeEndAnim,strokeStartAnim,rotateAnim]
        lowerGroup.duration = self.duration + self.duration / 12
        
        lowerGroup.isRemovedOnCompletion = false
        lowerGroup.fillMode = kCAFillModeForwards
    
        lowerGroup.repeatCount = Float.greatestFiniteMagnitude
        
        spinAnim = lowerGroup
        
        //end animation (line width shrink)
        let lineShrinkAnim = AnimationHelper.animation(keyPath: "lineWidth", from: lineWidth, to: 0, duration: 0.3)
        completeAnim = lineShrinkAnim
        
        //repeat duration
        self.timeUntilStop = 2.22
        
    }
    
    override func start() {
        super.start()
        animationLayer.lineWidth = lineWidth
        animationLayer.add(startAnim, forKey: "spinner.start")
        animationLayer.add(spinAnim, forKey: "spinner.spinning")
        
        delegate?.animationDidStart()
    }
    
    override func stop() {
        super.stop()
        completeAnim.delegate = self
        animationLayer.lineWidth = 0
        animationLayer.add(completeAnim, forKey: "spinner.complete")
        
    }
    
    
    //MARK: - CAAnimation Delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animationLayer.removeAllAnimations()
            delegate?.animationDidFinished()
        }
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationLayer.frame = CGRect(x: self.frame.midX - radius, y: self.frame.midY - radius, width: 2*radius, height: 2*radius)

    }
    
}
