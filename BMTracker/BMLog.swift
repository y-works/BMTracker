//
//  BMLog.swift
//  BMTracker
//
//  Created by 成田裕之 on 2017/11/27.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BMlogAccessor {
    let entityName = "BMLog"
    let attrDateTime = "dateTime"
    let attrBodyMass = "bodyMass"
    let attrPerson = "person"
    
    let context: NSManagedObjectContext
    
    init() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        context = appDel.persistentContainer.viewContext
    }
    
    func create(bm: Double, date: Date, person: Person) -> Bool {
        if let bmLog = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            let newRecord = NSManagedObject(entity: bmLog,
                                            insertInto: context)
            newRecord.setValue(bm, forKey: self.attrBodyMass)
            newRecord.setValue(date, forKey: self.attrDateTime)
            newRecord.setValue(bm, forKey: self.attrPerson)
            
            do {
                try context.save()
            } catch {
                print("Fail to BMlogAccessor.create. Can not save\n")
                return false
            }
        } else {
            print("Fail to BMlogAccessor.create. Entity is nil\n")
            return false
        }
        
        return true
    }
        
    func read(_ id: NSManagedObjectID) -> BMLog {
        return context.object(with: id) as! BMLog
    }
    
    func readAll() -> [BMLog] {
        let fetchRequest: NSFetchRequest<BMLog> = BMLog.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            return [BMLog]();
        }
    }
    
    func update(_ id: NSManagedObjectID, bm: Double, dateTime: Date, person: Person) -> Bool {
        let bmLog = context.object(with: id) as! BMLog
        bmLog.setValue(bm, forKey: attrBodyMass)
        bmLog.setValue(dateTime, forKey: attrDateTime)
        bmLog.setValue(person, forKey: attrPerson)
        
        do {
            try context.save()
        } catch {
            print("Fail to BMlogAccessor.update. Can not save.\n")
            return false
        }
        
        return true
    }
    
    func delete(object: BMLog) -> Bool {
        context.delete(object)
        
        do {
            try context.save()
        } catch {
            print("Fail to BMlogAccessor.delete. Can not save\n")
            return false
        }
        
        return true
    }
}
