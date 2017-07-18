//
//  DashboardTabBarViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 17/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class DashboardTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        if tabBar.selectedItem?.title == "Home"{
            tabBar.isHidden = true
        }else{
            tabBar.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tabBar.selectedItem?.title != "Home"{
            tabBar.isHidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
