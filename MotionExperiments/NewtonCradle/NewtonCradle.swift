//
//  NewtonCradle.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/18.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class NewtonCradle: AbstractAnimationView ,CAAnimationDelegate{

    
    var leftBallLayer : CAShapeLayer!
    var rightBallLayer : CAShapeLayer!
    
    let radius : CGFloat = 7.3
    let duration : TimeInterval = 1
    
    var hits : Int8 = 0
    
    override func prepare() {
        let center = CGPoint(x:self.bounds.size.width / 2 ,y:self.bounds.size.height / 2)
        
        leftBallLayer = ballLayer()
        leftBallLayer.path = ballPath(center: CGPoint(x: center.x - 2*radius, y: center.y)).cgPath
        
        rightBallLayer = ballLayer()
        rightBallLayer.path = ballPath(center: CGPoint(x: center.x + 2*radius, y: center.y)).cgPath
        
        self.animationLayer.fillColor = UIColor.black.cgColor
        self.animationLayer.path = ballPath(center: center).cgPath
        
    }
    
    override func start() {
        super.start()
        startInfiniteBounce(leftBallLayer)
        rotate(-1)
    }
    
    //MARK: - Animations
    
    func startInfiniteBounce(_ layer:CALayer){
        let transX = layer == leftBallLayer ? -3.2 * radius : 3.2 * radius
        
        var out = CATransform3DMakeScale(0.7, 0.7, 1)
        out = CATransform3DTranslate(out,transX, 0, 0)
        let bounceOutTimingFunc = CAMediaTimingFunction(controlPoints: 0, 0.3, 0.6, 1)
        let bounceInTimingFunc = CAMediaTimingFunction(controlPoints: 0.3, 0, 1, 0.6)
        
        let bounceOut = AnimationHelper.animation(keyPath:"transform", from: NSValue(caTransform3D:CATransform3DIdentity), to: NSValue(caTransform3D:out), duration: duration / 2)
        bounceOut.timingFunction = bounceOutTimingFunc
        
        let bounceIn = AnimationHelper.animation(keyPath:"transform", from: NSValue(caTransform3D:out), to: NSValue(caTransform3D:CATransform3DIdentity), duration: duration / 2)
        bounceIn.timingFunction = bounceInTimingFunc
        
        let group = AnimationHelper.generateAnimationGroup(bounceOut,bounceIn ,removeOnCompletion:true)
        group.delegate = self
        group.setValue(layer, forKey: "targetLayer")
        
        layer.add(group, forKey: "newtoncradle.bounce")
        
    }
    
    func rotate(_ multiplier : Double){
        let duration = 3 * self.duration
        let from = self.animationLayer.value(forKey: "transform.rotation")
        let rotateAnim = AnimationHelper.animation(keyPath: "transform.rotation", from: from , to: multiplier * M_PI * 2, duration: duration ,removeOnCompletion: true)
        rotateAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0,0.65,0.55,1)
        self.animationLayer.add(rotateAnim, forKey: "newtoncradle.rotate")
    }
    
    //MARK: - Drawing
    func ballLayer() -> CAShapeLayer{
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.frame = self.animationLayer.bounds
        self.animationLayer.addSublayer(layer)
        
        layer.fillColor = UIColor.black.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        
        return layer
    }
    
    func ballPath(center:CGPoint) -> UIBezierPath{
        let rect = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        let path = UIBezierPath(ovalIn: rect)
        
        return path
    }
    
    
    //MARK: - CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag{
            if let layer = anim.value(forKey: "targetLayer") as? CAShapeLayer{
                startInfiniteBounce(layer == leftBallLayer ? rightBallLayer : leftBallLayer)
                hits += 1
                if hits == 3{
                    hits = 0
                    rotate(layer == leftBallLayer ? 1 : -1)
                }
            }
        }
    }
}
