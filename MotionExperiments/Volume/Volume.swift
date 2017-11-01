//
//  Volume.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/27.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class Volume: AbstractAnimationView {

    
    let maxVolume = 16
    let minVolume = 0
    
    let loudVolume = 12
    let midVolume = 8
    let lowVolume = 4
    
    
    let bgLen : CGFloat = 220
    var volumeCubes : [CAShapeLayer] = []
    let cubeHeight : CGFloat = 8
    var bgRect : CGRect = .zero
    var cubeLineRect : CGRect = .zero
    let trumpetSize = CGSize(width: 35, height: 55)
    let trumpetCornerRadius : CGFloat = 2.6
    let trumpetOffset : CGFloat = 8
    
    let trumpetLayer = CAShapeLayer()
    
    let maxVolumeLevel = 3
    let muteVolumeLevel = 0
    var volumeLayers = [CAShapeLayer]()
    
    let volumeStartingRadius : CGFloat = 22
    let volumeRadiusIncrement : CGFloat = 16
    
    let volumeLineWidth : CGFloat = 4
    
    
    let bgColor = UIColor.colorWithAbsolute(red: 134, green: 128, blue: 137, alpha: 1)
    
    
    let muteLayer = CAShapeLayer()
    let muteOverlayLayer = CALayer()
    let muteRectHeight : CGFloat = 6
    
    var currentVolume = 0 {
        willSet{
            if newValue > volumeCubes.count - 1 || newValue < -1{
                return
            }
            if newValue > currentVolume {
                //volume up
                volumeCubes[newValue].backgroundColor = UIColor.white.cgColor
                
            }else{
                //volume down
                volumeCubes[currentVolume].backgroundColor = UIColor.black.cgColor
            }
            
            if newValue >= loudVolume {
                updateVolumeLevel(to: 3)
            }else if newValue >= midVolume{
                updateVolumeLevel(to: 2)
            }else if newValue >= lowVolume{
                updateVolumeLevel(to: 1)
            }else{
                updateVolumeLevel(to: 0)
            }
            
            if newValue == -1 {
                showMute(true)
            }
            if currentVolume == -1 {
                showMute(false)
            }
        }
        didSet{
            if currentVolume > volumeCubes.count - 1{
                currentVolume = volumeCubes.count - 1
            }else if currentVolume < -1{
                currentVolume = -1
            }
        }
    }
    
    override func prepare() {
        addButtons()
        drawBgRect()
        addTrumpetLayer()
        addLevelLayers()
        addCubeLayers()
        addMuteLayer()
    }
    

    
    func addButtons(){
        let up = UIButton()
        up.setTitle("+", for: .normal)
        up.addTarget(self, action: #selector(self.volumeUp), for: .touchUpInside)
        up.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        up.sizeToFit()
        
        let down = UIButton()
        down.setTitle("-", for: .normal)
        down.addTarget(self, action: #selector(self.volumeDown), for: .touchUpInside)
        down.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        down.sizeToFit()
        
        
        let p = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height * 3 / 4)
        up.frame = CGRect(x: p.x + 60, y: p.y, width: up.bounds.size.width, height: up.bounds.size.height)
        down.frame = CGRect(x: p.x - 60 - down.bounds.size.width, y: p.y, width: down.bounds.size.width, height: down.bounds.size.height)
        
        up.frame = up.frame.insetBy(dx: -20, dy: -20) // easier to click
        down.frame = down.frame.insetBy(dx: -20, dy: -20)
        
        self.addSubview(up)
        self.addSubview(down)
        
        self.backgroundColor = UIColor.colorWithAbsolute(red: 42, green: 37, blue: 45, alpha: 1)
        
    }
    
    func addCubeLayers(){
        
        let borderWidth : CGFloat = 1
        let numOfCubes = maxVolume - minVolume
        let startVolume = (maxVolume + minVolume) / 2
        let widthPerCube = (cubeLineRect.width - borderWidth) / CGFloat(numOfCubes)
        for i in 0...numOfCubes - 1{
            let rect = CGRect(x: cubeLineRect.origin.x + CGFloat(i) * widthPerCube + borderWidth, y: cubeLineRect.origin.y + borderWidth, width: widthPerCube - borderWidth, height: cubeHeight - 2 * borderWidth)
            let cubeLayer = cubeInRect(rect: rect)
            volumeCubes.append(cubeLayer)
            if i > startVolume{
                cubeLayer.backgroundColor = UIColor.black.cgColor
            }
            self.animationLayer.addSublayer(cubeLayer)
        }
        
        currentVolume = startVolume
        
    }
    
    func cubeInRect(rect:CGRect) -> CAShapeLayer{
        let layer = CAShapeLayer()
        layer.frame = rect
        
        layer.backgroundColor = UIColor.white.cgColor
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.black.cgColor
        
        return layer
    }
    
    func drawBgRect(){
        
        let rect = CGRect(x: self.bounds.size.width / 2 - bgLen/2, y: self.bounds.size.height / 2 - bgLen / 2, width: bgLen, height: bgLen)
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let bgPath = UIBezierPath(roundedRect: rect, cornerRadius: bgLen / 8)
        bgColor.setFill()
        bgPath.fill()
        
        
        let cubeLine = UIBezierPath()
        cubeLine.move(to: CGPoint(x:rect.origin.x + rect.width / 10 , y:rect.origin.y + rect.height * 9 / 10))
        cubeLine.addLine(to: CGPoint(x:rect.origin.x + rect.width * 9 / 10 , y:rect.origin.y + rect.height * 9 / 10))
        
        UIColor.black.setStroke()
        cubeLine.lineWidth = cubeHeight
        cubeLine.stroke()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        animationLayer.contents = img?.cgImage
        
        cubeLineRect = CGRect(x: rect.origin.x + rect.width / 10 , y:rect.origin.y + rect.height * 9 / 10 - cubeHeight/2, width: rect.width * 8 / 10, height: cubeHeight)
        bgRect = rect
        
    }
    
    
    func addTrumpetLayer(){
        let rect = CGRect(x: bgRect.midX - trumpetSize.width, y: bgRect.midY - trumpetSize.height/2 - trumpetOffset, width: trumpetSize.width, height: trumpetSize.height)
        
        trumpetLayer.frame = rect
        
        let width = trumpetSize.width
        let height = trumpetSize.height
        
        trumpetLayer.lineJoin = kCALineJoinRound
        trumpetLayer.lineWidth = 1
        trumpetLayer.fillColor = UIColor.black.cgColor
        let path = UIBezierPath()
        
        //upper right corner
        let theta = atan(width/(height/2)) / 2
        let offsetY = trumpetCornerRadius / tan(theta)
        let urangle = (CGFloat.pi / 2 - theta) * 2
        let urcenter = CGPoint(x :width - trumpetCornerRadius , y:offsetY)
        
        let lrcenter = CGPoint(x :width - trumpetCornerRadius , y: height - offsetY)
        //右下角点的坐标，其直角边有一条长度就是offsetY的长度
        let beta = CGFloat.pi / 2 - 2 * theta
        let lrPoint = CGPoint(x:width - cos(beta) * offsetY,y: height - sin(beta) * offsetY)
        let lrangle = urangle
        
        
        let ulcenter = CGPoint(x:trumpetCornerRadius ,y:trumpetCornerRadius + height/4)
        let llcenter = CGPoint(x:trumpetCornerRadius , y: height*3/4 - trumpetCornerRadius)
        
        path.addArc(withCenter: llcenter, radius: trumpetCornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2, clockwise: false)
        path.addLine(to: CGPoint(x:width/2,y:height*3/4))
        path.addLine(to: lrPoint)
        path.addArc(withCenter: lrcenter, radius: trumpetCornerRadius, startAngle: lrangle, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x:width,y:offsetY))
        path.addArc(withCenter: urcenter, radius: trumpetCornerRadius, startAngle: 0, endAngle: -urangle, clockwise: false)
        path.addLine(to: CGPoint(x:width/2,y:height/4))
        path.addLine(to: CGPoint(x:trumpetCornerRadius,y:height/4))
        path.addArc(withCenter: ulcenter, radius: trumpetCornerRadius, startAngle: CGFloat.pi * 3 / 2, endAngle: CGFloat.pi, clockwise: false)
        path.close()
        
        
        
        trumpetLayer.path = path.cgPath
        
        animationLayer.addSublayer(trumpetLayer)
    }
    
    
    func addLevelLayers(){
        var radius = volumeStartingRadius
        let angle = CGFloat.pi / 2
        
        var x = radius * cos(angle/2)
        var y = radius * sin(angle/2)
        
        var frame = CGRect(x: bgRect.midX + radius, y: bgRect.midY - y - trumpetOffset, width: radius - x, height: y * 2)
        
        var cen = CGPoint(x: -x, y: y)
        
        
        
        for _ in muteVolumeLevel+1 ... maxVolumeLevel{
            let layer = CAShapeLayer()
            layer.frame = frame
            layer.lineWidth = volumeLineWidth
            layer.strokeColor = UIColor.black.cgColor
            layer.lineCap = kCALineCapRound
            layer.fillColor = UIColor.clear.cgColor
            let path = UIBezierPath()
            path.addArc(withCenter: cen, radius: radius, startAngle: angle/2, endAngle: -angle/2, clockwise: false)
            layer.path = path.cgPath
            
            animationLayer.addSublayer(layer)
            volumeLayers.append(layer)
            
            radius = radius + volumeRadiusIncrement
            
            x = radius * cos(angle/2)
            y = radius * sin(angle/2)
            
            cen = CGPoint(x: -x, y: y)
            frame = CGRect(x: bgRect.midX + radius, y: bgRect.midY - y - trumpetOffset, width: radius - x, height: y * 2)
        }
        
    }

    func addMuteLayer(){
        muteLayer.frame = bgRect
//        muteLayer.backgroundColor = UIColor.orange.withAlphaComponent(0.3).cgColor
//        muteLayer.opacity = 0
        
        
        let clip = UIBezierPath(roundedRect: CGRect(x:0,y:0,width:bgRect.width,height:bgRect.height), cornerRadius: bgLen / 8)
        let maskLayer = CAShapeLayer()
        maskLayer.path = clip.cgPath
        muteLayer.mask = maskLayer
        
        muteOverlayLayer.frame = muteLayer.bounds
        muteOverlayLayer.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
        muteLayer.addSublayer(muteOverlayLayer)
        
        muteOverlayLayer.opacity = 0
        
        muteLayer.strokeColor = bgColor.cgColor
        muteLayer.fillColor = UIColor.black.cgColor
        muteLayer.lineWidth = 2
        
        
        
        animationLayer.addSublayer(muteLayer)
    }
    
    
    func showMute(_ show:Bool){
        
        
        let trumpetFrameInBg = CGRect(x: trumpetLayer.frame.origin.x - bgRect.origin.x, y: trumpetLayer.frame.origin.y - bgRect.origin.y, width: trumpetLayer.frame.width, height: trumpetLayer.frame.height)
        let width = sqrt(trumpetFrameInBg.width * trumpetFrameInBg.width + trumpetFrameInBg.height * trumpetFrameInBg.height) * 1.2
        let longPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: muteRectHeight), cornerRadius: muteRectHeight/2)
        let shortPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 0, height: muteRectHeight), cornerRadius: muteRectHeight/2)
        let offsetx = 0.15 * width * cos(CGFloat.pi/6)
        let offsety = 0.1 * width * sin(CGFloat.pi/6)
        
        let transform = CGAffineTransform(translationX:trumpetFrameInBg.origin.x - offsetx, y: trumpetFrameInBg.origin.y + offsety).rotated(by: CGFloat.pi / 6)
        
        longPath.apply(transform)
        shortPath.apply(transform)
        
        if show {
            let fadein = AnimationHelper.animation(keyPath: "opacity", from: 0, to: 1, duration: 0.2)
            muteOverlayLayer.opacity = 1
            muteOverlayLayer.add(fadein, forKey: "volume.mutefadein")
            
            muteLayer.path = longPath.cgPath
            let lineGrow = AnimationHelper.animation(keyPath: "path", from: shortPath.cgPath, to: longPath.cgPath, duration: 0.2)
            muteLayer.add(lineGrow, forKey: "volume.mutegrow")
            
        }else{
            let fadeout = AnimationHelper.animation(keyPath: "opacity", from: 1, to: 0, duration: 0.2)
            muteOverlayLayer.opacity = 0
            muteOverlayLayer.add(fadeout, forKey: "volume.mutefadeout")
            
            
            muteLayer.path = shortPath.cgPath
            let lineShrink = AnimationHelper.animation(keyPath: "path", from: longPath.cgPath, to: shortPath.cgPath, duration: 0.2)
            muteLayer.add(lineShrink, forKey: "volume.muteshrink")
        }
    }
    
    func updateVolumeLevel(to tolevel:Int){
        let level = max(muteVolumeLevel, min(tolevel,maxVolumeLevel))
        
        // mute=0 , no layer , 1 ~ maxVolume
        if(level >= 1){
            
            for i in 1 ... level {
                let vLayer = volumeLayers[i - 1]
                if vLayer.lineWidth <= 0.0001{ // only animate layers that hasn't show.
                    vLayer.lineWidth = volumeLineWidth
                }
            }
        }
        
        if level < maxVolumeLevel {
            for i in level + 1 ... maxVolumeLevel{
                let vLayer = volumeLayers[i - 1]
                if vLayer.lineWidth >= volumeLineWidth - 0.0001{
                    vLayer.lineWidth = 0
                    
                }
            }
        }
        
        
        let transform = CATransform3DMakeTranslation(CGFloat(-level) * volumeLineWidth * 1.6, 0, 0)
        

        for vLayer in volumeLayers{
            
            vLayer.transform = transform
        }
        
        trumpetLayer.transform = transform
    }
    
    @objc func volumeUp(){
        currentVolume += 1
    }
    
    @objc func volumeDown(){
        currentVolume -= 1
    }

    
    
}
