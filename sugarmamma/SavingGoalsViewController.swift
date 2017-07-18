//
//  SavingGoalsViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 8/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class SavingGoalsViewController: BaseSetupControllerViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var addGoalButton: UIButton!
    
    
    var sectionHeaders: [String] = [""]
    var sectionContent: [[SavingGoalsModel]] {get{
        return [
            SavingGoalsManager.fetch()
        ]
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataTableView.reloadData()
        collectTotals()
        disableAddButtonObserver()
    }
    
    @IBAction func goalCreateAction(_ sender: UIButton) {
        let popupController = UIStoryboard(name: "Setup", bundle: Bundle.main).instantiateViewController(withIdentifier: "SavingGoalsPopupViewController") as! SavingGoalsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.isNew = true
        self.present(popupController, animated: true)
    }
    
    @IBAction func goalChangeAction(_ sender: UIButton) {
        let indexPath = getIndexPathRelativeToUIView(sender)
        let goalsEntity = self.sectionContent[(indexPath?.section)!][(indexPath?.row)!]
        let popupController = UIStoryboard(name: "Setup", bundle: Bundle.main).instantiateViewController(withIdentifier: "SavingGoalsPopupViewController") as! SavingGoalsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.goalEntity = goalsEntity
        popupController.isNew = false
        self.present(popupController, animated: true)
    }
    
    func disableAddButtonObserver(){
        //if there > 0 goals exist disable add goal button (business rule: you should only be able to have one savings goal at a time otherwise calculations for the savings account will become too complex)
        if sectionContent[0].count > 0{
            addGoalButton.layer.backgroundColor = GlobalVariables.lightTextGrey.cgColor
            addGoalButton.setTitleColor(UIColor.white, for: .normal)
            addGoalButton.isEnabled = false
        }else{
            addGoalButton.layer.backgroundColor = GlobalVariables.strongYellow.cgColor
            addGoalButton.setTitleColor(GlobalVariables.buttonTextGrey, for: .normal)
            addGoalButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SavingsGoalCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SavingGoalsTableViewCell
        cell.goalAmountField.delegate = self
        //cell.eventDateField.delegate = self
        let cellContent = sectionContent[indexPath.section][indexPath.row]
        //restore store values
        if cellContent.amount > 0{
            cell.goalAmountField.text = String(format: "%.2f", cellContent.amount)
        }else{
            cell.goalAmountField.text = ""
        }
        cell.goalNameLabel.text = cellContent.goal_name
        cell.goalDateField.setTitle(DateHelper.toString(cellContent.goal_due_date! as Date, dateFormat: "d/M/yyyy"), for: .normal)
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        if let indexPath = getIndexPathRelativeToUIView(textField){
            let goalEntity = sectionContent[indexPath.section][indexPath.row]
            if let goalAmount = textField.text{
                if let double = Double(goalAmount){
                    textField.text = String(format: "%.2f", double)
                    goalEntity.amount = double
                    SavingGoalsManager.persistContext()
                    collectTotals()
                }
                
            }
        }
        
    }
    
}
