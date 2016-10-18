//
//  ViewInfo.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/13.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class ViewInfo: NSObject {
    var title : String
    var viewClass : AbstractAnimationView.Type?
    var viewControllerClass : UIViewController.Type?
    
    init(_ title:String , viewClass:AbstractAnimationView.Type){
        self.title = title
        self.viewClass = viewClass
        self.viewControllerClass = nil
        super.init()
    }
    
    init(_ title:String , viewControllerClass:UIViewController.Type){
        self.title = title
        self.viewClass = nil
        self.viewControllerClass = viewControllerClass
        super.init()
    }
    
}
