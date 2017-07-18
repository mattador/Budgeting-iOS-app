//
//  BaseBudgetViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 28/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class BaseBudgetViewController: BaseSetupControllerViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    var budgetCategoryTitle: String {get {return ""}}
    var sectionHeaders: [String] {get{return []}}
    var sectionContent: [[BudgetModel]] {get{return[]}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataTableView.reloadData()
        collectTotals()
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
        let cellIdentifier = "BudgetCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BudgetTableViewCell
        cell.amountTextField.delegate = self
        
        let cellContent = sectionContent[indexPath.section][indexPath.row]
        cell.amountTextField.placeholder = userModel.currency!
        //restore store values
        if(cellContent.amount > 0){
            cell.amountTextField.text = String(format: "%.2f", cellContent.amount)
        }else{
            cell.amountTextField.text = ""
        }
        if let frequency = cellContent.frequency{
            cell.frequencyOptionField.setTitle(frequency, for: .normal)
            cell.frequencyOptionField.backgroundColor = GlobalVariables.pastelGreen
        }else{
            if cellContent.amount > 0{
                cell.frequencyOptionField.backgroundColor = GlobalVariables.pinkRed
            }else{
                cell.frequencyOptionField.backgroundColor = GlobalVariables.purple
            }
            
            cell.frequencyOptionField.setTitle("Frequency", for: .normal)
        }
        cell.budgetCategoryFieldName.text = cellContent.label
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        self.view.endEditing(true)
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
            //update budget entity
            
            let budgetEntity = sectionContent[indexPath.section][indexPath.row]
            if let amount = textField.text{
                if let double = Double(amount){
                    textField.text = String(format: "%.2f", double)
                    budgetEntity.amount = double
                    BudgetManager.persistContext()
                    collectTotals()
                    if budgetEntity.frequency == nil {
                        let cell = dataTableView.cellForRow(at: indexPath) as! BudgetTableViewCell
                        cell.frequencyOptionField.backgroundColor = GlobalVariables.pinkRed
                    }
                }else{
                    budgetEntity.amount = 0
                    budgetEntity.frequency = nil
                    let cell = dataTableView.cellForRow(at: indexPath) as! BudgetTableViewCell
                    cell.frequencyOptionField.setTitle("Frequency", for: .normal)
                    cell.frequencyOptionField.backgroundColor = GlobalVariables.purple
                    BudgetManager.persistContext()
                    collectTotals()
                }
            }
        }
    }
    
    func hasIncompleteFields() -> Bool{
        return false
    }
    
    func hasIncompleteData(_ items: [BudgetModel]) -> Bool{
        for item in items{
            if item.amount > 0{
                if item.frequency == nil{
                    return true
                }
            }
        }
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if hasIncompleteFields(){
            return false
        }
        return true
    }
    
    @IBAction func changeFrequency(_ sender: UIButton) {
        view.endEditing(true)
        let indexPath = getIndexPathRelativeToUIView(sender)
        let budgetEntity = self.sectionContent[(indexPath?.section)!][(indexPath?.row)!]
        
        //Client request - Would it be possible to return the frequency drop downs during the setup? And only add the pop up screen for users select quarterly, half yearly or yearly?
        
        let frequencyMenu = UIAlertController(title: "Select frequency", message: nil, preferredStyle: .actionSheet)
        let options = ["Weekly", "Fortnightly", "Monthly", "Quarterly", "Half-yearly", "Yearly"]
        for option in options{
            let actionHandler = {
                (action: UIAlertAction) -> Void in
                sender.setTitle(option, for: .normal)
                //update field and object
                budgetEntity.frequency = option
                BudgetManager.persistContext()
                if ["Weekly", "Fortnightly", "Monthly"].index(of: option) != nil{
                    sender.backgroundColor = GlobalVariables.pastelGreen
                    self.collectTotals()
                }else{
                    let popupController = UIStoryboard(name: "Setup", bundle : Bundle.main).instantiateViewController(withIdentifier: "BaseBudgetPopoverViewController") as! BaseBudgetPopoverViewController
                    popupController.modalPresentationStyle = UIModalPresentationStyle.popover
                    popupController.budgetCategory = self.budgetCategoryTitle
                    popupController.selectedBudgetEntity = budgetEntity
                    popupController.isNew = false
                    self.present(popupController, animated: true)
                }
            }
            frequencyMenu.addAction(UIAlertAction(title: option, style: .default, handler: actionHandler))
        }
        frequencyMenu.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) -> Void in
            BudgetManager.deleteBudgetEntity(budgetEntity: budgetEntity)
            self.dataTableView.reloadData()
            
        }))
        frequencyMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(frequencyMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func addField(_ sender: UIButton) {
        let popupController = UIStoryboard(name: "Setup", bundle    : Bundle.main).instantiateViewController(withIdentifier: "BaseBudgetPopoverViewController") as! BaseBudgetPopoverViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.budgetCategory = budgetCategoryTitle
        popupController.isNew = true
        self.present(popupController, animated: true)
    }
    
    
}

