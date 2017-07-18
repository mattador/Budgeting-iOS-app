//
//  ProfileSettingsDataManager.swift
//  sugarmamma
//
//  Created by Matthew Cooper on 27/4/17.
//  Copyright © 2017 Debug That. All rights reserved.
//

import UIKit
import CoreData

class UserManager: NSObject {
    
    
    class func persistContext() -> Void{
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
         }
    }
    
    class func create(_ name: String) -> Bool{
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let userEntity = UserModel(context: appDelegate.persistentContainer.viewContext)
            userEntity.name = name
            userEntity.profile_complete = false
            userEntity.version_installed = CURRENT_VERSION
            appDelegate.saveContext()
            return true
        }
        return false
    }
    
    class func delete(_ format: String?) -> Void {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<UserModel> = UserModel.fetchRequest()
            if format!.characters.count > 0{
                request.predicate = NSPredicate(format: format!)
            }
            let context = appDelegate.persistentContainer.viewContext
            do{
                let resultSet = try context.fetch(request)
                for budget in resultSet{
                    context.delete(budget)
                }
                appDelegate.saveContext()
            }catch{
                //print(error.localizedDescription)
            }
        }
    }
    
    class func fetch() -> UserModel?{
        let user: UserModel? = nil
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            do{
                let request: NSFetchRequest<UserModel> = UserModel.fetchRequest()
                //request.predicate = NSPredicate(format: "category LIKE %@ AND type = %@", category, type)
                let context = appDelegate.persistentContainer.viewContext
                var users = try context.fetch(request)
                if users.count > 0{
                    return users[0]
                }
            }catch{
                //print(error.localizedDescription)
            }
        }
        return user
    }
    
}
