//
//  TapAnimationLayer.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/22.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class TapAnimationLayer: CALayer ,CAAnimationDelegate{
    
    var centerCircleLayer : CAShapeLayer! = CAShapeLayer.cleanLayer()
    
    var outerCircleLayer : CAShapeLayer! = CAShapeLayer.cleanLayer()
    
    var innerCircleLayer : CAShapeLayer! = CAShapeLayer.cleanLayer()
    
    let comeinKey = "tap.comein"
    let goesoutKey = "tap.goesout"
    
    let ringWidth : CGFloat = 4
    
    var radius:CGFloat = 0
    
    init(frame:CGRect) {
        super.init()
        self.backgroundColor = UIColor.clear.cgColor
        self.frame = frame
        radius = min(frame.size.width, frame.size.height) / 2
        self.masksToBounds = false
        self.initSublayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSLog("TapAnimLayer deinit")
    }
    
    func animate(){
        
        if centerCircleLayer == nil {
            self.initSublayers()
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.opacity = 0
        
        CATransaction.commit()
        
        CATransaction.setDisableActions(false)
        self.opacity = 1
        
        let comein = AnimationHelper.animation(keyPath: "transform.scale", from: 2, to: 1, duration: 0.5)
        comein.timingFunction = CAMediaTimingFunction(controlPoints: 0.15, 1.55, 0.5, 1.24)
        comein.delegate = self
        
        comein.setValue(true, forKey: comeinKey)
        centerCircleLayer.add(comein, forKey: comeinKey)
        
    }
    
    private func animateRings(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        outerCircleLayer.opacity = 1
        innerCircleLayer.opacity = 1
        CATransaction.commit()
        CATransaction.setDisableActions(false)
        
        
        let growDuration : TimeInterval = 0.5
        let bounceDuration : TimeInterval = 0.22
        
        // outer Ring
        let outerRingPathBig = UIBezierPath(arcCenter: CGPoint(x:outerCircleLayer.bounds.midX , y:outerCircleLayer.bounds.midY), radius: 1.9 * radius - ringWidth/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let outerRingPath = UIBezierPath(arcCenter: CGPoint(x:outerCircleLayer.bounds.midX , y:outerCircleLayer.bounds.midY), radius: 1.6 * radius - ringWidth/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let outerRingAnimBig = AnimationHelper.bezierPathAnimation(from: UIBezierPath(cgPath:outerCircleLayer.path!), to: outerRingPathBig, duration: growDuration)
        outerRingAnimBig.timingFunction = CAMediaTimingFunction(controlPoints: 0.35, 0.63, 0.4, 1)
        
        let outerRingAnim = AnimationHelper.bezierPathAnimation(from: outerRingPathBig, to: outerRingPath, duration: bounceDuration)
        outerRingAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.08, 1, 0.4)
        
        let outerRingAnimGroup = AnimationHelper.generateAnimationGroup(outerRingAnimBig,outerRingAnim ,removeOnCompletion:false)
        
        let outerRingLineAnim = AnimationHelper.animation(keyPath: "lineWidth", from: ringWidth, to: 0, duration: bounceDuration * 0.9 , removeOnCompletion: false)
        outerRingLineAnim.beginTime = CACurrentMediaTime() + growDuration
        
        let outerRingColorAnim = AnimationHelper.animation(keyPath: "strokeColor", from: UIColor.white.withAlphaComponent(0.55).cgColor, to: UIColor.white.withAlphaComponent(0.01).cgColor, duration: growDuration * 1.2)
        
        outerRingColorAnim.beginTime = CACurrentMediaTime() + growDuration * 0.6
        
        outerCircleLayer.add(outerRingAnimGroup, forKey: nil)
        outerCircleLayer.add(outerRingLineAnim, forKey: nil)
        outerCircleLayer.add(outerRingColorAnim, forKey: nil)
   
        
        
        
        //innerRing
        let innerRingPathBig = UIBezierPath(arcCenter: CGPoint(x:innerCircleLayer.bounds.midX , y:innerCircleLayer.bounds.midY), radius: 1.5 * radius - ringWidth/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let innerRingPath = UIBezierPath(arcCenter: CGPoint(x:innerCircleLayer.bounds.midX , y:innerCircleLayer.bounds.midY), radius: 1.4 * radius - ringWidth/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let innerRingBounceAgainPath = UIBezierPath(arcCenter: CGPoint(x:innerCircleLayer.bounds.midX , y:innerCircleLayer.bounds.midY), radius: 1.45 * radius - ringWidth/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let innerRingAnimBig = AnimationHelper.bezierPathAnimation(from: UIBezierPath(cgPath:innerCircleLayer.path!), to: innerRingPathBig, duration: growDuration * 0.65)
        innerRingAnimBig.timingFunction = CAMediaTimingFunction(controlPoints: 0.35, 0.63, 0.4, 1)
        
        let innerRingAnim = AnimationHelper.bezierPathAnimation(from: innerRingPathBig, to: innerRingPath, duration: bounceDuration)
        innerRingAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.76, 0.18, 0.32, 0.9)
        
        let innerRingBounceAgainAnim = AnimationHelper.bezierPathAnimation(from: innerRingPath, to: innerRingBounceAgainPath, duration: bounceDuration / 2, removeOnCompletion: false)
        
        let innerRingAnimGroup = AnimationHelper.generateAnimationGroup(innerRingAnimBig,innerRingAnim,innerRingBounceAgainAnim ,removeOnCompletion:false)
        
        innerRingAnimGroup.beginTime = CACurrentMediaTime() + growDuration * 0.3
        
        let innerRingLineAnim = AnimationHelper.animation(keyPath: "lineWidth", from: ringWidth, to: 0, duration: bounceDuration * 1.6 , removeOnCompletion: false)
        innerRingLineAnim.beginTime = CACurrentMediaTime() + growDuration
        
        let innerRingColorAnim = AnimationHelper.animation(keyPath: "strokeColor", from: UIColor.white.withAlphaComponent(0.62).cgColor, to: UIColor.white.withAlphaComponent(0.01).cgColor, duration: growDuration * 0.2 +  bounceDuration * 1.8)
        
        innerRingColorAnim.beginTime = CACurrentMediaTime() + growDuration * 0.8
        
        innerCircleLayer.add(innerRingAnimGroup, forKey: nil)
        innerCircleLayer.add(innerRingLineAnim, forKey: nil)
        innerCircleLayer.add(innerRingColorAnim, forKey: nil)
        
        
        //center
        //shrink a little at first
        
        let centerScaleAnim = AnimationHelper.animation(keyPath: "transform.scale", from: 1, to: 0.9, duration: growDuration * 0.2 ,removeOnCompletion: false)
        
        centerScaleAnim.beginTime = CACurrentMediaTime() + growDuration * 0.9
        
        let centerMaskLayer = CAShapeLayer()
        centerMaskLayer.frame = centerCircleLayer.bounds
        
        let fromMask = UIBezierPath(rect:centerCircleLayer.bounds)
        
        fromMask.append(UIBezierPath(ovalIn: CGRect(x: centerCircleLayer.bounds.midX, y: centerCircleLayer.bounds.midY, width: 0, height: 0)))
        
        let toMask = UIBezierPath(rect:centerCircleLayer.bounds)
        toMask.append(UIBezierPath(ovalIn: centerCircleLayer.bounds))
        
        
        centerMaskLayer.path = fromMask.cgPath
        centerMaskLayer.fillRule = kCAFillRuleEvenOdd
        centerCircleLayer.mask = centerMaskLayer
        
        let centerShrinkAnim = AnimationHelper.bezierPathAnimation(from: fromMask, to: toMask, duration: growDuration * 0.1 + bounceDuration * 2 , removeOnCompletion: false)
        centerShrinkAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.55, 0.11, 0.52, 0.94)
        centerShrinkAnim.setValue(true, forKey: goesoutKey)
        centerShrinkAnim.delegate = self
        centerShrinkAnim.beginTime = centerScaleAnim.beginTime
        centerMaskLayer.add(centerShrinkAnim, forKey: goesoutKey)
        
        
        let centerColorAnim = AnimationHelper.animation(keyPath: "fillColor", from: UIColor.white.cgColor, to: UIColor.white.withAlphaComponent(0.3).cgColor, duration: bounceDuration * 1.6 ,removeOnCompletion: false)
        centerColorAnim.beginTime = centerScaleAnim.beginTime
        
        
        centerMaskLayer.add(centerColorAnim, forKey: nil)
        
    }
    
    
    func initSublayers(){
        
        
        centerCircleLayer = CAShapeLayer.cleanLayer()
        
        outerCircleLayer = CAShapeLayer.cleanLayer()
        innerCircleLayer = CAShapeLayer.cleanLayer()
        
        self.addSublayer(centerCircleLayer)
        centerCircleLayer.fillColor = UIColor.white.cgColor
        centerCircleLayer.frame = CGRect(x: self.bounds.midX - radius, y: self.bounds.midY - radius, width:2 * radius, height: 2 * radius)
        
        let centerCirclePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius))
        centerCircleLayer.path = centerCirclePath.cgPath
        
        
        self.addSublayer(outerCircleLayer)
        outerCircleLayer.strokeColor =  UIColor.white.withAlphaComponent(0.55).cgColor
        outerCircleLayer.frame = centerCircleLayer.frame
        outerCircleLayer.lineWidth = ringWidth
        
        self.addSublayer(innerCircleLayer)
        innerCircleLayer.strokeColor = UIColor.white.withAlphaComponent(0.62).cgColor
        innerCircleLayer.frame = centerCircleLayer.frame
        innerCircleLayer.lineWidth = ringWidth
        
        
        let ringPath = UIBezierPath(arcCenter: CGPoint(x:outerCircleLayer.bounds.midX , y:outerCircleLayer.bounds.midY), radius: radius - ringWidth/2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
//        ringPath.append(UIBezierPath(arcCenter: CGPoint(x:self.bounds.midX , y:self.bounds.midY), radius: radius, startAngle: -CGFloat.pi * 2, endAngle: 0, clockwise: false))
        
        ringPath.close()
        
        outerCircleLayer.path = ringPath.cgPath
        innerCircleLayer.path = ringPath.cgPath
        
        
        CATransaction.setDisableActions(true)
        outerCircleLayer.opacity = 0
        innerCircleLayer.opacity = 0
        CATransaction.setDisableActions(false)
        
        
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
 
        
        if let _ = anim.value(forKey: comeinKey){
            self.animateRings()
        }else if let _ = anim.value(forKey: goesoutKey){
            self.removeFromSuperlayer()
            
            
            centerCircleLayer.removeAllAnimations()
            innerCircleLayer.removeAllAnimations()
            outerCircleLayer.removeAllAnimations()
            
            centerCircleLayer.mask?.removeAllAnimations()
            centerCircleLayer.mask = nil
        }
    }
    
}
