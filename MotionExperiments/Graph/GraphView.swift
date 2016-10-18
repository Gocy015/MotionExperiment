//
//  GraphView.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/17.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class GraphView: AbstractAnimationView ,CAAnimationDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var values : [CGFloat] = [2,32,-16,32,16,64,128,64,-8]
    private var positions : [CGPoint] = []
    var currentPath : UIBezierPath!
    let radius :CGFloat = 3.0
    let thinLineWidth : CGFloat = 1
    let normalLineWidth : CGFloat = 2
    let thickLineWidth : CGFloat = 4
    let totalAnimDuration : TimeInterval = 1.2
    var slowerDuration : TimeInterval = 0
    var normalDuration : TimeInterval = 0
    let pointLayer = CAShapeLayer()
    var lastLinePath : UIBezierPath!
    var lastPointPath : UIBezierPath!
    
    var topLayer : CAShapeLayer!
    var midLayer : CAShapeLayer!
    var bottomLayer : CAShapeLayer!
    
    var topY : CGFloat = 0
    var bottomY : CGFloat = 0
    
    override func prepare() {
        
        calculatePositions()
        
        self.animationLayer.path = nil
        pointLayer.path = nil
        if pointLayer.superlayer == nil {
            self.layer.addSublayer(pointLayer)
            pointLayer.frame = self.layer.bounds
            pointLayer.backgroundColor = UIColor.clear.cgColor
        }
        
        
        pointLayer.lineWidth = normalLineWidth
        pointLayer.strokeColor = UIColor.black.cgColor
        pointLayer.fillColor = self.backgroundColor?.cgColor
 
        
        animationLayer.backgroundColor = UIColor.clear.cgColor
        animationLayer.strokeColor = UIColor.black.cgColor
        animationLayer.lineWidth = normalLineWidth
        
        //start & end slower animation
        let duration = TimeInterval(totalAnimDuration / TimeInterval(positions.count))
        slowerDuration = duration * 1.6;
        
        normalDuration = (totalAnimDuration - slowerDuration * 2.0) / TimeInterval(positions.count - 2)
        
        
        
        self.timeUntilStop = -1
    }
    
    override func start() {
        super.start()
        
        self.clean()
        
        self.drawLine(toIndex: 1, duration: slowerDuration)
        self.drawReferenceLine()
        
        delegate?.animationDidStart()
    }
    
    override func stop() {
        super.stop()
    }
    
    
    //MARK: - Helpers

    func clean(){
        self.animationLayer.path = nil
        pointLayer.path = nil
        
        lastPointPath = UIBezierPath()
        
        lastLinePath = UIBezierPath()
        lastLinePath.move(to: positions.first!)
        lastLinePath.addLine(to: positions.first!)
        
        animationLayer.path = lastLinePath.cgPath
        
        topLayer.strokeEnd = 0
        midLayer.strokeEnd = 0
        bottomLayer.strokeEnd = 0
        
    }
    
    func calculatePositions(){
        // bounds should be set correctly by now
        
        positions.removeAll()
        
        let width = bounds.size.width
        let height = min(bounds.size.height, width / 2.5)
        
        let widthPerElement = width / CGFloat(values.count)
        let max = values.max()!
        let minimum = values.min()!
        
        
        var x = widthPerElement / 2;
        let yOffset = (bounds.size.height + height) / 2.0
        
        var y : CGFloat = 0
        
        for value in values {
            y = (value - minimum) * (-height) / (max - minimum) + yOffset
            
            positions.append(CGPoint(x: x, y: y))
                
            x += widthPerElement
        }
        
        topY = -height + yOffset
        bottomY = yOffset
        
        addReferenceLine()
    }
    
    
    //MARK: - Drawing
    func drawLine(toIndex:Int ,duration:TimeInterval){
        if toIndex >= positions.count {
            return;
        }
        let newPath = linePath(toIndex: toIndex)
        //anim
        
        let lineAnim = AnimationHelper.bezierPathAnimation(from: lastLinePath.copy() as! UIBezierPath, to: newPath, duration: duration)
        lastLinePath = newPath
        
        animationLayer.add(lineAnim, forKey: "graph.lineanimation\(toIndex)")
        
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            var dur = self.normalDuration
            if (toIndex + 1 == self.positions.count - 1){
                dur = self.slowerDuration
            }
            self.drawLine(toIndex: toIndex + 1, duration: dur)
            if(toIndex == 1){
                self.drawPoint(at: 0 ,duration:dur * 2.22)
            }
            self.drawPoint(at: toIndex ,duration:dur * 2.22)
        }
    }
    
    
    func drawPoint(at:Int ,duration:TimeInterval){
        //create a new layer to animate line width changes
        let pointAnimPath = pointPath(atIndex: at)
        let pointAnimLayer = CAShapeLayer()
        pointAnimLayer.frame = self.layer.bounds
        pointAnimLayer.fillColor = self.backgroundColor?.cgColor
        pointAnimLayer.strokeColor = UIColor.black.cgColor
        pointAnimLayer.path = pointAnimPath.cgPath
        
        self.layer.addSublayer(pointAnimLayer)
        
        let goLarge = AnimationHelper.animation(keyPath: "lineWidth", from: 0, to: normalLineWidth * 1.7, duration: duration)
        goLarge.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0, 0.7, 1)
        
        let goNormal = AnimationHelper.animation(keyPath: "lineWidth", from: normalLineWidth * 1.7, to: normalLineWidth , duration: duration)
        goNormal.timingFunction = CAMediaTimingFunction(controlPoints: 0.27, 0, 0.33, 1.4)
        
        let animGroup = CAAnimationGroup()
        let group = AnimationHelper.generateAnimationSequence(goLarge,goNormal)!
        animGroup.animations = group
        animGroup.duration = group.last!.beginTime + group.last!.duration
        
        animGroup.setValue(pointAnimLayer, forKey: "targetLayer")
        animGroup.setValue(at, forKey: "pointIndex")
        animGroup.delegate = self
        
        
        pointAnimLayer.add(animGroup, forKey: "graph.pointanimation\(at)")
        
        
    }
    
    func addReferenceLine(){
        let midY = (topY + bottomY) / 2.0
        
        if topLayer == nil {
            
            topLayer = referenceLineLayer(at:topY)
            midLayer = referenceLineLayer(at:midY)
            bottomLayer = referenceLineLayer(at:bottomY)
        }
        
    }
    
    func referenceLineLayer(at:CGFloat) -> CAShapeLayer{
        let layer = CAShapeLayer()
        layer.frame = self.layer.bounds
        self.layer.insertSublayer(layer, below: animationLayer)
        
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.strokeColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.strokeEnd = 0
        layer.lineWidth = 1
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: layer.bounds.size.width,y:at))
        path.addLine(to: CGPoint(x: 0, y: at))
        
        layer.path = path.cgPath
        
        return layer
    }
    
    func drawReferenceLine(){
        let timingFunc = CAMediaTimingFunction(controlPoints: 0.38, 0.12, 0.6, 1)
        let topAnim = AnimationHelper.animation(keyPath: "strokeEnd", from: 0, to: 1, duration: totalAnimDuration * 2 / 3)
        topAnim.timingFunction = timingFunc 

        let midAnim = topAnim.copy() as! CABasicAnimation
        midAnim.beginTime = CACurrentMediaTime() + totalAnimDuration / 6.0
        
        let bottomAnim = topAnim.copy() as! CABasicAnimation
        bottomAnim.beginTime = CACurrentMediaTime() + totalAnimDuration / 3.0
        
        topLayer.add(topAnim, forKey: "graphview.toprefline")
        midLayer.add(midAnim, forKey: "graphview.midrefline")
        bottomLayer.add(bottomAnim, forKey: "graphview.bottomrefline")
    }
    
    func addPoint(at:Int){
        
        //pointLayer holds the actual points
        let newPath = pointPath(toIndex: at)
        pointLayer.path = (newPath.copy() as! UIBezierPath).cgPath
        lastPointPath = newPath
        
        if(at == positions.count - 1){
            delegate?.animationDidFinished()
        }
        
    }

    
    func pointPath(toIndex:Int) -> UIBezierPath{
        let path = lastPointPath.copy() as! UIBezierPath
        
        if toIndex >= positions.count {
            return path
        }
        
        path.append(pointPath(atIndex: toIndex))
        
        return path
    }
    
    func pointPath(atIndex:Int) -> UIBezierPath{
        if atIndex >= positions.count{
            return UIBezierPath()
        }
        
        let rect = CGRect(x: positions[atIndex].x - radius, y: positions[atIndex].y - radius, width: 2*radius, height: 2*radius)
        return UIBezierPath(ovalIn: rect)
    }
    
    func linePath(toIndex:Int) -> UIBezierPath{
        let path = lastLinePath.copy() as! UIBezierPath
        
        if toIndex >= positions.count {
            return path
        }
        
        path.addLine(to: positions[toIndex])
        
        return path
    }
    
    //MARK: - CAAnimation Delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animLayer = anim.value(forKey: "targetLayer") as? CALayer{
            animLayer.removeAllAnimations()
            animLayer.removeFromSuperlayer()
        }
        if let index = anim.value(forKey: "pointIndex") as? Int {
            self.addPoint(at: index)
        }
    }
}
