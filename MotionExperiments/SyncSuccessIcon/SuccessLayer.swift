//
//  SuccessLayer.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/17.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SuccessLayer: CAShapeLayer {
    
    
    private let maskLayer = CAShapeLayer()
    
    func reset(){
        maskLayer.removeAllAnimations()
    }
    
    func draw(withLineWidth lineWidth:CGFloat,backgroundColor bgColor:UIColor ,completeColor :UIColor){
        
        self.backgroundColor = UIColor.clear.cgColor
        
        
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.path = nil
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.frame = self.bounds
        
        self.mask = maskLayer
        
        let center = CGPoint(x:self.bounds.midX ,y:self.bounds.midY - lineWidth/2)
        
        let bottom = CGPoint(x: center.x - lineWidth/2, y: center.y + lineWidth * 2.6)
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        UIBezierPath(ovalIn: self.bounds).addClip()
        
        bgColor.setFill()
        
        ctx.fill(self.bounds)
        
        let check = UIBezierPath()
        check.move(to: CGPoint(x: center.x / 2, y: center.y))
        check.addLine(to: bottom)
        check.addLine(to: CGPoint(x: center.x * 1.5, y: center.y - lineWidth * 1.5))
    
        
        completeColor.setStroke()
        check.lineWidth = lineWidth
        check.stroke()
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        self.contents = img?.cgImage
        
        UIGraphicsEndImageContext()
        
    }
    
    func animateComplete(delay:TimeInterval ,withDuration dur:TimeInterval){
        
        maskLayer.removeAllAnimations()
        
        let ovalPath = UIBezierPath(ovalIn: self.bounds)
        
        let rectPath  = UIBezierPath(rect: self.bounds)
        
        rectPath.append(ovalPath)
        
        let finalPath = UIBezierPath(rect: self.bounds)
        
        let finalOval = UIBezierPath(ovalIn: self.bounds.insetBy(dx: self.bounds.width/2, dy: self.bounds.height/2))
        
        finalPath.append(finalOval)
        
        let testAnim = AnimationHelper.bezierPathAnimation(from: rectPath, to: finalPath, duration: dur ,removeOnCompletion:false)
        testAnim.beginTime = CACurrentMediaTime() + delay
//        maskLayer.path = finalPath.cgPath
        maskLayer.add(testAnim, forKey: nil)
    }
    
}
