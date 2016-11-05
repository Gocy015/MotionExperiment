//
//  SlideableViewContainer.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/31.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SlideableViewContainer: NSObject {
    var view : UIView!
    var leftPointerImage : UIImage?
    var rightPointerImage : UIImage?
    
    init(view:UIView) {
        self.view = view
        super.init()
    }
}
