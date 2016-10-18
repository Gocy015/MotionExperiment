//
//  SearchIcon.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/17.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SearchIcon: AbstractAnimationView {
    
    private var closePath : UIBezierPath!
    private var searchPath : UIBezierPath!
    private var barPath : UIBezierPath!
    
    let label = UILabel.descriptionLabel(withDescription: "Tap the view to switch search state")
    
    let circleLayer = CAShapeLayer()
    let innerLayer = CAShapeLayer()
    let barLayer = CAShapeLayer()
    
    var inSearch = false
    
    let radius : CGFloat = 27
    let length : CGFloat = 32
    let closeWidth : CGFloat = 6
    let barLength : CGFloat = 22
    let barWidth : CGFloat = 8
    
    let searchPadding : CGFloat = 6.6;
    
    let duration : TimeInterval = 0.5
     
    override func prepare() {
        
        if label.superview == nil{
            self.addSubview(label)
            label.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - label.bounds.size.height)
            label.autoresizingMask = [.flexibleWidth,.flexibleBottomMargin]
            
        }
        
        let center = CGPoint(x: bounds.size.width / 2  , y: bounds.size.height / 2)
        let rect = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        
        
        //circle
        let circlePath = UIBezierPath(ovalIn: rect)
        circleLayer.path = circlePath.cgPath
        
        circleLayer.fillColor = UIColor.black.cgColor
        circleLayer.frame = animationLayer.bounds
        self.animationLayer.addSublayer(circleLayer)
        
        //close 
        let offset = CGFloat(cos(M_PI_4)) * length/2
        let topLeft = CGPoint(x: center.x - offset, y: center.y - offset),
            topRight = CGPoint(x: center.x + offset, y: center.y - offset),
            bottomLeft = CGPoint(x: center.x - offset, y: center.y + offset),
            bottomRight = CGPoint(x: center.x + offset, y: center.y + offset)
        
        closePath = UIBezierPath()
        closePath.move(to: topLeft)
        closePath.addLine(to: bottomRight)
        closePath.move(to: topRight)
        closePath.addLine(to: bottomLeft)
        
        innerLayer.path = closePath.cgPath
        innerLayer.strokeColor = UIColor.white.cgColor
        innerLayer.fillColor = UIColor.white.cgColor
        innerLayer.lineWidth = closeWidth
        innerLayer.frame = animationLayer.bounds
        self.animationLayer.addSublayer(innerLayer)
        
        //search
        searchPath = UIBezierPath(ovalIn: rect.insetBy(dx: searchPadding, dy: searchPadding))
        inSearch = false
        
        //bar 
        barPath = UIBezierPath()
        let offsetx : CGFloat = 2 //懒得算了
        let pivit = CGPoint(x: rect.origin.x + rect.size.width - offsetx, y: center.y)
        barPath.move(to: pivit)
        barPath.addLine(to: CGPoint(x:pivit.x + barLength , y:pivit.y))
        
        barLayer.strokeColor = UIColor.black.cgColor
        barLayer.path = barPath.cgPath
        barLayer.lineWidth = 0
        
        self.animationLayer.anchorPoint = CGPoint(x: 0.5, y: 0.48)
        self.animationLayer.addSublayer(barLayer)
        
        self.timeUntilStop = -1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        self.addGestureRecognizer(tap)
        
    }
    
    override func start() {
        
    }
    
    override func stop() {
        
    }
    
    
    func didTap(tap:UITapGestureRecognizer) {
        self.change()
    }
    
    func change(){
        
        
        var shrinkAtCenter = CATransform3DMakeScale(0.01, 0.01, 1)
        shrinkAtCenter = CATransform3DTranslate(shrinkAtCenter,innerLayer.bounds.size.width/2, innerLayer.bounds.size.height/2, 0)
        
        
        
        if inSearch {
            
            let rotate = AnimationHelper.animation(keyPath: "transform.rotation", from: M_PI_4, to: 0, duration: duration)
            rotate.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            self.animationLayer.add(rotate, forKey: "searchicon.rotateright")
            
            let barShrink = AnimationHelper.animation(keyPath: "lineWidth", from: barWidth, to: 0, duration: duration)
            barShrink.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            self.barLayer.add(barShrink, forKey: "serachicon.barshrink")
            
            let searchShrink = AnimationHelper.animation(keyPath: "transform", from:NSValue(caTransform3D:CATransform3DIdentity), to: NSValue(caTransform3D:shrinkAtCenter), duration: self.duration*2/3 ,removeOnCompletion: true)
            searchShrink.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            
            self.innerLayer.add(searchShrink, forKey: "searchicon.searchshrink")

            Timer.scheduledTimer(withTimeInterval: duration*2/3, repeats: false, block: { (_) in
 
                self.innerLayer.path = self.closePath.cgPath
                
                let shrinkGrow = AnimationHelper.animation(keyPath: "lineWidth", from: 0, to: self.closeWidth, duration: self.duration/3)
                shrinkGrow.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
                self.innerLayer.add(shrinkGrow, forKey: "searchicon.closegrow")

            })
            
        }else{
            
            let rotate = AnimationHelper.animation(keyPath: "transform.rotation", from: 0, to: M_PI_4, duration: duration)
            rotate.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            self.animationLayer.add(rotate, forKey: "searchicon.rotateleft")
            
            let shrinkClose = AnimationHelper.animation(keyPath: "lineWidth", from: closeWidth, to: 0, duration: duration/3)
            shrinkClose.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            innerLayer.add(shrinkClose, forKey: "searchicon.closeshrink")
            
            
            let barShrink = AnimationHelper.animation(keyPath: "lineWidth", from: 0, to: barWidth, duration: duration)
            barShrink.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            self.barLayer.add(barShrink, forKey: "serachicon.bargrow")
            
            
            Timer.scheduledTimer(withTimeInterval: duration/3, repeats: false, block: { (_) in
                
                self.innerLayer.path = self.searchPath.cgPath
                
                let searchGrow = AnimationHelper.animation(keyPath: "transform", from: NSValue(caTransform3D:shrinkAtCenter), to: NSValue(caTransform3D:CATransform3DIdentity), duration: self.duration*2/3)
                searchGrow.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0.6, 0.3 , 1)

                self.innerLayer.add(searchGrow, forKey: "searchicon.searchgrow")
            })
            
            
        }
        
        inSearch = !inSearch
    }
}
