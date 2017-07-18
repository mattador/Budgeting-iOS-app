//
//  BaseBudgetPopoverViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 9/6/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class BaseBudgetPopoverViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var calendarPicker: MonthYearPickerControl!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    var frequencyOptions: [String] = ["Weekly", "Fortnightly", "Monthly", "Quarterly", "Half-yearly", "Yearly"]
    var selectedBudgetEntity: BudgetModel? = nil
    var budgetCategory: String = ""
    var isNew: Bool = false
    
    
    let categoryOptionKeys: [String: [String]] = [
        "Income":["salary", "passive_income"],
        "Loans & repayments":["loans", "home_expenses"],
        "Services":["transport", "medical", "education"],
        "Personal":["personal"]
    ]
    var categoryOptionValues: [String: [String]] = [
        "Income":["Salary", "Passive income"],
        "Loans & repayments":["Loans", "Home expenses"],
        "Services":["Transport", "Medical", "Education"],
        "Personal":["Personal"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTitleLabel.text = budgetCategory
        if isNew{
            deleteButton.isHidden = true
        }else{
            saveButton.setTitle("Update", for: .normal)
        }
        if selectedBudgetEntity != nil{
            //if selectedBudgetEntity!.system {
            //categoryPicker.isUserInteractionEnabled = false
            //}
            titleField.text = selectedBudgetEntity?.label
            if selectedBudgetEntity!.amount > 0.0{
                amountField.text = String(format: "%.2f", selectedBudgetEntity!.amount)
            }else{
                amountField.text = ""
            }
            if !isNew{
                var frequencyPickerSelected = false
                if let frequencyOption = selectedBudgetEntity?.frequency{
                    if let frequencyOptionIndex = frequencyOptions.index(of: frequencyOption){
                        frequencyPicker.selectRow(frequencyOptionIndex, inComponent: 0, animated: true)
                        frequencyPickerSelected = true
                    }
                }
                if !frequencyPickerSelected{
                    frequencyPicker.selectRow(0, inComponent: 0, animated: true)
                }
                var categoryPickerSelected = false
                if let categoryOption = selectedBudgetEntity?.category{
                    if let categoryOptionIndex = categoryOptionKeys[budgetCategory]!.index(of: categoryOption){
                        categoryPicker.selectRow(categoryOptionIndex, inComponent: 0, animated: true)
                        categoryPickerSelected = true
                    }
                }
                if !categoryPickerSelected{
                    categoryPicker.selectRow(0, inComponent: 0, animated: true)
                }
                if let startDate = selectedBudgetEntity?.start_date{
                    calendarPicker.month = Int(DateHelper.toString(startDate as Date, dateFormat: "MM"))!
                    calendarPicker.year = Int(DateHelper.toString(startDate as Date, dateFormat: "yyyy"))!
                }
            }
        }
    }
    
    @IBAction func closePopupAction(_ sender: UIButton) {
        closePopup()
    }
    func closePopup(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteField(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you wish to delete this Field?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {action in
            BudgetManager.deleteBudgetEntity(budgetEntity: self.selectedBudgetEntity!)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveField(_ sender: UIButton) {
        if let label = titleField.text{
            if label.isEmpty{
                return
            }
            var type = ""
            switch budgetCategory {
            case "Income":
                type = "income"
                break
            case "Loans & repayments":
                type = "expense"
                break
            case "Services":
                type = "expense"
                break
            case "Personal":
                type = "expense"
                break
            default:
                break
            }
            let amountDouble = Double(amountField.text!) ?? 0.00
            var selectedDate: Date = Date()
            if let date = DateHelper.toDate("01/\(calendarPicker.month)/\(calendarPicker.year) 00:00:00 +0000", dateFormat: "dd/MM/yyyy HH:mm:ss Z"){
                selectedDate = date
            }
            if isNew{
                BudgetManager.create(
                    [
                        "category" : categoryOptionKeys[budgetCategory]![categoryPicker.selectedRow(inComponent: 0)],
                        "amount" : amountDouble,
                        "name" : "custom_field_" + GlobalVariables.randomString(10),
                        "label" : label,
                        "type" : type,
                        "frequency": frequencyOptions[frequencyPicker.selectedRow(inComponent: 0)],
                        "start_date": selectedDate as NSDate,
                        "system": false
                    ]
                )
            }else{
                selectedBudgetEntity?.label = titleField.text
                selectedBudgetEntity?.amount = amountDouble
                selectedBudgetEntity?.category = categoryOptionKeys[budgetCategory]![categoryPicker.selectedRow(inComponent: 0)]
                selectedBudgetEntity?.frequency = frequencyOptions[frequencyPicker.selectedRow(inComponent: 0)]
                selectedBudgetEntity?.start_date = selectedDate as NSDate
            }
            BudgetManager.persistContext()
            closePopup()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView.tag == 1{
            return categoryOptionValues[budgetCategory]!.count
        }else{
            return frequencyOptions.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView.tag == 1{
            return categoryOptionValues[budgetCategory]![row]
        }else{
            return frequencyOptions[row]
        }
    }
    
}
