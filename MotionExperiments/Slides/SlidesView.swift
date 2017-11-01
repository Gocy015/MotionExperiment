//
//  SlidesView.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/31.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

fileprivate let kViewToRemove = "viewToRemove"
fileprivate let kViewToPresent = "viewToPresent"

fileprivate struct SlidePoiterDirection : OptionSet{
    let rawValue : Int
    
    static let left = SlidePoiterDirection(rawValue: 1 << 0)
    static let right = SlidePoiterDirection(rawValue: 1 << 1)
}

class SlidesView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    fileprivate var viewContainers : [SlideableViewContainer] = []
    let lineWidth : CGFloat = 3
    
    let leftPointerButton = UIButton()
    let rightPointerButton = UIButton()
    
    var pointerSize = CGSize(width: 12, height: 22)
    
    var currentSlideIndex : Int = -1
    
    var prevSlide : SlideableViewContainer?
    
    let duration : TimeInterval = 0.75
    
    let transitionPortionY : CGFloat = 0.15
    let transitionPortionX : CGFloat = 0.2

    init(frame: CGRect ,pointerSize:CGSize) {
        self.pointerSize = pointerSize
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.leftPointerButton.addTarget(self, action: #selector(goPrev), for: .touchUpInside)
        self.rightPointerButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        
        self.addSubview(self.leftPointerButton)
        self.addSubview(self.rightPointerButton)
    }
    
    var leftPointerRect : CGRect{
        get{
            return CGRect(x: self.bounds.width / 20 + pointerSize.width, y: self.bounds.midY - self.pointerSize.height / 2, width: pointerSize.width, height: pointerSize.height)
        }
    }
    
    var pointerRatio : CGFloat{
        if pointerSize.height != 0 {
            return (pointerSize.width / pointerSize.height) / 5
        }
        
        return 0
    }
    
    var rightPointerRect : CGRect{
        get{
            return CGRect(x: self.bounds.width * 19 / 20 - pointerSize.width, y: self.bounds.midY - self.pointerSize.height / 2, width: pointerSize.width, height: pointerSize.height)
        }
    }
    
    var rightTransitionPath : UIBezierPath{
        get{
            let path = UIBezierPath()
            let start = CGPoint(x: self.bounds.width * transitionPortionX, y: self.bounds.height * transitionPortionY)
            let width = self.bounds.width * (1 - transitionPortionX)
            let height = self.bounds.height * (1 - 2 * transitionPortionY)
            
            let leftInner = CGPoint(x: start.x + height * self.pointerRatio, y: start.y + height/2)
            let rightOuter = CGPoint(x:start.x + width + height * self.pointerRatio , y: start.y + height/2)
            
            path.move(to: start)
            path.addLine(to: CGPoint(x: start.x + width, y: start.y))
            path.addLine(to: rightOuter)
            path.addLine(to: CGPoint(x: start.x + width, y: start.y + height))
            path.addLine(to: CGPoint(x: start.x, y: start.y + height))
            path.addLine(to: leftInner)
            path.close()
            
            return path
        }
    }
    
    //需要一个六边形来平滑过渡
    var originalPath : UIBezierPath{
        get{
            let path = UIBezierPath()
            let ori = self.bounds.origin
            let width = self.bounds.width
            let height = self.bounds.height
            path.move(to: ori)
            path.addLine(to: CGPoint(x: ori.x + width, y: ori.y))
            path.addLine(to: CGPoint(x: ori.x + width, y: ori.y + height/2))
            path.addLine(to: CGPoint(x: ori.x + width, y: ori.y + height))
            path.addLine(to: CGPoint(x: ori.x, y: ori.y + height))
            path.addLine(to: CGPoint(x: ori.x, y: ori.y + height/2))
            path.close()
            
            return path
        }
    }
    
    var leftTransitionPath : UIBezierPath{
        get{
            let path = UIBezierPath()
            let start = CGPoint(x: 0, y: self.bounds.height * transitionPortionY)
            let width = self.bounds.width * (1 - transitionPortionX)
            let height = self.bounds.height * (1 - 2 * transitionPortionY)
            
            let leftOuter = CGPoint(x: start.x - height * self.pointerRatio, y: start.y + height/2)
            let rightInner = CGPoint(x:start.x + width - height * self.pointerRatio , y: start.y + height/2)
            
            path.move(to: start)
            path.addLine(to: CGPoint(x: start.x + width, y: start.y))
            path.addLine(to: rightInner)
            path.addLine(to: CGPoint(x: start.x + width, y: start.y + height))
            path.addLine(to: CGPoint(x: start.x, y: start.y + height))
            path.addLine(to: leftOuter)
            path.close()
            
            return path
        }
    }
    
    var leftPointerPath : UIBezierPath{
        get{
            let path = UIBezierPath()
            
            let upleft = CGPoint(x: self.leftPointerRect.origin.x + pointerSize.width - lineWidth, y: self.leftPointerRect.origin.y)
            path.move(to: upleft)
            path.addLine(to: CGPoint(x: upleft.x + lineWidth, y: upleft.y))
            path.addLine(to: CGPoint(x: upleft.x - pointerSize.width + lineWidth + lineWidth,y:upleft.y + self.pointerSize.height / 2))
            
            path.addLine(to: CGPoint(x: upleft.x + lineWidth, y: upleft.y + pointerSize.height))
            path.addLine(to: CGPoint(x: upleft.x ,y:upleft.y + self.pointerSize.height))
            path.addLine(to: CGPoint(x: upleft.x - pointerSize.width + lineWidth, y: upleft.y + pointerSize.height / 2))
            
            path.close()
            
            return path
        }
    }
    
    var rightPointerPath : UIBezierPath{
        get{
            let path = UIBezierPath()
            
            let upleft = CGPoint(x: self.rightPointerRect.origin.x, y: self.rightPointerRect.origin.y)
            path.move(to: upleft)
            path.addLine(to: CGPoint(x: upleft.x + lineWidth, y: upleft.y))
            path.addLine(to: CGPoint(x: upleft.x + self.rightPointerRect.size.width,y:upleft.y + self.pointerSize.height / 2))
            
            path.addLine(to: CGPoint(x: upleft.x + lineWidth, y: upleft.y + pointerSize.height))
            path.addLine(to: CGPoint(x: upleft.x  ,y:upleft.y + self.pointerSize.height))
            path.addLine(to: CGPoint(x: upleft.x + pointerSize.width - lineWidth, y: upleft.y + pointerSize.height / 2))
            
            path.close()
            
            return path
        }
    }
    
    override func layoutSubviews() {
        
        self.leftPointerButton.frame = self.leftPointerRect
        self.rightPointerButton.frame = self.rightPointerRect
        
        prevSlide?.view.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setViews(views:UIView...){
        setViews(views: views)
    }
    
    func setViews(views:[UIView]){
        for i in 0...views.count - 1{
            let view = views[i]
            view.frame = self.bounds
            if let sublayers =  view.layer.sublayers {
                for layer in sublayers {
                    layer.frame = view.layer.bounds
                }
            }
            
            let direction : SlidePoiterDirection = i == 0 ? .left : (i == views.count - 1 ? .right : [.left,.right])
            let container = generateViewContainer(forView: view, pointerDirectoin: direction)
            viewContainers.append(container)
        }
        gotoSlide(to: 0)
        
//        let testlayer = CAShapeLayer()
//        testlayer.frame = self.layer.bounds
//        testlayer.path = self.leftTransitionPath.cgPath
//        
//        self.layer.mask = testlayer
    }
    
    
    
    
    //MARK: - Actions
    
    @objc func goPrev(){
        NSLog("go prev")
        gotoSlide(to: currentSlideIndex - 1)
    }
    @objc func goNext(){
        NSLog("go next")
        gotoSlide(to: currentSlideIndex + 1)
    }
    
    
    //MARK: - Helpers
    
    
    func gotoSlide(to:Int){
        if to < 0 || to >= viewContainers.count || to == currentSlideIndex {
            return
        }
        let toSlide = viewContainers[to]
        if let prev = prevSlide {
            self.leftPointerButton .setImage(nil, for: .normal)
            self.rightPointerButton.setImage(nil, for: .normal)
            
            //insert below ,animate path change ,when done, set button image
            let shrinkTransitionPath = to > currentSlideIndex ? self.leftTransitionPath : self.rightTransitionPath
            
            let expandTransitionPath = to > currentSlideIndex ? self.rightTransitionPath : self.leftTransitionPath
            
            let shrinkPath = to > currentSlideIndex ? self.leftPointerPath : self.rightPointerPath
            let expandPath = to > currentSlideIndex ? self.rightPointerPath : self.leftPointerPath
            
            let shrinkMaskLayer = CAShapeLayer()
            let expandMaskLayer = CAShapeLayer()
            
            shrinkMaskLayer.frame = self.bounds
            expandMaskLayer.frame = self.bounds
            
            shrinkMaskLayer.path = shrinkPath.cgPath
            expandMaskLayer.path = expandPath.cgPath
            
            prev.view.layer.mask = shrinkMaskLayer
            toSlide.view.layer.mask = expandMaskLayer
            
            let shrinkTransitionAnim = AnimationHelper.bezierPathAnimation(from: self.originalPath, to: shrinkTransitionPath, duration: duration * 0.2)
            shrinkTransitionAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0, 0.9, 0.6)
            let shrinkAnim = AnimationHelper.bezierPathAnimation(from: shrinkTransitionPath, to: shrinkPath, duration: duration*0.3)
            let shrink = AnimationHelper.generateAnimationGroup(shrinkTransitionAnim,shrinkAnim)
            shrink.setValue(prev.view, forKey: kViewToRemove)
            shrink.delegate = self
            
            let expandTransitionAnim = AnimationHelper.bezierPathAnimation(from: expandPath, to: expandTransitionPath, duration: duration * 0.35)
            let expandAnim = AnimationHelper.bezierPathAnimation(from: expandTransitionPath, to:self.originalPath, duration: duration * 0.55)
            expandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 0.84, 0.61, 1)
            let expand = AnimationHelper.generateAnimationGroup(expandTransitionAnim,expandAnim,removeOnCompletion:false)
            expand.beginTime = CACurrentMediaTime() + duration * 0.15
            
            expand.setValue(toSlide.view, forKey: kViewToPresent)
            expand.delegate = self
            
            
            self.insertSlide(slide: toSlide.view, aboveSlide: prev.view)
            
            shrinkMaskLayer.add(shrink, forKey: "slide.shrink")
            expandMaskLayer.add(expand, forKey: "slide.expand")
            
            
        }else{
            // first time set slide ,simply set
            
            self.addSlide(slide: toSlide.view)
            if to > 0 {
                self.leftPointerButton.setImage(viewContainers[to-1].leftPointerImage, for: .normal)
            }
            if to < viewContainers.count - 1{
                self.rightPointerButton.setImage(viewContainers[to+1].rightPointerImage, for: .normal)
            }
        }
        
        prevSlide = toSlide
        currentSlideIndex = to
    }
    
    
    //should be put in bgthread
    fileprivate func generateViewContainer(forView view:UIView ,pointerDirectoin direction:SlidePoiterDirection) -> SlideableViewContainer{
        let container = SlideableViewContainer(view:view)
        let scale = UIScreen.main.scale
        
        if direction.contains(.left){
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
            
            let mask = CAShapeLayer()
            mask.path = self.leftPointerPath.cgPath
            mask.frame = view.layer.bounds

            view.layer.mask = mask
            
            view.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            
            
            var image : UIImage? = nil
            
            if let originalImage = UIGraphicsGetImageFromCurrentImageContext(){
                let convertedRect = CGRect(x: self.leftPointerRect.origin.x * scale, y: self.leftPointerRect.origin.y * scale, width: self.leftPointerRect.width * scale, height: self.leftPointerRect.height * scale)
                if let cg = originalImage.cgImage?.cropping(to: convertedRect){
                    
                    image = UIImage(cgImage: cg)
                }
            }
            
            UIGraphicsEndImageContext()
            
            container.leftPointerImage = image
            
        }
        
        if direction.contains(.right) {
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
            
            let mask = CAShapeLayer()
            mask.path = self.rightPointerPath.cgPath
            mask.frame = view.layer.bounds
            
            view.layer.mask = mask
            
            view.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            
            var image : UIImage? = nil
            
            if let originalImage = UIGraphicsGetImageFromCurrentImageContext(){
                let convertedRect = CGRect(x: self.rightPointerRect.origin.x * scale, y: self.rightPointerRect.origin.y * scale, width: self.rightPointerRect.width * scale, height: self.rightPointerRect.height * scale)
                if let cg = originalImage.cgImage?.cropping(to: convertedRect){
                    
                    image = UIImage(cgImage: cg)
                }
                
            }
            
            UIGraphicsEndImageContext()
            
            container.rightPointerImage = image;
            
        }
        
        view.layer.mask = nil;
        
        return container
    }
    
    
    func addSlide(slide:UIView){
        slide.frame = self.bounds
        self.insertSubview(slide, belowSubview: self.leftPointerButton)
    }
    
    func insertSlide(slide:UIView ,aboveSlide below:UIView){
        slide.frame = self.bounds
        self.insertSubview(slide, aboveSubview: below)
    }
    
}


extension SlidesView : CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let view = anim.value(forKey: kViewToPresent) as? UIView{
            view.layer.mask = nil
            
        }
        if let view = anim.value(forKey: kViewToRemove) as? UIView{
            view.removeFromSuperview()
            view.layer.mask = nil
            
            if currentSlideIndex > 0 {
                self.leftPointerButton.setImage(viewContainers[currentSlideIndex-1].leftPointerImage, for: .normal)
            }
            if currentSlideIndex < viewContainers.count - 1{
                self.rightPointerButton.setImage(viewContainers[currentSlideIndex+1].rightPointerImage, for: .normal)
            }
        }
        
    }
}
