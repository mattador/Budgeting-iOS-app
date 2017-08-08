//
//  StartViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 16/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import ImageSlideshow

class LoaderViewController: UIViewController {
    
    
    @IBOutlet var welcomeTutorial: UIView!
    @IBOutlet weak var currentTutorialTip: UILabel!
    var welcomeTutorialTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var loaderLogoAndImage: UIStackView!
    var sendToDashboard = false
    var tutorialEnd: Bool = false
    var tutorialTips: [String] = [
        "Choose currency here",
        "Enter value and choose frequency from dropdown menu",
        "You can use the highlighted buttons below to remove or add income options",
        "Once you have finished entering the information, click ‘Next’ to progress"
    ]
    
    var user: UserModel? = UserManager.fetch()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //hard reset
        //initAppData()
        if let userModel = user{
            if userModel.version_installed < CURRENT_VERSION || (userModel.name?.isEmpty)! || (userModel.reset){
                initAppData()
            }else if userModel.profile_complete{
                //go to dashboard instead
                sendToDashboard = true
                //sendToDashboard = false
            }
        }else{
            initAppData()
        }
    }
    
    func initAppData(){
        BudgetManager.install()
        UserManager.delete("")
        FinancialEventManager.delete("")
        SavingGoalsManager.delete("")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTutorial(_ sender: UIButton) {
        view.willRemoveSubview(welcomeTutorial)
        welcomeTutorial.removeFromSuperview()
        continueToWelcomeScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //skip alert and loading screen
        
        //self.continueToDashboardScene()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            if self.sendToDashboard {
                self.continueToDashboardScene()
            }else{
                self.displayTutorialAlert()
                //self.continueToWelcomeScene()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Loading")
        AnalyticsHelper.notifyEvent(category: "user_event", action: "application_opened", label: "Application opened")
    }
    
    func displayTutorialAlert(){
        let tutorialMenu = UIAlertController(title: "Would you like to view a quick tutorial?", message: nil, preferredStyle: .alert)
        let blurVisualEffectView = GlobalVariables.createBlurView(view)
        let actionHandler = {
            (action: UIAlertAction) -> Void in
            blurVisualEffectView.removeFromSuperview()
            self.view.insertSubview(self.welcomeTutorial, aboveSubview: self.loaderLogoAndImage)
            self.welcomeTutorial.translatesAutoresizingMaskIntoConstraints = false
            self.welcomeTutorial.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.welcomeTutorialTopConstraint = NSLayoutConstraint.init(item: self.welcomeTutorial, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 20)
            self.welcomeTutorialTopConstraint.isActive = true
            //self.welcomeTutorialTopConstraint.constant = 1000
            self.welcomeTutorial.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.95).isActive = true
            self.welcomeTutorial.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
            self.slideShow.pageControlPosition = .insideScrollView
            self.slideShow.setImageInputs([
                ImageSource(image: UIImage(named: "tutorial-1")!),
                ImageSource(image: UIImage(named: "tutorial-2")!),
                ImageSource(image: UIImage(named: "tutorial-3")!),
                ImageSource(image: UIImage(named: "tutorial-4")!)
                ])
            self.currentTutorialTip.text = self.tutorialTips[0]
            self.slideShow.currentPageChanged = { page in
                if page == self.tutorialTips.count - 1{
                    self.tutorialEnd = true
                }
                self.currentTutorialTip.text = self.tutorialTips[page]
            }
            self.slideShow.willBeginDragging = {
                if self.slideShow.currentPage == self.tutorialTips.count - 1 && self.tutorialEnd{
                    self.continueToWelcomeScene()
                }
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
        let cancelAction = UIAlertAction(title: "No thanks", style: .cancel, handler: {
            (action: UIAlertAction) -> Void in
            blurVisualEffectView.removeFromSuperview()
            self.continueToWelcomeScene()
        })
        //cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        tutorialMenu.addAction(cancelAction)
        
        let yesAction = UIAlertAction(title: "Yes please!", style: .default, handler: actionHandler)
        //yesAction.setValue(GlobalVariables.darkGreen, forKey: "titleTextColor")
        tutorialMenu.addAction(yesAction)
        self.view.addSubview(blurVisualEffectView)
        present(tutorialMenu, animated: true, completion: nil)
        
    }
    
    func continueToWelcomeScene(){
        let welcome = UIStoryboard(name: "Setup", bundle: Bundle.main).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        self.present(welcome, animated: true)
        
        //let welcome = UIStoryboard(name: "Setup", bundle: Bundle.main).instantiateViewController(withIdentifier: "FinancialEventsViewController") as! FinancialEventsViewController
        //self.present(welcome, animated: true)
        
    }
    
    func continueToDashboardScene(){
        let dashboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboardTabController") as! DashboardTabBarViewController
        self.present(dashboard, animated: true)
    }
}
