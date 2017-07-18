//
//  SettingsConfigurationViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 10/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class SettingsConfigurationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var settingsHeaderValue: String = ""
    
    var sectionContentHeaders: [String] = []
    var sectionContentValues: [Bool] = []
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsLabel.text = settingsHeaderValue
        setupTable()
    }
    
    func setupTable(){
        
        if let user = UserManager.fetch(){
            if settingsHeaderValue == "General settings"{
                sectionContentHeaders = ["Reset account"]
                sectionContentValues =  [user.reset]
            }else {
                sectionContentHeaders = [
                    "Upcoming financial events",
                    "Monthly forecast alert",
                    "New tips & tricks",
                ]
                sectionContentValues = [
                    user.notify_coming_events,
                    user.notify_monthly_forecast_alert,
                    user.notify_new_tips
                ]
            }
        }
    }
    
    //settingsViewTableViewCell
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return sectionContentValues.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellIdentifier = "settingsViewTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SettingsViewTableViewCell
        
        cell.settingsLabel.text = sectionContentHeaders[indexPath.row]
        if sectionContentHeaders[indexPath.row] == "Reset account"{
            cell.settingsTip.text = "This will reset SugarMamma"
        }else{
            cell.settingsTip.text = ""
        }
        cell.settingSwitchValue.setOn(sectionContentValues[indexPath.row], animated: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView, let textLabel = headerView.textLabel {
            //headerView.layer.top/
            let newSize = CGFloat(17)
            let fontName = "SFDisplay-Text Medium"
            textLabel.font = UIFont(name: fontName, size: newSize)
            //textLabel.textColor = GlobalVariables.purple
            headerView.tintColor = UIColor.white
        }
    }
    
}
