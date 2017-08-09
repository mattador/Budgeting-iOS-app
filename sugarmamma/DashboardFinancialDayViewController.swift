//
//  DashboardFinancialDayViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 27/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class DashboardFinancialDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var financialDayDateLabel: UILabel!
    
    @IBOutlet weak var eventDataTableView: UITableView!
    
    var blurredEffect: UIVisualEffectView?
    var financialDayDate: Date?
    var events: [FinancialEventModel] = []
    var justLoaded: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        justLoaded = true
        financialDayDateLabel.text = DateHelper.toString(financialDayDate!, dateFormat: "dd MMMM")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !justLoaded{
            reloadData()
        }else{
            justLoaded = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func reloadData(){
        events = FinancialEventManager.fetchByDate(date: financialDayDate!)
        if events.count == 0{
            //print("no events found for \(financialDayDate!)")
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return events.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FinancialEventDateSpecificTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FinancialEventDateSpecificTableViewCell
        cell.eventAmountField.delegate = self
        var cellContent: FinancialEventModel
        cellContent = events[indexPath.row]
        //restore store values
        if cellContent.amount > 0{
            cell.eventAmountField.text = String(format: "%.2f", cellContent.amount)
        }
        cell.eventNameLabel.text = cellContent.event_name! + " (" + cellContent.type! + ")"
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func removeEventAction(_ sender: UIButton) {
        if let indexPath = GlobalVariables.getIndexPathRelativeToUIView(sender, recursionLimit: 10){
            let eventEntity = events[indexPath.row]
            FinancialEventManager.deleteEvent(eventEntity)
            reloadData()
            eventDataTableView.beginUpdates()
            eventDataTableView.deleteRows(at: [indexPath], with: .automatic)
            eventDataTableView.endUpdates()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if let indexPath = GlobalVariables.getIndexPathRelativeToUIView(textField, recursionLimit: 10){
            let eventEntity: FinancialEventModel = events[indexPath.row]
            //print(eventEntity)
            if let eventAmount = textField.text{
                //print("raw event emount is \(eventAmount)")
                if let double = Double(eventAmount){
                    textField.text = String(format: "%.2f", double)
                    eventEntity.amount = double
                    FinancialEventManager.persistContext()
                }else{
                  //print("fuck, couldn't convert input to double")
                }
            }
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    @IBAction func eventCreateAction(_ sender: UIButton) {
        let popupController = UIStoryboard(name: "Setup", bundle    : Bundle.main).instantiateViewController(withIdentifier: "FinancialEventsPopupViewController") as! FinancialEventsPopupViewController
        popupController.modalPresentationStyle = UIModalPresentationStyle.popover
        popupController.isNew = true
        self.present(popupController, animated: true)
    }
    
}
