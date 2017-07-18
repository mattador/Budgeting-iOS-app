//
//  ForecastSegmentViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 18/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class ForecastSegmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var forecastSegmentLabel: String?
    var forecastMonth: String?
    var forecastSegmentBreakdown: [ForecastStruct]?
    var forecastSegmentText: String?
    
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var forecastMonthLabel: UILabel!
    @IBOutlet weak var forecastSegmentTextLabel: UILabel!
    @IBOutlet weak var forecastMonthTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastLabel.text = forecastSegmentLabel
        forecastMonthLabel.text = forecastMonth
        forecastSegmentTextLabel.text = forecastSegmentText
        // Do any additional setup after loading the view.
        forecastMonthTable.tableFooterView = UIView(frame: .zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return forecastSegmentBreakdown!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if forecastSegmentLabel == "Savings account"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastSegmentGoalsTableViewCell", for: indexPath) as! ForecastSegmentGoalsTableViewCell
            let cellValue = forecastSegmentBreakdown?[indexPath.row]
            //print("PROGRESS BAR SHOULD BE AT \(Float((cellValue?.goalProgressBar)!))")
            let amount = cellValue?.amount
            cell.goalAmount.text =  "$" + String(format: "%.2f", amount!)
            cell.goalName.text = cellValue!.label
            cell.goalProgressBar.setProgress(Float(cellValue!.goalProgressBar), animated: true)
            //print (cellValue!.goalLastMonthAndNotComplete)
            cell.goalProgressBar.progressTintColor = GlobalVariables.pastelGreen
            cell.goalProgressBar.trackTintColor = GlobalVariables.borderGrey
            if cellValue!.goalLastMonthAndNotComplete {
                cell.goalName.text = cellValue!.label + " - Unmet goal"
                cell.goalProgressBar.trackTintColor = GlobalVariables.pinkRed
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastSegmentTableViewCell", for: indexPath) as! ForecastSegmentTableViewCell
            let cellValue = forecastSegmentBreakdown?[indexPath.row]
            let amount = cellValue?.amount
            cell.categoryFieldAmount.text = "$" + String(format: "%.2f", amount!)
            cell.categoryFieldName.text = cellValue?.label
            cell.selectionStyle = .none
            return cell
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return = sectionHeaders[section]
        return ""
    }
    
}
