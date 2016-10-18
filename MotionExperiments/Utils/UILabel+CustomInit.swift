//
//  UILabel+CustomInit.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/18.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

extension UILabel{
    static func descriptionLabel(withDescription des:String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        label.text = des
        label.sizeToFit()
        return label
    }
}
