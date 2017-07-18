//
//  FinancialEventsPopupViewController.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 10/6/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit

class FinancialEventsPopupViewController: BaseSetupControllerViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventAmount: UITextField!
    @IBOutlet weak var eventAddButton: UIButton!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventTypePicker: UIPickerView!
    @IBOutlet weak var eventDeleteButton: UIButton!
    
    var eventTypes = ["Income", "Expense"]
    var isNew: Bool = false
    var eventEntity: FinancialEventModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventAmount.placeholder = userModel.currency!
        if !isNew{
            eventName.text = eventEntity!.event_name
            if eventEntity!.amount > 0 {
                eventAmount.text = String(format: "%.2f", eventEntity!.amount)
            }else{
                eventAmount.text = ""
            }
            if let eventTypeIndex = eventTypes.index(of: eventEntity!.type!.capitalized){
                eventTypePicker.selectRow(eventTypeIndex, inComponent: 0, animated: true)
            }
            eventDatePicker.date = eventEntity!.event_date! as Date
            eventDatePicker.minimumDate = eventEntity!.event_creation_date as Date?
            eventAddButton.setTitle("Update", for: .normal)
        }else{
            eventDatePicker.minimumDate = Date()
            eventAddButton.setTitle("Create", for: .normal)
            eventDeleteButton.isHidden = true
        }
        eventAmount.keyboardType = UIKeyboardType.decimalPad
        eventAmount.placeholder = userModel.currency!
    }
    
    @IBAction func closeEvent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEvent(_ sender: UIButton) {
        if eventName.text != "" && eventAmount.text != ""{
            let amountDouble = Double(eventAmount.text!) ?? 0.00
            if isNew{
                FinancialEventManager.create([
                    "event" : eventName.text!,
                    "amount" : amountDouble,
                    "date" : eventDatePicker.date,
                    "type" : eventTypes[eventTypePicker.selectedRow(inComponent: 0)].lowercased()
                    ])
            }else{
                eventEntity?.amount = amountDouble
                eventEntity?.event_name = eventName.text!
                eventEntity?.event_date = eventDatePicker.date as NSDate?
                eventEntity?.type = eventTypes[eventTypePicker.selectedRow(inComponent: 0)].lowercased()
            }
            FinancialEventManager.persistContext()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteEvent(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you wish to delete this event?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {action in
            FinancialEventManager.deleteEvent(self.eventEntity!)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return eventTypes.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return eventTypes[row]
    }
    
}
