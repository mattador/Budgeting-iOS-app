//
//  SettingsViewTableViewCell.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 10/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class SettingsViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var settingsTip: UILabel!
    @IBOutlet weak var settingSwitchValue: UISwitch!
    
    @IBAction func changeSettingsSwitchEvent(_ sender: UISwitch) {
        let user: UserModel = UserManager.fetch()!
        switch settingsLabel.text! {
        case "Reset account":
            user.reset = sender.isOn
            if sender.isOn {
                //send back to loading screen
                let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoaderViewController") as! LoaderViewController
                self.window?.rootViewController = viewController
            }
            break
        case "Upcoming financial events":
            user.notify_coming_events = sender.isOn
            break
        case "Monthly forecast alert":
            user.notify_monthly_forecast_alert = sender.isOn
            break
        case "New tips & tricks":
            user.notify_new_tips = sender.isOn
            break
        default:
            break
        }
        UserManager.persistContext()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
