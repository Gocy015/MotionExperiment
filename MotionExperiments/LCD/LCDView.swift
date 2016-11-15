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
    
    
    let lcdLayer = SingleLCDLayer()
    var counter = 1
    
    
    override func prepare() {
        
        self.backgroundColor = UIColor.black
        self.layer.addSublayer(lcdLayer)
        
        lcdLayer.backgroundLineWidth = 8
        lcdLayer.foregroundLineWidth = 15
        lcdLayer.frame = CGRect(x: self.bounds.size.width/2 - 50, y: self.bounds.size.height/2 - 90 , width: 100, height: 180)
        lcdLayer.drawBackground()
        
        lcdLayer.draw(number: 0)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            _ in
            self.lcdLayer.draw(number: self.counter)
            self.counter = (self.counter+1) % 10
            
        }
        
    }

}
