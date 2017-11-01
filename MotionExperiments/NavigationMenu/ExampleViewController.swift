//
//  ExampleViewController.swift
//  MotionExperiments
//
//  Created by Gocy on 16/11/18.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController ,UIGestureRecognizerDelegate {
    
    var navigationMenu : NavigationMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Navigation Menu"
        self.view.backgroundColor = UIColor.colorWithAbsolute(red: 22, green: 108, blue: 109, alpha: 1)
        
        /*
         UIGestureRecognizer will break UITableView's event handling,
         overriding hitTest won't work
         so if your background view has any kind of UIGestureReognizer
         implement the delegate and return navigationMenu.shouldReceiveGesture()
         */
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        tap.delegate = self
//        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationMenu = NavigationMenu(frame:self.view.bounds)
        self.view.addSubview(navigationMenu)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func didTap(tap:UITapGestureRecognizer) {
        NSLog("Background was tapped !")
    }

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return navigationMenu.shouldReceiveGesture(touch: touch)
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
