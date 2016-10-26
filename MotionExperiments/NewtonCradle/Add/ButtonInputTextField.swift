//
//  ButtonInputTextField.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/20.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit





/*
 When the keyboard shows up for the first time in the entire app's life cycle,
 notification .UIKeyboardWillShow will be send twice , casuing a discontinuous animation.
 
 When changing the apperance of the keyboard(changing keyboard input type) , .UIKeyboardWillShow will also be sent,
 and because the background path is already in an expanded state , it will perform a simple animation to adapt to new keyboard height.
 */
class ButtonInputTextField: UIView {

    var buttonFrame = CGRect.zero
    private let button = UIButton()
    private var isExpanded = false
    private let textField = UITextField()
    private var bgLayer = CAShapeLayer()
    private let duration : TimeInterval = 0.8
    private var currentMaskRect : CGRect = .zero
    private let rotateAngle : CGFloat = CGFloat.pi * 3 / 4
    
    init(buttonFrame : CGRect){
        self.buttonFrame = buttonFrame
        
        super.init(frame: .zero)
        
        self.layer.addSublayer(bgLayer)
        
        self.addSubview(button)
        button.addTarget(self, action: #selector(self.buttonClick), for: .touchUpInside)
        
        self.addSubview(textField)
        textField.keyboardAppearance = UIKeyboardAppearance.dark
        
        self.initElements()
        registerNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        if superview != nil {
            self.frame = superview!.bounds;
            bgLayer.frame = self.layer.bounds;
        }
    }
    
    deinit {
        unregisterNotifications()
    }
    
    //MARK: - Notifications
    func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(noti:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(noti:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(noti:NSNotification){
        if let keyboardHeightVal = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyboardHeightVal.cgRectValue.height
            
            self.expand(toHeight: keyboardHeight)
        }
    }
    
    func keyboardWillHide(noti:NSNotification){
        shrink()
    }
    
    func initElements(){
        self.backgroundColor = UIColor.clear
        
        button.frame = self.buttonFrame
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: UIFontWeightLight)
        button.setTitle("+", for: .normal)
        
        button.contentVerticalAlignment = .top
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        
//        button.backgroundColor = UIColor.colorWithAbsolute(red: 13, green: 64, blue: 85, alpha: 1)
//
//        button.layer.cornerRadius = min(self.buttonFrame.size.width, self.buttonFrame.size.height) / 2
        
        button.backgroundColor = UIColor.clear
        
        
        textField.attributedPlaceholder = NSAttributedString(string: "Do something", attributes: [NSForegroundColorAttributeName : UIColor.lightGray , NSFontAttributeName : UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)])
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        textField.textColor = UIColor.white
//        textField.frame = buttonFrame
        
        bgLayer.fillColor = UIColor.colorWithAbsolute(red: 13, green: 64, blue: 85, alpha: 1).cgColor
        bgLayer.path = UIBezierPath(ovalIn: button.frame).cgPath
        
        
        
        
    }
    
    func expand(toHeight:CGFloat){
        
        
        var btnRect = buttonFrame
        btnRect.origin = CGPoint(x:self.bounds.size.width - buttonFrame.size.width,y:self.bounds.size.height - toHeight - buttonFrame.size.height)
        
        let textFieldRect = CGRect(x: 12, y: btnRect.origin.y, width: self.bounds.size.width - 12 - btnRect.width, height: buttonFrame.height)
        let offsetTransform = CGAffineTransform(translationX: 0, y: textFieldRect.height)
        
        
        //mask
        let maskRect = CGRect(x: 0, y: btnRect.origin.y, width: self.bounds.size.width, height: toHeight + button.frame.size.height)
        currentMaskRect = maskRect
        
        if bgLayer.mask == nil{
            
            let mask = CAShapeLayer()
            
            bgLayer.mask = mask
        }
        
        (bgLayer.mask as? CAShapeLayer)?.path = UIBezierPath(rect: maskRect).cgPath
        
        bgLayer.mask?.frame = bgLayer.bounds
        
        
        
        //background expand
        let cen = CGPoint(x: buttonFrame.origin.x + buttonFrame.size.width / 2,y: buttonFrame.origin.y + buttonFrame.size.height / 2)
        
        let a = maskRect.origin.x - cen.x, b = maskRect.origin.y - cen.y
        
        let radius = ceil(sqrt((a*a + b*b)))
        
        let midRect = CGRect(x: cen.x - radius / 4, y: cen.y - radius / 2, width: radius / 2, height:  radius)
        
        // super width for visual effect
        let finalRect = CGRect(x: cen.x - 3 * radius, y: cen.y - radius, width: 6 * radius, height: 2 * radius)
        
        let fromPath = UIBezierPath(ovalIn: button.frame)
        
        let midPath = UIBezierPath(ovalIn: midRect)
        
        let toPath = UIBezierPath(ovalIn: finalRect)
        
        
        
        if isExpanded{ // already expanded , could be key board frame change ,simply change the path and button's frame
            let trans = self.button.transform
            UIView.animate(withDuration: 0.12, animations: {
                self.button.transform = .identity
                self.button.frame = btnRect
                self.button.transform = trans
                
                self.textField.frame = textFieldRect
            })
            let bgGrowAnim = AnimationHelper.bezierPathAnimation(from: UIBezierPath(cgPath:bgLayer.path!), to: toPath, duration: 0.12)
            bgLayer.path  = toPath.cgPath
            bgLayer.add(bgGrowAnim, forKey: "add.bgsimplegrowanimation")
            
            return ;
        }
        
        
        
        bgLayer.path = toPath.cgPath
        let bgGrowAnim = AnimationHelper.bezierPathAnimation(from: fromPath, to: midPath, duration: duration * 0.3)
        
        let bgExpandAnim = AnimationHelper.bezierPathAnimation(from: midPath, to: toPath, duration: duration * 0.65)
        
        let bgAnim = AnimationHelper.generateAnimationGroup(bgGrowAnim,bgExpandAnim)
        bgAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.07, 0.45, 0.65, 1)
        
        bgLayer.add(bgAnim, forKey: "add.bggrowanimation")
        
        
        // button
        let frameAnimator = UIViewPropertyAnimator(duration: duration * 0.3, controlPoint1: CGPoint(x:0.33 , y:0.56), controlPoint2: CGPoint(x:0.66 ,y:0.88)) {
            self.button.frame = btnRect
        }
        
        frameAnimator.startAnimation(afterDelay: duration * 0.25)
        
        let transformAnimator = UIViewPropertyAnimator(duration: duration * 0.25, curve: .easeInOut) {
            self.button.transform = CGAffineTransform(rotationAngle: self.rotateAngle)
        }
        
        transformAnimator.startAnimation(afterDelay: duration * 0.4)
        
        //text field
        textField.frame = textFieldRect
        textField.alpha = 0
        textField.transform = offsetTransform
        
        UIView.animate(withDuration: 0.3 * duration, delay: 0.2 * duration, options: .curveEaseInOut, animations: {
            self.textField.alpha = 1
            self.textField.transform = .identity
            }) { (_) in
                
        }
        
        
        isExpanded = true
        
    }
    
    func shrink(){
        if !isExpanded{
            return
        }
        let finalPath = UIBezierPath(ovalIn: buttonFrame)
        
        let center = CGPoint(x: buttonFrame.origin.x + buttonFrame.size.width / 2,y: buttonFrame.origin.y + buttonFrame.size.height/2)
        let finalRadius = buttonFrame.width / 2;
        
        let maskRect = currentMaskRect
        let a = maskRect.origin.x - center.x, b = maskRect.origin.y - center.y
        let currentRadius = ceil(sqrt((a*a + b*b)))
        
        let midRect = CGRect(x: center.x -  maskRect.size.width / 2, y: center.y - 1.5 * finalRadius, width: maskRect.size.width, height: 3 * finalRadius)
        let midPath = UIBezierPath(ovalIn: midRect)
        
        let currentRect = CGRect(x: center.x - 3 * currentRadius, y: center.y - currentRadius, width: 6 * currentRadius, height: 2 * currentRadius)
        
        
        
        //text field
        let offsetTransform = CGAffineTransform(translationX: 0, y: textField.bounds.size.height)
        textField.alpha = 1
        
        UIView.animate(withDuration: 0.08 * duration ,animations: {
            self.textField.alpha = 0
            self.textField.transform = offsetTransform
        }){
            _ in
            self.textField.transform = .identity
        }
        
        
        //bg
        bgLayer.path = finalPath.cgPath
        
        let fromPath = UIBezierPath(ovalIn: currentRect)
        
        let bgShrinkAnim = AnimationHelper.bezierPathAnimation(from: fromPath, to: midPath, duration: duration * 0.55)
        bgShrinkAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0, 0.95, 0.98)
        let bgNarrowAnim = AnimationHelper.bezierPathAnimation(from: midPath, to: finalPath, duration: duration * 0.22)
        bgNarrowAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.03, 0.08, 0.86, 0.55)
        
        let bgAnim = AnimationHelper.generateAnimationGroup(bgShrinkAnim,bgNarrowAnim)
        bgAnim.beginTime = CACurrentMediaTime() + 0.2 * duration
        bgLayer.add(bgAnim, forKey: "add.bgshrinkanimation")
        
        
        let animator = UIViewPropertyAnimator(duration: duration * 0.4, controlPoint1: CGPoint(x:0.3 , y:0), controlPoint2: CGPoint(x:0.6 ,y:1)) {
            self.button.transform = CGAffineTransform.identity

            self.button.frame = self.buttonFrame
        }
        animator.startAnimation(afterDelay: duration * 0.32)
        isExpanded = false
        
        
        
        
    }
    
    func buttonClick(){
        
        if isExpanded {
            UIView.animate(withDuration: 0.7 * duration, animations: {
                self.textField.resignFirstResponder()
            })
        }else{
            
//            expand(toHeight: 300)
            
            UIView.animate(withDuration: 0.8 * duration, animations: {
                self.textField.becomeFirstResponder()
            })
            
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if button.frame.contains(point){
            return button
        }
        if textField.frame.contains(point){
            return textField
        }
        return nil
    }

}

