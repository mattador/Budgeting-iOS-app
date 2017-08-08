//
//  DashboardViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 8/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import ImageSlideshow

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var dashboardCenter: UIView!
    @IBOutlet var dashboardTutorial: UIView!
    @IBOutlet weak var dashboardStack: UIStackView!
    @IBOutlet weak var currentTutorialTip: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var welcomeUserName: UILabel!
    @IBOutlet weak var iconsView: UIView!
    var tutorialEnd: Bool = false
    var user: UserModel = UserManager.fetch()!
    var dashboardTutorialTopConstraint: NSLayoutConstraint!
    
    var tutorialTips: [String] = [
        "Click here to view your Forecast!",
        "Click here to manage Budget!",
        "Click here to view & add Financial Events!",
        "Click here to view Sugarmamma Tips & Tricks"
    ]
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeUserName.text = user.name!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) + "!"
        welcomeUserName.adjustsFontSizeToFitWidth = true
        self.navigationController?.isToolbarHidden = true
        
        /*let logo = UIImage(named: "Welcome_Header-1.png")
         let imageView = UIImageView(image:logo)
         self.navigationItem.titleView = imageView*/
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !user.dashboard_tips_displayed {
            user.dashboard_tips_displayed = true
            UserManager.persistContext()
            self.displayTutorialAlert()
        }else{
            drawDividerLines()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Dashboard")
    }
    
    func drawDividerLines(){
        // draw circle view for welcome "icon" located at center of dashboard
        dashboardCenter.layer.borderWidth = 1
        dashboardCenter.layer.borderColor = GlobalVariables.borderGrey.cgColor
        dashboardCenter.layer.cornerRadius = 75
        
        let screenBounds: CGRect = UIScreen.main.bounds
        //let aproxheightOfHeader = CGFloat(98) //actually 70 plus 20 leading margin and 8 trailing
        let aproxheightOfHeader = (self.navigationController?.navigationBar.frame.height)! + 8
        
        
        //draw vertical line from middle of view under header until welcome area
        drawLine(
            moveX: screenBounds.size.width / 2, //to the middle of the screen
            moveY: ((screenBounds.size.height - (75 / 2)) / 2) - (aproxheightOfHeader / 2) + 4 , //to middle of screen minus half of header height
            addLineX: screenBounds.size.width / 2, //from middle of width of screen
            addLineY: aproxheightOfHeader //from below header
        )
        
        //draw vertical line from middle of view under welcome area until bottom of view
        drawLine(
            moveX: screenBounds.size.width / 2,
            moveY: screenBounds.size.height,
            addLineX: screenBounds.size.width / 2,
            addLineY: (screenBounds.size.height / 2) + (aproxheightOfHeader / 2) + 75 + 4
        )
        
        let middlePoint = (screenBounds.size.height / 2) + (aproxheightOfHeader / 2) + 4
        
        //draw horizontal line in middle of icons and ending just before welcome area
        drawLine(
            moveX: (screenBounds.size.width / 2)-75,
            moveY: middlePoint,
            addLineX: 0,
            addLineY: middlePoint
        )
        
        //draw horizontal line in middle of icons from after welcome area to bounds of screen
        drawLine(
            moveX: screenBounds.size.width,
            moveY: middlePoint,
            addLineX: (screenBounds.size.width / 2)+75,
            addLineY: middlePoint
        )
        
    }
    
    func drawLine(moveX: CGFloat, moveY: CGFloat, addLineX: CGFloat, addLineY: CGFloat){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: moveX, y: moveY))
        path.addLine(to: CGPoint(x: addLineX, y: addLineY))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = GlobalVariables.borderGrey.cgColor
        shape.lineWidth = 1
        view.layer.addSublayer(shape)
    }
    
    @IBAction func closeTutorial(_ sender: UIButton) {
        removeTutorial()
    }
    
    func removeTutorial(){
        view.willRemoveSubview(dashboardTutorial)
        dashboardTutorial.removeFromSuperview()
    }
    
    
    func displayTutorialAlert(){
        let tutorialMenu = UIAlertController(title: "Would you like to view a quick tutorial?", message: nil, preferredStyle: .alert)
        let blurVisualEffectView = GlobalVariables.createBlurView(view)
        let actionHandler = {
            (action: UIAlertAction) -> Void in
            self.user.dashboard_tips_displayed = true
            UserManager.persistContext()
            blurVisualEffectView.removeFromSuperview()
            self.view.insertSubview(self.dashboardTutorial, aboveSubview: self.dashboardStack)
            self.dashboardTutorial.translatesAutoresizingMaskIntoConstraints = false
            self.dashboardTutorial.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.dashboardTutorialTopConstraint = NSLayoutConstraint.init(item: self.dashboardTutorial, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 20)
            self.dashboardTutorialTopConstraint.isActive = true
            //self.dashboardTutorialTopConstraint.constant = 750
            self.dashboardTutorial.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.95).isActive = true
            self.dashboardTutorial.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
            self.slideShow.pageControlPosition = .insideScrollView
            self.slideShow.setImageInputs([
                ImageSource(image: UIImage(named: "dashboard-tutorial-1")!),
                ImageSource(image: UIImage(named: "dashboard-tutorial-2")!),
                ImageSource(image: UIImage(named: "dashboard-tutorial-3")!),
                ImageSource(image: UIImage(named: "dashboard-tutorial-4")!)
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
                    blurVisualEffectView.removeFromSuperview()
                    self.drawDividerLines()
                    self.removeTutorial()
                }
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
        let cancelAction = UIAlertAction(title: "No thanks", style: .cancel, handler: {
            (action: UIAlertAction) -> Void in
            blurVisualEffectView.removeFromSuperview()
            self.drawDividerLines()
        })
        //cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        tutorialMenu.addAction(cancelAction)
        
        let yesAction = UIAlertAction(title: "Yes please!", style: .default, handler: actionHandler)
        //yesAction.setValue(GlobalVariables.darkGreen, forKey: "titleTextColor")
        tutorialMenu.addAction(yesAction)
        self.view.addSubview(blurVisualEffectView)
        present(tutorialMenu, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forecastTapped(_ sender: UITapGestureRecognizer) {
        manuallySwitchTab(1)
    }
    
    @IBAction func financialEventsTapped(_ sender: UITapGestureRecognizer) {
        manuallySwitchTab(2)
    }
    
    @IBAction func budgetTapped(_ sender: UITapGestureRecognizer) {
        manuallySwitchTab(3)
    }
    
    @IBAction func tipsTapped(_ sender: UITapGestureRecognizer) {
        manuallySwitchTab(4)
    }
    
    func manuallySwitchTab(_ index: Int){
        navigationController?.tabBarController?.selectedIndex = index
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
}
