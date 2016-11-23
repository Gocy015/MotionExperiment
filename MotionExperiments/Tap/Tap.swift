//
//  Tap.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/22.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class Tap: AbstractAnimationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let radius : CGFloat = 22
    
    
    let label = UILabel.descriptionLabel(withDescription: "Tap the view to show animation")
    
    override func prepare() {
        
        self.installLabel()
        
        self.backgroundColor = UIColor.colorWithAbsolute(red: 26, green: 28, blue: 31, alpha: 1)
        
        
    }
 
    
    func installLabel(){
        
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        
        if label.superview == nil{
            self.addSubview(label)
            label.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - label.bounds.size.height)
            label.autoresizingMask = [.flexibleWidth,.flexibleBottomMargin]
            
        }
    }
    
     
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let point = touch.location(in: self)
            
            let layer = TapAnimationLayer(frame: CGRect(x: point.x - radius, y: point.y - radius, width: 2 * radius, height: 2 * radius))
            
            self.layer.addSublayer(layer)
            
            
            layer.animate()
        }
    }
    
    
}
