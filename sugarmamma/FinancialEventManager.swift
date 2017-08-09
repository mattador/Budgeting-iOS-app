//
//  financialEventManager.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 7/5/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import CoreData

class FinancialEventManager: NSObject {
    
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
    
    class func create(_ financialEventRecord: Dictionary<String, Any>){
        if let appDelegate = getAppDelegate(){
            let financialEventEntity = FinancialEventModel(context: appDelegate.persistentContainer.viewContext)
            financialEventEntity.event_name = financialEventRecord["event"] as? String
            financialEventEntity.event_date =  financialEventRecord["date"] as? NSDate
            financialEventEntity.event_creation_date = Date() as NSDate
            financialEventEntity.amount =  financialEventRecord["amount"] as! Double
            financialEventEntity.type = financialEventRecord["type"] as? String
            appDelegate.saveContext()
        }
    }
    
    
    class func fetchBetweenRange(start:Date, end:Date) -> [FinancialEventModel]{
        var financialEvents = [FinancialEventModel]()
        if let appDelegate = getAppDelegate() {
            do{
                let request: NSFetchRequest<FinancialEventModel> = FinancialEventModel.fetchRequest()
                request.predicate = NSPredicate(format: "event_date >= %@ AND event_date <= %@", start as NSDate, end as NSDate)
                let context = appDelegate.persistentContainer.viewContext
                financialEvents = try context.fetch(request)
            }catch{
                //print(error.localizedDescription)
            }
        }
        return financialEvents
    }
    
    class func fetchByDate(date:Date) -> [FinancialEventModel]{
        var financialEvents = [FinancialEventModel]()
        if let appDelegate = getAppDelegate() {
            do{
                let request: NSFetchRequest<FinancialEventModel> = FinancialEventModel.fetchRequest()
                let startDate = Calendar.current.startOfDay(for: date)
                var dateComponent = DateComponents()
                dateComponent.day = 1
                let endDate = Calendar.current.date(byAdding: dateComponent, to: startDate)
                let predicate = NSPredicate(format: "event_date >= %@ AND event_date <= %@", startDate as NSDate, endDate! as NSDate)
                request.predicate = predicate
                let context = appDelegate.persistentContainer.viewContext
                financialEvents = try context.fetch(request)
                //print(financialEvents)
            }catch{
                //print(error.localizedDescription)
            }
        }
        return financialEvents
    }
    
    class func fetch() -> [FinancialEventModel]{
        var financialEvents = [FinancialEventModel]()
        if let appDelegate = getAppDelegate() {
            do{
                let request: NSFetchRequest<FinancialEventModel> = FinancialEventModel.fetchRequest()
                let context = appDelegate.persistentContainer.viewContext
                financialEvents = try context.fetch(request)
            }catch{
                //print(error.localizedDescription)
            }
        }
        return financialEvents
    }
    
    class func deleteEvent(_ event: FinancialEventModel) -> Void{
        if let appDelegate = getAppDelegate(){
            let context = appDelegate.persistentContainer.viewContext
            context.delete(event)
            appDelegate.saveContext()
        }
    }
    
    class func delete(_ format: String?) -> Void {
        if let appDelegate = getAppDelegate(){
            
            let request: NSFetchRequest<FinancialEventModel> = FinancialEventModel.fetchRequest()
            if format!.characters.count > 0{
                request.predicate = NSPredicate(format: format!)
            }
            let context = appDelegate.persistentContainer.viewContext
            do{
                let resultSet = try context.fetch(request)
                for event in resultSet{
                    context.delete(event)
                }
                appDelegate.saveContext()
            }catch{
                //print(error.localizedDescription)
                
            }
        }
    }
    
}

