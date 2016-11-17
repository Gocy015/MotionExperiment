//
//  SyncArrowLayer.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/16.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SyncArrowLayer: CAShapeLayer ,CAAnimationDelegate{
    
    let arrowLayer = CAShapeLayer()
    
    var strokeAnimDuration : TimeInterval = 1.5
    
    var loadingAnim : CAAnimation!
    
    var arrowCompleteAnim : CAAnimationGroup!
    
    var completeAnim : CAAnimationGroup!
    
    var completeColor = UIColor.clear
    
    private var stop : Bool = false
    
    private let loadingKey = "sync.loading"
    private let completeKey = "sync.complete"
    private let arrowCompleteKey = "sync.arrowcomplete"
    
    override init() {
        super.init()
        self.backgroundColor = UIColor.clear.cgColor
        self.fillColor = UIColor.clear.cgColor
        self.addSublayer(arrowLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reset(){
        self.removeAllAnimations()
        
        CATransaction.setDisableActions(true)
        arrowLayer.transform = CATransform3DIdentity
        stop = false
        
        self.strokeStart = 0.15
        CATransaction.commit()
        
    }
    
    func draw(withAngle angle:CGFloat ,radius:CGFloat ,lineWidth:CGFloat,arrowSideLength length:CGFloat ,loadingColor lcolor:UIColor ,completeColor ccolor:UIColor) {
 
        arrowLayer.frame = CGRect(x: self.bounds.maxX - lineWidth/2 - length/2, y: self.bounds.midY, width: length, height: length)
        arrowLayer.fillColor = lcolor.cgColor
        
        arrowLayer.path = arrowPath(withLength: length).cgPath
        
        self.strokeStart = 0.15
        
        self.strokeColor = lcolor.cgColor
        self.lineWidth = lineWidth
        
        //arc
        let arcPath = UIBezierPath(arcCenter: CGPoint(x:self.bounds.midX,y:self.bounds.midY), radius: radius - (lineWidth/2), startAngle: -angle, endAngle: 0, clockwise: true)
        self.path = arcPath.cgPath
        
        
        let strokeFull = AnimationHelper.animation(keyPath: "strokeStart", from: self.strokeStart, to: 0, duration: strokeAnimDuration / 4)
        
        let colorChange = AnimationHelper.animation(keyPath: "strokeColor", from: self.strokeColor, to: ccolor.cgColor, duration: strokeAnimDuration / 4)
        
        completeAnim = CAAnimationGroup()
        completeAnim.animations = [strokeFull ,colorChange]
        completeAnim.duration = strokeAnimDuration / 4
        completeColor = ccolor
        
        completeAnim.isRemovedOnCompletion = false
        completeAnim.fillMode = kCAFillModeForwards
        
        
        
        let arrowColorChange = AnimationHelper.animation(keyPath: "fillColor", from: arrowLayer.fillColor, to: ccolor.cgColor, duration: strokeAnimDuration / 3 ,removeOnCompletion: false)
        let hideTriangle = AnimationHelper.animation(keyPath: "transform.scale", from: 1, to: 0, duration: strokeAnimDuration/3)
        hideTriangle.beginTime = strokeAnimDuration/4
        arrowCompleteAnim = CAAnimationGroup()
        arrowCompleteAnim.animations = [arrowColorChange,hideTriangle]
        arrowCompleteAnim.duration = hideTriangle.beginTime + hideTriangle.duration
        
        arrowCompleteAnim.isRemovedOnCompletion = false
        arrowCompleteAnim.fillMode = kCAFillModeForwards
        
        arrowCompleteAnim.setValue(true, forKey: arrowCompleteKey)
        arrowCompleteAnim.delegate = self
    }
    
    
    func animateLoading(){
        let strokeStartAnim = AnimationHelper.keyframeAnimation(keyPath: "strokeStart", values: [0.15,0.65,0.45,0.15], keyTimes: [0,0.4,0.65,1], duration: strokeAnimDuration)
//        strokeStartAnim.repeatCount = 999
        strokeStartAnim.setValue(true, forKey: loadingKey)
        strokeStartAnim.delegate = self
        
        self.add(strokeStartAnim, forKey: loadingKey)
        
        loadingAnim = strokeStartAnim
    }
    
    func complete(){
        
        stop = true
    }
    
    func arrowPath(withLength len:CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x:len,y:0))
        path.addLine(to: CGPoint(x: len/2, y: len*3/5))
        path.close()
         
        
        return path
        
    }
    
    
    //MARK:- Animation Delegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let _ = anim.value(forKey: loadingKey) {
            if !stop{
                self.removeAnimation(forKey: loadingKey)
                self.add(loadingAnim, forKey: loadingKey)
            }else{
//                CATransaction.setDisableActions(true)
//                self.strokeColor = completeColor.cgColor
//                self.strokeStart = 0
//                
//                arrowLayer.fillColor = completeColor.cgColor
//                CATransaction.commit()
                self.add(completeAnim, forKey: completeKey)
                
                arrowLayer.add(arrowCompleteAnim, forKey: arrowCompleteKey)
            }
        }else if let _ = anim.value(forKey: arrowCompleteKey){
            CATransaction.setDisableActions(true)
            arrowLayer.transform = CATransform3DMakeScale(0, 0, 0)
            arrowLayer.removeAllAnimations()
            CATransaction.commit()
            
        }
    }
    
}
