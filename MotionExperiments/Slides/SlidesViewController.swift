//
//  SlidesViewController.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/31.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class SlidesViewController: UIViewController {
    
    let slides = SlidesView(frame: .zero, pointerSize: CGSize(width:8,height:28))
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Slides"
        
        self.view.backgroundColor = .white
        self.view.addSubview(slides)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let w = self.view.bounds.width
        let h = self.view.bounds.height / 2.2
        
        slides.frame = CGRect(x: 0, y: self.view.bounds.midY - h/2, width: w, height: h)
        
        let cyanView = generateGradientView(fromColor: UIColor.colorWithAbsolute(red: 166, green: 233, blue: 249, alpha: 1), toColor: UIColor.colorWithAbsolute(red: 211, green: 255, blue: 178, alpha: 1))
        
        let orangeView = generateGradientView(fromColor: UIColor.colorWithAbsolute(red: 218, green: 97, blue: 75, alpha: 1), toColor: UIColor.colorWithAbsolute(red: 249, green: 230, blue: 143, alpha: 1))
        
        let darkView = generateGradientView(fromColor: UIColor.colorWithAbsolute(red: 48, green: 100, blue: 90, alpha: 1), toColor: UIColor.colorWithAbsolute(red: 22, green: 13, blue: 28, alpha: 1))
        
        slides.setViews(views: cyanView,orangeView,darkView)
    }

    
    func generateGradientView(fromColor from:UIColor ,toColor to:UIColor) -> UIView{
        let view = GradientView(fromColor: from, toColor: to, startPoint: CGPoint(x:0,y:0), endPoint: CGPoint(x:1,y:1))
        
        return view
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
