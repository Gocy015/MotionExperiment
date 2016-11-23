//
//  SyncSuccessIcon.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/16.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SyncSuccessIcon: AbstractAnimationView ,CAAnimationDelegate{

    let upperSync = SyncArrowLayer()
    let lowerSync = SyncArrowLayer()
    
    let successIcon = SuccessLayer()
    
    let containerLayer = CALayer()
    
    let duration : TimeInterval = 1.2
    
    var spinAnimation : CAAnimation!
    
    let color = UIColor.colorWithAbsolute(red: 32, green: 124, blue: 255, alpha: 1)
    let completeColor = UIColor.colorWithAbsolute(red: 42, green: 172, blue: 0, alpha: 1)
    let syncSize = CGSize(width: 50, height: 50)
    
    let spinAnimationKey = "sync.spin"
    let spinCompleteAnimationKey = "sync.spincomplete"
    
    
    private var shouldStop = false
    
    override func prepare() {
         
        self.layer.addSublayer(containerLayer)
        containerLayer.addSublayer(upperSync)
        containerLayer.addSublayer(lowerSync)
        containerLayer.addSublayer(successIcon)
        
        timeUntilStop = 2
        
        containerLayer.frame = CGRect(x: self.layer.bounds.midX - syncSize.width/2, y: self.layer.bounds.midY - syncSize.height/2, width: syncSize.width, height: syncSize.height)
        containerLayer.backgroundColor = UIColor.clear.cgColor

        
        upperSync.frame = CGRect(x: 0, y: 0, width: syncSize.width, height: syncSize.height)
        
        upperSync.draw(withAngle: CGFloat.pi, radius: syncSize.width/2, lineWidth: 5, arrowSideLength: 13,loadingColor:color ,completeColor:completeColor)
        
        upperSync.strokeAnimDuration = duration
        
        lowerSync.frame = CGRect(x: 0, y: 0, width: syncSize.width, height: syncSize.height)
        
        lowerSync.draw(withAngle: CGFloat.pi , radius: syncSize.width/2, lineWidth: 5, arrowSideLength: 13,loadingColor:color ,completeColor:completeColor)
        
        lowerSync.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        
        lowerSync.strokeAnimDuration = duration
        
        successIcon.frame = CGRect(x: 0, y: 0, width: syncSize.width, height: syncSize.height)
        successIcon.draw(withLineWidth: 4, backgroundColor: completeColor, completeColor: .white)
        
        
    }
    
    override func start() {
        
        containerLayer.transform = CATransform3DIdentity
        containerLayer.removeAllAnimations() 
        upperSync.reset()
        lowerSync.reset()
        successIcon.reset()
        shouldStop = false
        
        let spinAnim = AnimationHelper.animation(keyPath: "transform.rotation", from: 0, to: CGFloat.pi * 2, duration: duration)
 
        spinAnim.delegate = self
        spinAnim.setValue(true, forKey: spinAnimationKey)
        
        containerLayer.add(spinAnim, forKey: spinAnimationKey)
        
        upperSync.animateLoading()
        
        lowerSync.animateLoading()
        
        
        spinAnimation = spinAnim
    }
    
    override func stop() {
        shouldStop = true
        upperSync.complete()
        lowerSync.complete()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let _ = anim.value(forKey: spinAnimationKey), !shouldStop {
            containerLayer.removeAnimation(forKey: spinAnimationKey)
            containerLayer.add(spinAnimation, forKey: spinAnimationKey)
        }else if let _ = anim.value(forKey: spinCompleteAnimationKey){
            self.delegate?.animationDidFinished()
        }else{
            spinAnimation = AnimationHelper.animation(keyPath: "transform.rotation", from: -CGFloat.pi, to: 0 , duration: duration * 0.9)
            spinAnimation.delegate = self 
            spinAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.54, 1.52, 0.57, 1.03)
            spinAnimation.setValue(true, forKey: spinCompleteAnimationKey)
            containerLayer.add(spinAnimation, forKey: spinCompleteAnimationKey)
            successIcon.animateComplete(delay:duration / 6 ,withDuration: duration/4)
        }
    }
}
