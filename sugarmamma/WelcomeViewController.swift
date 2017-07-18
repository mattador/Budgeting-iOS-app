//
//  WelcomeViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 16/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var welcomeName: UITextField!
    var userProfile: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeName.delegate = self
        if let user = UserManager.fetch(){
            userProfile = user
            welcomeName.text = user.name
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //if identifier == "welcomeSegue" {}
        if welcomeName.text == "" {
            //print("hoollld up")
            return false
        }
        if userProfile != nil{
            userProfile?.name = welcomeName.text
            UserManager.persistContext()
            return true
        }else{
            //create new user profile
            if UserManager.create(welcomeName.text!) {
                return true
            }
        }
        return false
        
    }
    
}
