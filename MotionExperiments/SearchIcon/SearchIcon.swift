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
    
    let circleLayer = CAShapeLayer()
    let innerLayer = CAShapeLayer()
    
    var inSearch = false
    
    let radius : CGFloat = 27
    let length : CGFloat = 32
    let closeWidth : CGFloat = 6
    
    let searchPadding : CGFloat = 6.6;
    
    let duration : TimeInterval = 0.35

    override func prepare() {
        
        let center = CGPoint(x: bounds.size.width / 2  , y: bounds.size.height / 2)
        let rect = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        
        
        //circle
        let circlePath = UIBezierPath(ovalIn: rect)
        circleLayer.path = circlePath.cgPath
        
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
        
        
        
        //search
        searchPath = UIBezierPath(ovalIn: rect.insetBy(dx: searchPadding, dy: searchPadding))
        
        innerLayer.path = closePath.cgPath
        inSearch = false
        
        self.timeUntilStop = -1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        self.addGestureRecognizer(tap)
        
        circleLayer.fillColor = UIColor.black.cgColor
        circleLayer.frame = animationLayer.bounds
        self.animationLayer.addSublayer(circleLayer)
        
        innerLayer.strokeColor = UIColor.white.cgColor
        innerLayer.fillColor = UIColor.white.cgColor
        innerLayer.lineWidth = closeWidth
        innerLayer.frame = animationLayer.bounds
        self.animationLayer.addSublayer(innerLayer)
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
            
            let searchShrink = AnimationHelper.animation(keyPath: "transform", from:NSValue(caTransform3D:CATransform3DIdentity), to: NSValue(caTransform3D:shrinkAtCenter), duration: self.duration*2/3 ,removeOnCompletion: true)
            searchShrink.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            
            self.innerLayer.add(searchShrink, forKey: "searchicon.searchshrink")

            Timer.scheduledTimer(withTimeInterval: duration*2/3, repeats: false, block: { (_) in
 
                self.innerLayer.path = self.closePath.cgPath
                
                let shrinkClose = AnimationHelper.animation(keyPath: "lineWidth", from: 0, to: self.closeWidth, duration: self.duration/3)
                shrinkClose.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
                self.innerLayer.add(shrinkClose, forKey: "searchicon.closegrow")

            })
            
        }else{
            
            let shrinkClose = AnimationHelper.animation(keyPath: "lineWidth", from: closeWidth, to: 0, duration: duration/3)
            shrinkClose.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)
            innerLayer.add(shrinkClose, forKey: "searchicon.closeshrink")
            
            
            Timer.scheduledTimer(withTimeInterval: duration/3, repeats: false, block: { (_) in
                
                self.innerLayer.path = self.searchPath.cgPath
                
                let searchGrow = AnimationHelper.animation(keyPath: "transform", from: NSValue(caTransform3D:shrinkAtCenter), to: NSValue(caTransform3D:CATransform3DIdentity), duration: self.duration*2/3)
                searchGrow.timingFunction = CAMediaTimingFunction(controlPoints: 0, 0, 0, 1)

                self.innerLayer.add(searchGrow, forKey: "searchicon.searchgrow")
            })
            
            
        }
        
        inSearch = !inSearch
    }
}
