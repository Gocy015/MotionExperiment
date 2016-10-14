//
//  ContainerViewController.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/13.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController ,AnimationViewDelegate {
    
    var contentView:AbstractAnimationView?{
        willSet{
            if let ct = contentView{
                ct.removeFromSuperview()
            }
        }
        
        didSet{
            if let ct = contentView {
                view.addSubview(ct)
                self.title = NSStringFromClass(type(of:ct)).components(separatedBy: ".").last
                ct.delegate = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NSLog("ContainerVC Deinit")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView?.prepare()
        startAnimationLoop()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        contentView?.frame = view.bounds
    }

    func startAnimationLoop(){
        contentView?.start()
        contentView?.perform(#selector(AbstractAnimationView.stop), with: nil, afterDelay: 2.2)
    }
    
    
    
    //MARK: - AnimationView Delegate
    func animationDidStart() {
        
    }
    func animationDidFinished() {
        self.perform(#selector(self.startAnimationLoop), with: nil, afterDelay: 0.5)
         
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


