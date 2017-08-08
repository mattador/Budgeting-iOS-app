//
//  IncomeViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 25/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class FinancialEventsViewController: BaseSetupControllerViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    var eventTypes = ["Income", "Expense"]
    var sectionHeaders: [String] = [""]
    var sectionContent: [[FinancialEventModel]] {get{
        return [
            FinancialEventManager.fetch()
        ]
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataTableView.reloadData()
        collectTotals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsHelper.notifyScreen("Financial Events")
    }
    
    @IBAction func eventChangeAction(_ sender: UIButton) {
        let indexPath = getIndexPathRelativeToUIView(sender)
        let financialEventEntity = self.sectionContent[(indexPath?.section)!][(indexPath?.row)!]
        let popupController = UIStoryboard(name: "Setup", bundle    : Bundle.main).instantiateViewController(withIdentifier: "FinancialEventsPopupViewController") as! FinancialEventsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.eventEntity = financialEventEntity
        popupController.isNew = false
        self.present(popupController, animated: true)
        
    }
    
    @IBAction func eventCreateAction(_ sender: UIButton) {
        let popupController = UIStoryboard(name: "Setup", bundle    : Bundle.main).instantiateViewController(withIdentifier: "FinancialEventsPopupViewController") as! FinancialEventsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.isNew = true
        self.present(popupController, animated: true)
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
        let cellIdentifier = "FinancialEventTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FinancialEventTableViewCell
        cell.eventAmountField.delegate = self
        //cell.eventDateField.delegate = self
        let cellContent = sectionContent[indexPath.section][indexPath.row]
        //restore store values
        if cellContent.amount > 0{
            cell.eventAmountField.text = String(format: "%.2f", cellContent.amount)
        }else{
            cell.eventAmountField.text = ""
        }
        cell.eventNameLabel.text = cellContent.event_name
        if let eventDate = cellContent.event_date {
            cell.eventDateField.setTitle(DateHelper.toString(eventDate as Date, dateFormat: "d/M/yyyy"), for: .normal)
        }
        
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
            let financialEventEntity = sectionContent[indexPath.section][indexPath.row]
            if let financialEventAmount = textField.text{
                if let double = Double(financialEventAmount){
                    textField.text = String(format: "%.2f", double)
                    financialEventEntity.amount = double
                    FinancialEventManager.persistContext()
                    collectTotals()
                }
            }
        }
    }
    
}

