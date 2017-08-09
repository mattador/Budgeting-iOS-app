//
//  SavingGoalsPopupViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 10/6/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class SavingGoalsPopupViewController: BaseSetupControllerViewController {
    
    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var goalAmount: UITextField!
    @IBOutlet weak var goalDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var isNew: Bool = false
    var goalEntity: SavingGoalsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalAmount.placeholder = userModel.currency!
        if !isNew{
            if goalEntity!.amount > 0 {
                goalAmount.text = String(format: "%.2f", goalEntity!.amount)
                
            }else{
                goalAmount.text = ""
                
            }
            goalName.text = goalEntity?.goal_name
            goalDate.date = goalEntity!.goal_due_date! as Date
            goalDate.minimumDate = goalEntity!.goal_creation_date as Date?
            saveButton.setTitle("Update", for: .normal)
        }else{
            goalDate.minimumDate = Date()
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func saveGoal(_ sender: UIButton) {
        if goalName.text != "" && goalAmount.text != ""{
            let amount = Double(goalAmount.text!) ?? 0.0
            //print(goalDate.date)
            if isNew{
                SavingGoalsManager.create(
                    [
                        "goal": goalName.text!,
                        "amount": amount,
                        "date": goalDate.date
                    ]
                )
                AnalyticsHelper.notifyEvent(category: "user_event", action: "savings_goal_created", label: "Savings Goal created")
            }else{
                goalEntity!.amount = amount
                goalEntity!.goal_name = goalName.text
                goalEntity!.goal_due_date = goalDate.date as NSDate?
                AnalyticsHelper.notifyEvent(category: "user_event", action: "savings_goal_updated", label: "Savings Goal updated")
            }
            SavingGoalsManager.persistContext()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func deleteGoal(_ sender: UIButton) {
        //activate popup confirmation
        let alert = UIAlertController(title: "Are you sure you wish to delete this goal?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {action in
            SavingGoalsManager.deleteGoal(goal: self.goalEntity!)
            AnalyticsHelper.notifyEvent(category: "user_event", action: "savings_goal_deleted", label: "Savings Goal deleted")
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeEvent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
