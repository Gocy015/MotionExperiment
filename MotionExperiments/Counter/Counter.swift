//
//  Counter.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/18.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit
import CoreText

class Counter: AbstractAnimationView {

    let counterFont = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 222)!
    
    // not able to achieve the animation effect
    
    override func prepare() {
        
        
        let path = self.getPathFromCharacter(char: "1")
        NSLog("\(path)")
        
        
        let shapeLayer = CAShapeLayer.cleanLayer()
        shapeLayer.fillColor = UIColor.black.cgColor

        shapeLayer.path = path.cgPath
        
        
        let rect = path.cgPath.boundingBox
        
        shapeLayer.frame = CGRect(x: self.bounds.midX - rect.width / 2, y: self.bounds.midY - rect.height / 2, width: rect.width , height: rect.height )
        
        self.layer.addSublayer(shapeLayer)
    }
    
    
    //MARK : - Helpers

    func getPathFromCharacter(char:Character) -> UIBezierPath {
        
        var path : UIBezierPath = UIBezierPath()
        
        
        let fontCT = CTFontCreateWithName(counterFont.fontName as CFString, counterFont.pointSize, nil)
        
        var unichars = [UniChar]("\(char)".utf16)
        
        var glyphs = [CGGlyph](repeating:0 ,count : unichars.count)
        
        let gotGlyphs = CTFontGetGlyphsForCharacters(fontCT, &unichars, &glyphs, unichars.count)
        
        
        //get到的字形是颠倒的
        
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        
        if gotGlyphs {
            if let cgPath = CTFontCreatePathForGlyph(fontCT, glyphs[0], &transform){
                
                path = UIBezierPath(cgPath: cgPath)
            }
        }
        
        path.apply(CGAffineTransform(translationX: 0, y: path.bounds.height))
        
        return path
        
    }
    
}
