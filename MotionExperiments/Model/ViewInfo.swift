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
    var ViewClass : AbstractAnimationView.Type
    
    init(_ title:String , viewClass:AbstractAnimationView.Type){
        self.title = title
        self.ViewClass = viewClass
        
        super.init()
    }
}
