//
//  SingleLCDLayer.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/15.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SingleLCDLayer: CALayer {
    
    var backgroundLineWidth : CGFloat = 2
    var foregroundLineWidth : CGFloat = 6
    
    private let bgLayer = CAShapeLayer.cleanLayer()
    private let fgLayer = CAShapeLayer.cleanLayer()
    
    private var fgLayerWrappers = [LCDLayerWrapper]()
    
    private let linePaddingRatio : CGFloat = 0.1
    private var bgPath : UIBezierPath!
    private var currentLineWidth : CGFloat = 0
    private var currentNumber : Int = -1
    
    var animDuration : TimeInterval = 0.15
    
    private var linePadding : CGFloat{
        get{
            return linePaddingRatio * min(self.bounds.width, self.bounds.height)
        }
    }
    
    
    override init() {
        super.init()
        self.initSublayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawBackground(){
        bgLayer.frame = self.bounds
        
        if(bgLayer.superlayer == nil){
            self.addSublayer(bgLayer)
        }
        
        currentLineWidth = backgroundLineWidth
        
        let bgPath = self.ceil()
        bgPath.append(self.mid())
        bgPath.append(self.floor())
        bgPath.append(self.upperLeft())
        bgPath.append(self.upperRight())
        bgPath.append(self.lowerLeft())
        bgPath.append(self.lowerRight())
         
        self.bgPath = bgPath
        
        bgLayer.path = bgPath.cgPath
        
        createForegroundLayers()
        
    }
    
    
    
    func initSublayers(){
        
        bgLayer.backgroundColor = UIColor.clear.cgColor
//        fgLayer.backgroundColor = UIColor.clear.cgColor
        
        bgLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
//        fgLayer.fillColor = UIColor.white.cgColor
        
        self.addSublayer(bgLayer)
//        self.addSublayer(fgLayer)
        
    }
    
    func createForegroundLayers(){
        if fgLayerWrappers.count > 0 {
            return
        }
        for _ in 0 ... 6{
            let layer = CAShapeLayer.cleanLayer()
            layer.backgroundColor = UIColor.clear.cgColor
            layer.fillColor = UIColor.white.cgColor
            layer.frame = self.bounds
            
            let wrapper = LCDLayerWrapper()
            
            wrapper.layer = layer
            fgLayerWrappers.append(wrapper)
            
            self.addSublayer(layer)
        }
        currentLineWidth = backgroundLineWidth
        fgLayerWrappers[0].normalPath = ceil()
        fgLayerWrappers[1].normalPath = upperRight()
        fgLayerWrappers[2].normalPath = lowerRight()
        fgLayerWrappers[3].normalPath = floor()
        fgLayerWrappers[4].normalPath = lowerLeft()
        fgLayerWrappers[5].normalPath = upperLeft()
        fgLayerWrappers[6].normalPath = mid()
        
        currentLineWidth = foregroundLineWidth
        fgLayerWrappers[0].highlightPath = ceil()
        fgLayerWrappers[1].highlightPath = upperRight()
        fgLayerWrappers[2].highlightPath = lowerRight()
        fgLayerWrappers[3].highlightPath = floor()
        fgLayerWrappers[4].highlightPath = lowerLeft()
        fgLayerWrappers[5].highlightPath = upperLeft()
        fgLayerWrappers[6].highlightPath = mid()
        
    }
    
    func draw(number:Int){
        // Can only draw 1 digit
        if number < 0 || number > 9 {
            draw(number: 9)
        }
        
        
        let toSet = wrapperSet(forNumber: number)
        
        let fromSet = currentNumber >= 0 ? wrapperSet(forNumber: currentNumber) : Set<LCDLayerWrapper>()
        
        let fadeOutSet = fromSet.subtracting(toSet)
        
        let fadeInSet = toSet.subtracting(fromSet)
        
        for wrapper in fadeOutSet{
            let pathAnim = AnimationHelper.bezierPathAnimation(from: wrapper.highlightPath, to: wrapper.normalPath, duration: animDuration)
            wrapper.layer.path = wrapper.normalPath.cgPath
            
            let colorAnim = AnimationHelper.animation(keyPath: "fillColor", from: UIColor.white.cgColor, to: self.bgLayer.fillColor, duration: animDuration)
            wrapper.layer.fillColor = self.bgLayer.fillColor
            
            wrapper.layer.add(pathAnim, forKey: nil)
            wrapper.layer.add(colorAnim, forKey: nil)
        }
        
        for wrapper in fadeInSet {
            let pathAnim = AnimationHelper.bezierPathAnimation(from: wrapper.normalPath, to: wrapper.highlightPath, duration: animDuration)
            wrapper.layer.path = wrapper.highlightPath.cgPath
            
            
            let colorAnim = AnimationHelper.animation(keyPath: "fillColor", from:self.bgLayer.fillColor , to: UIColor.white.cgColor, duration: animDuration)
            wrapper.layer.fillColor = UIColor.white.cgColor
            
            wrapper.layer.add(pathAnim, forKey: nil)
            wrapper.layer.add(colorAnim, forKey: nil)
        }
        
        currentNumber = number
     
    }
    
    private func wrapperSet(forNumber num:Int) -> Set<LCDLayerWrapper>{
        var set = Set<LCDLayerWrapper>()
        
        /*
         fgLayerWrappers[0].normalPath = ceil()
         fgLayerWrappers[1].normalPath = upperRight()
         fgLayerWrappers[2].normalPath = lowerRight()
         fgLayerWrappers[3].normalPath = floor()
         fgLayerWrappers[4].normalPath = lowerLeft()
         fgLayerWrappers[5].normalPath = upperLeft()
         fgLayerWrappers[6].normalPath = mid()
 */
        switch num {
        case 0:
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[2])
            set.insert(fgLayerWrappers[3])
            set.insert(fgLayerWrappers[4])
            set.insert(fgLayerWrappers[5])
            
            break
        case 1:
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[2])
            break
        case 2:
            
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[6])
            set.insert(fgLayerWrappers[4])
            set.insert(fgLayerWrappers[3])
            break
        case 3:
            
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[6])
            set.insert(fgLayerWrappers[2])
            set.insert(fgLayerWrappers[3])
            break
        case 4:
            
            set.insert(fgLayerWrappers[5])
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[6])
            set.insert(fgLayerWrappers[2])
            break
        case 5:
            
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[5])
            set.insert(fgLayerWrappers[6])
            set.insert(fgLayerWrappers[2])
            set.insert(fgLayerWrappers[3])
            break
        case 6:
            
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[5])
            set.insert(fgLayerWrappers[6])
            set.insert(fgLayerWrappers[2])
            set.insert(fgLayerWrappers[3])
            set.insert(fgLayerWrappers[4])
            break
        case 7:
            
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[2])
            break
        case 8:
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[2])
            set.insert(fgLayerWrappers[3])
            set.insert(fgLayerWrappers[4])
            set.insert(fgLayerWrappers[5])
            set.insert(fgLayerWrappers[6])
            break
        default:
            
            set.insert(fgLayerWrappers[0])
            set.insert(fgLayerWrappers[1])
            set.insert(fgLayerWrappers[2])
            set.insert(fgLayerWrappers[3])
            set.insert(fgLayerWrappers[5])
            set.insert(fgLayerWrappers[6])
            break
        }
        
        return set
    }
    
    //MARK: - Bezier Paths
    
    func ceil() -> UIBezierPath {
        
        let path = UIBezierPath()
        let starting = CGPoint(x: linePadding - currentLineWidth/2, y: 0)
        path.move(to: starting)
        path.addLine(to: CGPoint(x: self.bounds.width - starting.x, y: starting.y))
        path.addLine(to: CGPoint(x: self.bounds.width - starting.x - currentLineWidth, y: currentLineWidth))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth, y: currentLineWidth))
        path.close()
        
        return path
        
    }
    func mid() -> UIBezierPath {
        
        let path = UIBezierPath()
        let starting = CGPoint(x: linePadding, y: self.bounds.size.height/2 ) // a bit shorter than ceil/floor
        path.move(to: starting)
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth/2, y: starting.y - currentLineWidth/2))
        path.addLine(to: CGPoint(x: self.bounds.width - starting.x - currentLineWidth/2, y: starting.y - currentLineWidth/2))
        path.addLine(to: CGPoint(x: self.bounds.width - starting.x  , y: starting.y))
        
        path.addLine(to: CGPoint(x: self.bounds.width - starting.x - currentLineWidth/2, y: starting.y + currentLineWidth/2))
        
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth/2, y: starting.y + currentLineWidth/2))
        
        path.close()
        
        return path
        
    }
    func floor() -> UIBezierPath{
        let path = UIBezierPath()
        let starting = CGPoint(x: linePadding - currentLineWidth/2, y: self.bounds.size.height)
        path.move(to: starting)
        path.addLine(to: CGPoint(x: self.bounds.width - starting.x, y: starting.y))
        path.addLine(to: CGPoint(x: self.bounds.width - starting.x - currentLineWidth, y: starting.y - currentLineWidth))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth, y: starting.y - currentLineWidth))
        path.close()
        
        return path
    }
    
    
    func upperLeft() -> UIBezierPath{
        let path = UIBezierPath()
        let starting = CGPoint(x: 0, y: linePadding - currentLineWidth/2)
        path.move(to: starting)
        path.addLine(to: CGPoint(x: starting.x, y: self.bounds.height/2 - linePadding))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth/2, y: self.bounds.height/2 - linePadding + currentLineWidth/2 ))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth, y: self.bounds.height/2 - linePadding))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth, y: starting.y + currentLineWidth))
        path.close()
        
        return path
    }
    
    func upperRight() -> UIBezierPath{
        let path = UIBezierPath()
        let starting = CGPoint(x: self.bounds.width, y: linePadding - currentLineWidth/2)
        path.move(to: starting)
        path.addLine(to: CGPoint(x: starting.x, y: self.bounds.height/2 - linePadding ))
        path.addLine(to: CGPoint(x: starting.x - currentLineWidth/2, y: self.bounds.height/2 - linePadding + currentLineWidth/2))
        path.addLine(to: CGPoint(x: starting.x - currentLineWidth, y: self.bounds.height/2 - linePadding ))
        path.addLine(to: CGPoint(x: starting.x - currentLineWidth, y: starting.y + currentLineWidth))
        path.close()
        
        return path
    }

    func lowerLeft() -> UIBezierPath{
        let path = UIBezierPath()
        let starting = CGPoint(x: currentLineWidth/2, y: self.bounds.size.height/2 + linePadding - currentLineWidth/2)
        path.move(to: starting)
        path.addLine(to: CGPoint(x: starting.x - currentLineWidth/2, y: starting.y + currentLineWidth/2))
        path.addLine(to: CGPoint(x: starting.x - currentLineWidth/2, y: self.bounds.height - linePadding + currentLineWidth/2))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth/2, y: self.bounds.height - linePadding + currentLineWidth/2 - currentLineWidth ))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth/2, y: starting.y + currentLineWidth/2))
        path.close()
        
        return path
    }
    
    func lowerRight() -> UIBezierPath{
        let path = UIBezierPath()
        let starting = CGPoint(x: self.bounds.size.width - currentLineWidth/2, y: self.bounds.size.height/2 + linePadding - currentLineWidth/2)
        path.move(to: starting)
        path.addLine(to: CGPoint(x: starting.x - currentLineWidth/2, y: starting.y + currentLineWidth/2))
        path.addLine(to: CGPoint(x: starting.x - currentLineWidth/2, y: self.bounds.height - linePadding + currentLineWidth/2 - currentLineWidth))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth/2, y: self.bounds.height - linePadding + currentLineWidth/2 ))
        path.addLine(to: CGPoint(x: starting.x + currentLineWidth/2, y: starting.y + currentLineWidth/2))
        path.close()
        
        return path
    }
    
}


fileprivate class LCDLayerWrapper :Hashable{
    var normalPath:UIBezierPath!
    var highlightPath:UIBezierPath!
    var layer:CAShapeLayer!
    
    var hashValue: Int {
        return layer.hashValue ^ highlightPath.hashValue ^ normalPath.hashValue
    }
    
    static func == (lhs:LCDLayerWrapper ,rhs:LCDLayerWrapper) -> Bool{
        return lhs.layer == rhs.layer && lhs.normalPath == rhs.normalPath && lhs.highlightPath == rhs.highlightPath
    }
    
}
