//
//  PlayPauseIcon.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/21.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class PlayPauseIcon: AbstractAnimationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    let pauseLayer = CAShapeLayer.cleanLayer()
    let playLayer = CAShapeLayer.cleanLayer()
    
    var iconSize = CGSize(width: 46, height: 50)
    
    private var isPaused = true
    
    let duration : TimeInterval = 0.42
    
    let singlePausePortion : CGFloat = 0.36
    
    
    let label = UILabel.descriptionLabel(withDescription: "Tap the view to switch play state")
    
    
    override func prepare() {

        self.initGesture()
        
        self.installLabel()
        
        self.backgroundColor = .white
        
        CATransaction.setDisableActions(true)
        self.layer.addSublayer(playLayer)
        playLayer.opacity = 0
//        playLayer.backgroundColor = UIColor.orange.cgColor
        self.layer.addSublayer(pauseLayer)
        
        playLayer.fillColor = UIColor.colorWithAbsolute(red: 122, green: 122, blue: 122, alpha: 122).cgColor
        pauseLayer.fillColor = playLayer.fillColor
        
        
        playLayer.frame = CGRect(x: (self.bounds.width - iconSize.width) / 2, y: (self.bounds.height - iconSize.height) / 2, width: iconSize.width, height: iconSize.height)
        pauseLayer.frame = playLayer.frame
        
        //play
        let play = UIBezierPath()
        play.move(to: .zero)
        play.addLine(to: CGPoint(x: 0, y: iconSize.height))
        play.addLine(to: CGPoint(x: iconSize.width, y: iconSize.height/2))
        play.close()
        
        playLayer.path = play.cgPath
        
        
        
        let pause = UIBezierPath(roundedRect: CGRect(x:0,y:0,width:iconSize.width * singlePausePortion,height:iconSize.height), cornerRadius: 2)
        let rightpause = UIBezierPath(roundedRect: CGRect(x:iconSize.width * (1-singlePausePortion),y:0,width:iconSize.width * singlePausePortion,height:iconSize.height), cornerRadius: 2)
        
        pause.append(rightpause)
        
        pauseLayer.path = pause.cgPath
        
        CATransaction.setDisableActions(false)
        
        
    }
    
    
    
    func initGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.addGestureRecognizer(tap)
        
    }
    
    func installLabel(){
        
        if label.superview == nil{
            self.addSubview(label)
            label.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - label.bounds.size.height)
            label.autoresizingMask = [.flexibleWidth,.flexibleBottomMargin]
            
        }
    }
    
    func viewTapped(){
        isPaused = !isPaused
       
        isPaused ? showPause() : showPlay()
    }
    
    func showPlay(){
        //pause shrink , move away
        
        var playFromTransform = CATransform3DMakeTranslation(iconSize.width, 0, 0)
        playFromTransform = CATransform3DScale(playFromTransform, 1, 0, 1)
        
        let pauseToTransform = CATransform3DMakeTranslation(-iconSize.width, 0, 0)
        
        AnimationHelper.universalTimingFunction = CAMediaTimingFunction(controlPoints: 0.12, 0.53, 0.23, 0.98)
        
        playLayer.opacity = 1
        
        let playTransAnim = AnimationHelper.animation(keyPath: "transform", from: NSValue(caTransform3D: playFromTransform), to: NSValue(caTransform3D: CATransform3DIdentity), duration: duration)
        let playOpacityAnim = AnimationHelper.animation(keyPath: "opacity", from: 0, to: 1, duration: duration)
        
        playLayer.add(playTransAnim, forKey: nil)
        playLayer.add(playOpacityAnim, forKey: nil)
        
        
        pauseLayer.opacity = 0
        
        
        let pause = UIBezierPath(roundedRect: CGRect(x:0,y:0,width:0,height:iconSize.height), cornerRadius: 2)
        let rightpause = UIBezierPath(roundedRect: CGRect(x:iconSize.width * (1-singlePausePortion),y:0,width:0,height:iconSize.height), cornerRadius: 2)
        
        pause.append(rightpause)
        let pausePathAnim = AnimationHelper.bezierPathAnimation(from: UIBezierPath(cgPath:pauseLayer.path!), to: pause, duration: duration)
        let pauseTransAnim = AnimationHelper.animation(keyPath: "transform", from: NSValue(caTransform3D:CATransform3DIdentity), to: NSValue(caTransform3D:pauseToTransform), duration: duration)
        let pauseOpacityAnim = AnimationHelper.animation(keyPath: "opacity", from: 1, to: 0, duration: duration)
        
        AnimationHelper.resetTimingFunction()
        
        pauseLayer.path = pause.cgPath
        
        pauseLayer.add(pauseTransAnim, forKey: nil)
        pauseLayer.add(pausePathAnim, forKey: nil)
        pauseLayer.add(pauseOpacityAnim, forKey: nil)
        
        
        
    }
    
    func showPause(){
        
        
        var playToTransform = CATransform3DMakeTranslation(iconSize.width, 0, 0)
        playToTransform = CATransform3DScale(playToTransform, 1, 0, 1)
        
        
        let pauseFromTransform = CATransform3DMakeTranslation(-iconSize.width, 0, 0)
        
        AnimationHelper.universalTimingFunction = CAMediaTimingFunction(controlPoints: 0.12, 0.53, 0.23, 0.98)
        
        
        playLayer.opacity = 0
        
        let playTransAnim = AnimationHelper.animation(keyPath: "transform", from: NSValue(caTransform3D: CATransform3DIdentity), to: NSValue(caTransform3D: playToTransform), duration: duration)
        let playOpacityAnim = AnimationHelper.animation(keyPath: "opacity", from: 1, to: 0, duration: duration)
        
        playLayer.add(playTransAnim, forKey: nil)
        playLayer.add(playOpacityAnim, forKey: nil)
        
        
        pauseLayer.opacity = 1
        
        
        
        let pause = UIBezierPath(roundedRect: CGRect(x:0,y:0,width:iconSize.width * singlePausePortion,height:iconSize.height), cornerRadius: 2)
        let rightpause = UIBezierPath(roundedRect: CGRect(x:iconSize.width * (1-singlePausePortion),y:0,width:iconSize.width * singlePausePortion,height:iconSize.height), cornerRadius: 2)
        
        pause.append(rightpause)
        let pausePathAnim = AnimationHelper.bezierPathAnimation(from: UIBezierPath(cgPath:pauseLayer.path!), to: pause, duration: duration)
        let pauseTransAnim = AnimationHelper.animation(keyPath: "transform", from: NSValue(caTransform3D:pauseFromTransform), to: NSValue(caTransform3D:CATransform3DIdentity), duration: duration)
        let pauseOpacityAnim = AnimationHelper.animation(keyPath: "opacity", from: 0, to: 1, duration: duration)
        
        AnimationHelper.resetTimingFunction()
        
        pauseLayer.path = pause.cgPath
        
        pauseLayer.add(pauseTransAnim, forKey: nil)
        pauseLayer.add(pausePathAnim, forKey: nil)
        pauseLayer.add(pauseOpacityAnim, forKey: nil)
    }

}
