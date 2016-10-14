//
//  AnimationHelper.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/13.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class AnimationHelper: NSObject {
    
    static func animation(keyPath:String ,from:Any? ,to:Any? ,duration :TimeInterval,removeOnCompletion:Bool = false) -> CABasicAnimation{
        let anim = CABasicAnimation(keyPath:keyPath)
        anim.duration = duration
        anim.fromValue = from
        anim.toValue = to
        
        if !removeOnCompletion{
            anim.isRemovedOnCompletion = false
            anim.fillMode = kCAFillModeForwards
        }
        
        return anim
    }
    
    static func bezierPathAnimation(from:UIBezierPath ,to:UIBezierPath ,duration:TimeInterval) -> CABasicAnimation{
        
        return self.animation(keyPath: "path", from: from.cgPath, to: to.cgPath, duration: duration ,removeOnCompletion: false)
    }
    
    static func generateAnimationSequence(_ animations:CABasicAnimation ...) -> [CABasicAnimation]?{
        var begin : CFTimeInterval = 0
        for anim in animations {
            anim.beginTime = begin
            begin += anim.duration
        }
        
        return animations
    }
}
