//
//  savingGoalsManager.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 7/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import CoreData

class SavingGoalsManager: NSObject {
    
    class func getAppDelegate()->AppDelegate?{
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            return appDelegate
        }
        return nil
    }
    
    class func persistContext(){
        if let appDelegate = getAppDelegate(){
            appDelegate.saveContext()
        }
    }
    
    class func create(_ savingGoalsRecord: Dictionary<String, Any>){
        if let appDelegate = getAppDelegate(){
            let savingGoalsEntity = SavingGoalsModel(context: appDelegate.persistentContainer.viewContext)
            savingGoalsEntity.goal_name = savingGoalsRecord["goal"] as? String
            savingGoalsEntity.goal_creation_date = Date() as NSDate
            savingGoalsEntity.goal_due_date =  savingGoalsRecord["date"] as? NSDate
            savingGoalsEntity.amount =  savingGoalsRecord["amount"] as! Double
            appDelegate.saveContext()
        }
    }
    
    class func fetch() -> [SavingGoalsModel]{
        var savingGoals = [SavingGoalsModel]()
        if let appDelegate = getAppDelegate() {
            do{
                let request: NSFetchRequest<SavingGoalsModel> = SavingGoalsModel.fetchRequest()
                let context = appDelegate.persistentContainer.viewContext
                savingGoals = try context.fetch(request)
            }catch{
                //print(error.localizedDescription)
            }
        }
        return savingGoals
    }
    
    class func deleteGoal(goal: SavingGoalsModel){
        if let appDelegate = getAppDelegate(){
            let context = appDelegate.persistentContainer.viewContext
            context.delete(goal)
            appDelegate.saveContext()
            
        }
    }
    
    class func delete(_ format: String?) -> Void {
        if let appDelegate = getAppDelegate(){
            
            let request: NSFetchRequest<SavingGoalsModel> = SavingGoalsModel.fetchRequest()
            if format!.characters.count > 0{
                request.predicate = NSPredicate(format: format!)
            }
            let context = appDelegate.persistentContainer.viewContext
            do{
                let resultSet = try context.fetch(request)
                for goal in resultSet{
                    context.delete(goal)
                }
                appDelegate.saveContext()
            }catch{
                //print(error.localizedDescription)
                
            }
        }
    }
    
}

