//
//  CoreDataManager.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 24/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import CoreData

class BudgetManager: NSObject {
    
    class func getAppDelegate()->AppDelegate?{
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            return appDelegate
        }
        return nil
    }
    
    class func install(){
        //purge existing data
        delete("")
        
        let todaysDate = Date()
        //populate data store
        let initialBudgetRecords: [Dictionary<String, Any>] = [
            ["category" : "salary", "amount" : 0.00, "name" : "salary", "label" : "Salary after tax", "type" : "income", "system": true, "start_date" : todaysDate],
            ["category" : "passive_income", "amount" : 0.00, "name" : "rental_property", "label" : "Rental property", "type" : "income", "system": true, "start_date": todaysDate],
            ["category" : "passive_income", "amount" : 0.00, "name" : "dividends", "label" : "Dividends", "type" : "income", "system": true, "start_date": todaysDate],
            ["category" : "loans", "amount" : 0.00, "name" : "mortage_rent", "label" : "Mortage repayment / rent payment", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "loans", "amount" : 0.00, "name" : "investment_loan", "label" : "Investment loan", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "loans", "amount" : 0.00, "name" : "car_loan", "label" : "Car loan", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "loans", "amount" : 0.00, "name" : "education_debt", "label" : "Student debt / HECS/HELP repayment", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "loans", "amount" : 0.00, "name" : "credit_cards", "label" : "Credit cards repayment plan", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "land_rates", "label" : "Land Rates", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "council_rates", "label" : "Council Rates", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "water", "label" : "Water", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "gas", "label" : "Gas", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "electricity", "label" : "Electricity", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "strata", "label" : "Strata", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "insurance", "label" : "Home and content insurance", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "maintenance", "label" : "Repairs and maintenance", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "internet", "label" : "Internet", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "pool", "label" : "Pool expenses", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "garden", "label" : "Garden expenses", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "cleaning", "label" : "Cleaning services", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "home_expenses", "amount" : 0.00, "name" : "cable_tv", "label" : "Cable TV", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "transport", "amount" : 0.00, "name" : "petrol", "label" : "Petrol", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "transport", "amount" : 0.00, "name" : "fines", "label" : "Fines", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "transport", "amount" : 0.00, "name" : "car_insurance", "label" : "Car insurances (CTP)", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "transport", "amount" : 0.00, "name" : "car_repairs", "label" : "Car repairs & services", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "transport", "amount" : 0.00, "name" : "license", "label" : "License", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "transport", "amount" : 0.00, "name" : "cabs", "label" : "Cabs", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "transport", "amount" : 0.00, "name" : "rego", "label" : "Rego", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "education", "amount" : 0.00, "name" : "higher_learning", "label" : "Higher learning", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "education", "amount" : 0.00, "name" : "books", "label" : "Books", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "medical", "amount" : 0.00, "name" : "private_health_cover", "label" : "Private health cover", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "medical", "amount" : 0.00, "name" : "doctor", "label" : "Doctor visits", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "medical", "amount" : 0.00, "name" : "dentist", "label" : "Dentist visits", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "medical", "amount" : 0.00, "name" : "optometrist", "label" : "Optometrist", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "medical", "amount" : 0.00, "name" : "chemist_medicine", "label" : "Chemist / Medicine", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "medical", "amount" : 0.00, "name" : "alt_therapies", "label" : "Alternate Therapies", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "medical", "amount" : 0.00, "name" : "vet", "label" : "Pet & vet", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "clothing", "label" : "Clothing", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "mobile_phone", "label" : "Mobile phone", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "hair", "label" : "Haircuts & care", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "cosmetics", "label" : "Cosmetics", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "beauty", "label" : "Beauty services", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "newspapers", "label" : "Newspapers", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "gaming", "label" : "Gaming", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "movies", "label" : "DVDs & movies", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "drycleaning", "label" : "Dry cleaning", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "charity", "label" : "Charity & donations", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "magazines", "label" : "Magazines", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "alcohol", "label" : "Alcohol", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "social", "label" : "Social life", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "holidays", "label" : "Holidays", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "gifts", "label" : "Gifts", "type" : "expense", "system": true, "start_date": todaysDate],
            ["category" : "personal", "amount" : 0.00, "name" : "gym", "label" : "Gym membership", "type" : "expense", "system": true, "start_date": todaysDate]
        ]
        
        for budgetRecord in initialBudgetRecords{
            create(budgetRecord)
        }
    }
    
    class func create(_ budgetRecord: Dictionary<String, Any>){
        if let appDelegate = getAppDelegate(){
            let budgetEntity = BudgetModel(context: appDelegate.persistentContainer.viewContext)
            budgetEntity.amount = budgetRecord["amount"] as! Double
            budgetEntity.category = budgetRecord["category"] as? String
            budgetEntity.frequency = budgetRecord["frequency"] as? String
            budgetEntity.name = budgetRecord["name"] as? String
            budgetEntity.label = budgetRecord["label"] as? String
            budgetEntity.type = budgetRecord["type"] as? String
            budgetEntity.system = budgetRecord["system"] as! Bool
            budgetEntity.start_date = budgetRecord["start_date"] as? NSDate
            appDelegate.saveContext()
        }
    }
    
    class func persistContext(){
        if let appDelegate = getAppDelegate(){
            appDelegate.saveContext()
        }
    }
    
    class func fetchAll() -> [BudgetModel] {
        var budget = [BudgetModel]()
        if let appDelegate = getAppDelegate() {
            do{
                let request: NSFetchRequest<BudgetModel> = BudgetModel.fetchRequest()
                let context = appDelegate.persistentContainer.viewContext
                budget = try context.fetch(request)
            }catch{
                //print(error.localizedDescription)
            }
        }
        return budget
    }
    
    class func fetch(_ type: String, entityCategory category : String) -> [BudgetModel]{
        var budget = [BudgetModel]()
        if let appDelegate = getAppDelegate() {
            do{
                let request: NSFetchRequest<BudgetModel> = BudgetModel.fetchRequest()
                request.predicate = NSPredicate(format: "category LIKE %@ AND type = %@", category, type)
                //        predicate = NSPredicate(format: "by == %@" , "wang")
                //        predicate = NSPredicate(format: "year > %@", "2012")
                // "category contains[c] %@", "home_expenses"
                let context = appDelegate.persistentContainer.viewContext
                
                budget = try context.fetch(request)
            }catch{
                //print(error.localizedDescription)
            }
        }
        return budget
    }
    
    class func delete(_ format: String?) -> Void {
        if let appDelegate = getAppDelegate() {
            do{
                let request: NSFetchRequest<BudgetModel> = BudgetModel.fetchRequest()
                if format!.characters.count > 0{
                    request.predicate = NSPredicate(format: format!)
                }
                let context = appDelegate.persistentContainer.viewContext
                let resultSet = try context.fetch(request)
                for budget in resultSet{
                    context.delete(budget)
                }
                appDelegate.saveContext()
                //print("deleted")
            }catch{
                //print(error.localizedDescription)
            }
        }
    }
    
    class func deleteBudgetEntity(budgetEntity: BudgetModel) -> Void {
        if let appDelegate = getAppDelegate() {
            let context = appDelegate.persistentContainer.viewContext
            context.delete(budgetEntity)
            appDelegate.saveContext()
            //print("deleted")
        }
    }
    
    class func collectTotals() -> [String: Double] {
        var totals = ["income": 0.0, "expenses": 0.0, "deficit": 0.0]
        if let appDelegate = getAppDelegate() {
            do{
                //"Weekly", "Fortnightly", "Monthly", "Quarterly", "Half-yearly", "Yearly"
                let request: NSFetchRequest<BudgetModel> = BudgetModel.fetchRequest()
                request.predicate = NSPredicate(format: "amount > 0")
                let context = appDelegate.persistentContainer.viewContext
                let budgetCollection = try context.fetch(request)
                for budgetEntity in budgetCollection{
                    //display amount as per year
                    if let frequency = budgetEntity.frequency{
                        var amount = budgetEntity.amount
                        switch(frequency){
                        case "Yearly":
                            //no change required
                            break
                        case "Half-yearly":
                            amount = amount * 2
                            break
                        case "Quarterly":
                            amount = amount * 4
                            break
                        case "Monthly":
                            amount = amount * 12
                            break
                        case "Fortnightly":
                            amount = amount * 26
                            break
                        case "Weekly":
                            amount = amount * 52
                            break
                        default:
                            break
                        }
                        switch budgetEntity.type! {
                        case "income":
                            totals["income"] = totals["income"]! + amount
                        case "expense":
                            totals["expenses"] = totals["expenses"]! + amount
                        default:
                            break
                        }
                    }                                    }
            }catch{
                //print(error.localizedDescription)
            }
        }
        totals["deficit"] = totals["income"]! - totals["expenses"]!
        //print(totals)
        return totals
    }
    
}
