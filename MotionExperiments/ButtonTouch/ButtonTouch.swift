//
//  ButtonTouch.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/29.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class ButtonTouch: AbstractAnimationView ,CAAnimationDelegate{

    var buttonFrame = CGRect.zero
    let buttonRadius : CGFloat = 22
    let effectOffset : CGFloat = 2.2
    let color = UIColor.colorWithAbsolute(red: 95, green: 177, blue: 65, alpha: 1)
    
    var animLayers = [CAShapeLayer]()
    
    var hits = 0
    
    let duration : TimeInterval = 0.36
    
    override func prepare() {
        addButton()
        prepareEffectLayer()
    }
    
    
    func prepareEffectLayer(){
        
        
        let fullCircleLayer = CAShapeLayer.cleanLayer()
        let uprightCircleLayer = CAShapeLayer.cleanLayer()
        let lowerrightCircleLayer = CAShapeLayer.cleanLayer()
        
        var circleRect = buttonFrame.insetBy(dx: -2 * effectOffset, dy: -2 * effectOffset)
        
        fullCircleLayer.frame = circleRect
        uprightCircleLayer.frame = circleRect
        lowerrightCircleLayer.frame = circleRect
        
        fullCircleLayer.opacity = 0
        uprightCircleLayer.opacity = 0
        lowerrightCircleLayer.opacity = 0
        animationLayer.addSublayer(fullCircleLayer)
        animationLayer.addSublayer(uprightCircleLayer)
        animationLayer.addSublayer(lowerrightCircleLayer)
        
        circleRect.origin = CGPoint.zero
        let ovalRect = circleRect.insetBy(dx: 0.3, dy: 1.2)
        let outer = UIBezierPath(ovalIn: circleRect)
        let inner = UIBezierPath(ovalIn: ovalRect)
        fullCircleLayer.fillRule = kCAFillRuleEvenOdd
        fullCircleLayer.fillColor = color.cgColor
        
        outer.append(inner)
        fullCircleLayer.path = outer.cgPath
        
        
        
        let uprightTransform = CGAffineTransform(translationX: circleRect.midX, y: circleRect.midY).rotated(by: CGFloat.pi  / 4).translatedBy(x: -circleRect.midX, y: -circleRect.midY)
        let lowerrightTransform = CGAffineTransform(translationX: circleRect.midX, y: circleRect.midY).rotated(by: CGFloat.pi  / 2).translatedBy(x: -circleRect.midX, y: -circleRect.midY)
        
        let partOuter = UIBezierPath(ovalIn: circleRect)
        let mask = UIBezierPath(ovalIn: CGRect(x: -0.6, y: 1.2, width: circleRect.width + 1.2, height: circleRect.height+1.2))
        partOuter.apply(uprightTransform)
        mask.apply(uprightTransform)
        
        
        let urMaskLayer = CAShapeLayer()
        urMaskLayer.path = (mask.copy() as! UIBezierPath).cgPath
        urMaskLayer.fillColor = self.backgroundColor?.cgColor
        urMaskLayer.frame = uprightCircleLayer.bounds
        urMaskLayer.backgroundColor = UIColor.clear.cgColor
        uprightCircleLayer.addSublayer(urMaskLayer)
        uprightCircleLayer.fillColor = color.cgColor
        uprightCircleLayer.path = (partOuter.copy() as! UIBezierPath).cgPath
        
        let lrMaskLayer = CAShapeLayer()
        lrMaskLayer.frame = lowerrightCircleLayer.bounds
        lrMaskLayer.fillColor = self.backgroundColor?.cgColor
        partOuter.apply(lowerrightTransform)
        mask.apply(lowerrightTransform)
        lrMaskLayer.path = mask.cgPath
        lrMaskLayer.backgroundColor = UIColor.clear.cgColor
        lowerrightCircleLayer.addSublayer(lrMaskLayer)
        lowerrightCircleLayer.fillColor = color.cgColor
        lowerrightCircleLayer.path = partOuter.cgPath
        lowerrightCircleLayer.backgroundColor = UIColor.clear.cgColor
        
        animLayers.append(fullCircleLayer)
        animLayers.append(uprightCircleLayer)
        animLayers.append(lowerrightCircleLayer)
    }
    
    func showTapAnimation(version:Int){
        if version >= animLayers.count {
            return
        }
        let layer = animLayers[version]
        
        layer.removeAllAnimations()
        
        let fadeIn = AnimationHelper.animation(keyPath: "opacity", from: 0, to: 1, duration: duration * 0.3 ,removeOnCompletion: false)
        let fadeOut = AnimationHelper.animation(keyPath: "opacity", from: 1, to: 0, duration: duration * 0.5)
        fadeOut.beginTime = CACurrentMediaTime() + duration * 0.5
        fadeOut.setValue(layer, forKey: "targetLayer")
        fadeOut.delegate = self
        
        let zoomOffset : CGFloat = 0.22
        
        let transform = CATransform3DMakeScale( 1+zoomOffset, 1+zoomOffset, 1)
        
        let grow = AnimationHelper.animation(keyPath: "transform", from: NSValue(caTransform3D:CATransform3DIdentity), to:  NSValue(caTransform3D:transform), duration: duration)
        
        layer.transform = transform
        layer.add(fadeIn, forKey: "buttontouch.layer\(version)fadein")
        layer.add(grow, forKey: "buttontouch.layer\(version)grow")
        layer.add(fadeOut, forKey: "buttontouch.layer\(version)fadeout")
    }
    
    func addButton(){
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: UIFontWeightLight)
        button.setTitleColor(color, for: .normal)
        button.setTitle("+", for: .normal)
        
        button.contentVerticalAlignment = .top
        button.backgroundColor = UIColor.clear
        
        
        button.layer.cornerRadius = buttonRadius
        button.layer.borderWidth = 1.5
        button.layer.borderColor = color.cgColor
        
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: buttonRadius * 2, height: buttonRadius * 2)
        
        button.setBackgroundImage(self.hightlightImage(color: UIColor.colorWithAbsolute(red: 223, green: 243, blue: 209, alpha: 1), size: button.bounds.size), for: .highlighted)
        
        button.center = CGPoint(x:self.bounds.midX,y:self.bounds.midY)
        
        buttonFrame = button.frame
        
        self.addSubview(button)
        
    }
    
    func hightlightImage(color:UIColor,size:CGSize) -> UIImage?{
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        let clip = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        clip.addClip()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func buttonTapped(){
        showTapAnimation(version: hits)
        hits += 1
        hits = hits % animLayers.count
    }
    
    
    
    //MARK: - Animation Delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.value(forKey: "targetLayer") as? CAShapeLayer{
            layer.removeAllAnimations()
        }
    }

}
