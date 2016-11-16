//
//  LCDView.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/15.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class LCDView: AbstractAnimationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    let tensLayer = SingleLCDLayer()
    let unitsLayer = SingleLCDLayer()
    
    let lcdSize = CGSize(width: 70, height: 130)
    
    override func prepare() {
        
        self.backgroundColor = UIColor.black
        self.layer.addSublayer(tensLayer)
        self.layer.addSublayer(unitsLayer)
        
        tensLayer.backgroundLineWidth = 5
        tensLayer.foregroundLineWidth = 11
        
        unitsLayer.backgroundLineWidth = 5
        unitsLayer.foregroundLineWidth = 11
        
        let widthBetween = lcdSize.width / 3
        
        
        
        tensLayer.frame = CGRect(x: (self.bounds.size.width - 2 * lcdSize.width - widthBetween)/2 , y: self.bounds.size.height/2 - lcdSize.height/2 , width: lcdSize.width, height: lcdSize.height)
        tensLayer.drawBackground()
        
        unitsLayer.frame = CGRect(x: tensLayer.frame.maxX + widthBetween , y: self.bounds.size.height/2 - lcdSize.height/2 , width: lcdSize.width, height: lcdSize.height)
        unitsLayer.drawBackground()
        
        tensLayer.draw(number: 0)
        unitsLayer.draw(number: 0)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            _ in
            
            let random = Int(arc4random_uniform(100))
            self.tensLayer.draw(number: random / 10)
            self.unitsLayer.draw(number: random % 10)
            
        }
        
    }

}
