//
//  ViewController.swift
//  MotionExperiments
//
//  Created by Gocy on 16/10/13.
//  Copyright © 2016年 Gocy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    let reuseid = "TitleCell"

    @IBOutlet weak var tableView: UITableView!
    
    var data : [ViewInfo] = []
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.generateData()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "Motions"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseid)!
        
        cell.textLabel?.text = data[indexPath.row].title
        
        
        return cell
    }


    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewCls = data[indexPath.row].viewClass{
            let vc = ContainerViewController()
            vc.contentView = viewCls.init()
            self.show(vc, sender: nil)
        }else if let vcClass = data[indexPath.row].viewControllerClass{
            self.show(vcClass.init(), sender: nil)
        }
    }
    
    //MARK: - Helpers
    func generateData(){
        let spinner = ViewInfo("01 - Spinner",viewClass:SpinnerView.self)
        data.append(spinner)
        
        let graph = ViewInfo("02 - Graph",viewClass:GraphView.self)
        data.append(graph)
        
        let searchIcon = ViewInfo("03 - Search Icon",viewClass:SearchIcon.self)
        data.append(searchIcon)
        
        let newtonCradle = ViewInfo("04 - Newton Cradle",viewClass:NewtonCradle.self)
        data.append(newtonCradle)
        
        let add = ViewInfo("05 - Add",viewControllerClass:AddViewController.self)
        data.append(add)
    
        let volume = ViewInfo("06 - Volume" ,viewClass:Volume.self)
        data.append(volume)
        
        let buttonTouch = ViewInfo("07 - Button Touch",viewClass:ButtonTouch.self)
        data.append(buttonTouch)
        
        let slides = ViewInfo("10 - Slides",viewControllerClass:SlidesViewController.self)
        data.append(slides)
        
        let lcd = ViewInfo("11 - LCD",viewClass:LCDView.self)
        data.append(lcd)
        
        let sync = ViewInfo("13 - Syncing/Success Icon",viewClass:SyncSuccessIcon.self)
        data.append(sync)
        
        let counter = ViewInfo("14 - Counter(Sorry , i'm not able to achieve this)" ,viewClass:Counter.self)
        data.append(counter)
        
        let menu = ViewInfo("16 - Navigation Menu",viewControllerClass:ExampleViewController.self)
        data.append(menu)
        
        tableView.reloadData()
    }
    
}

