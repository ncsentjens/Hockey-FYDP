//
//  CoreDataManager.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2020-01-28.
//  Copyright © 2020 NickSentjens. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    
    func deleteAllSessionModels() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SessionDataModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }
    
    func saveSessionModel(model: SessionViewModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SessionDataModel",
                                     in: managedContext)!
        
        let session = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        session.setValue(model.shots, forKeyPath: "shots")
        session.setValue(model.goals, forKeyPath: "goals")
        session.setValue(model.averageShotSpeed, forKeyPath: "shotSpeed")
        session.setValue(model.sessionDate, forKeyPath: "date")
        session.setValue(model.averageReactionTime, forKeyPath: "reactionTime")
        session.setValue(model.fastestShot, forKey: "fastestShot")
        session.setValue(model.quickestReactionTime, forKey: "quickestReactionTime")
        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
