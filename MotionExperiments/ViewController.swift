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
        
        let cls = data[indexPath.row].ViewClass
        let vc = ContainerViewController()
        vc.contentView = cls.init()
        self.show(vc, sender: nil)
    }
    
    //MARK: - Helpers
    func generateData(){
        let spinner = ViewInfo("Spinner",viewClass:SpinnerView.self)
        data.append(spinner)
        
        let graph = ViewInfo("Graph",viewClass:GraphView.self)
        data.append(graph)
        
        let searchIcon = ViewInfo("Search Icon",viewClass:SearchIcon.self)
        data.append(searchIcon)
        
        let newtonCradle = ViewInfo("Newton Cradle",viewClass:NewtonCradle.self)
        data.append(newtonCradle)
        
        tableView.reloadData()
    }
    
}

