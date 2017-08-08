//
//  CompleteViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 13/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Complete Setup")
    }
    
    @IBAction func completeSetup(_ sender: UIButton) {
        completeProfile()
        let dashboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboardTabController") as! DashboardTabBarViewController
        self.present(dashboard, animated: true)
    }
    
    func completeProfile(){
        if let user = UserManager.fetch(){
            if !user.profile_complete{
                user.profile_complete = true
                UserManager.persistContext()
            }
            AnalyticsHelper.notifyEvent(category: "user_action", action: "setup_completed", label: "Setup Completed")
        }
    }
}
