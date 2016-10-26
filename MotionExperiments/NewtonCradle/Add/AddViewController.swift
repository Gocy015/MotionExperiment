//
//  AddViewController.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/18.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.colorWithAbsolute(red: 22, green: 108, blue: 109, alpha: 1)
        self.title = "Add"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.bgTapped))
        self.view .addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let buttonRadius : CGFloat = 22
        let buttonFrame = CGRect(x: view.bounds.size.width/2 - buttonRadius, y: view.bounds.size.height - 5 * buttonRadius, width: 2 * buttonRadius, height: 2 * buttonRadius)
        let button = ButtonInputTextField(buttonFrame: buttonFrame)
        
        self.view.addSubview(button)
    }
    
    
    func bgTapped(){
        NSLog("Background tapped")
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
