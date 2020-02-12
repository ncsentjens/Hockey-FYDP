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
    
    static func deleteAllSessionModels() {
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
    
    static func fetchSessionStats() -> ([SessionViewModel], HistoricalStatsViewModel) {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SessionDataModel")
        
        let sessionModels = (try? managedContext.fetch(fetchRequest)) ?? []
        let sessionViewModels: [SessionViewModel] = sessionModels.map { sessionModel -> SessionViewModel in
            let sessionDictionary = sessionModel.dictionaryWithValues(forKeys: ["shots", "goals", "date", "reactionTime", "shotSpeed", "fastestShot", "quickestReactionTime"])
            let shots = sessionDictionary["shots"] as! Int
            let goals = sessionDictionary["goals"] as! Int
            let date = sessionDictionary["date"] as! Date
            let reactionTime = sessionDictionary["reactionTime"] as! Float
            let shotSpeed = sessionDictionary["shotSpeed"] as! Float
            let fastestShot = sessionDictionary["fastestShot"] as! Float
            let quickestReactionTime = sessionDictionary["quickestReactionTime"] as! Float
            return SessionViewModel(shots: shots,
                                    goals: goals,
                                    averageShotSpeed: shotSpeed,
                                    averageReactionTime: reactionTime,
                                    fastestShot: fastestShot,
                                    quickestReactionTime: quickestReactionTime,
                                    sessionDate: date)
        }
        
        let numberOfSessions = sessionViewModels.count
        var totalGoals: Int = 0
        var totalShots: Int = 0
        var averageShotSpeed: Float = 0
        var averageReactionTime: Float = 0
        var fastestShot: Float = 0.0
        var quickestReactionTime: Float = 10.0
        sessionViewModels.forEach { (sessionViewModel) in
            totalGoals += sessionViewModel.goals
            totalShots += sessionViewModel.shots
            averageShotSpeed += sessionViewModel.averageShotSpeed
            averageReactionTime += sessionViewModel.averageReactionTime
            if sessionViewModel.fastestShot > fastestShot {
                fastestShot = sessionViewModel.fastestShot
            }
            if (sessionViewModel.quickestReactionTime < quickestReactionTime) {
                quickestReactionTime = sessionViewModel.quickestReactionTime
            }
        }
        
        let historicalStatsViewModel = HistoricalStatsViewModel(
            shotSpeed: averageShotSpeed/Float(numberOfSessions),
            shots: totalShots,
            goals: totalGoals,
            reactionTime: averageReactionTime/Float(numberOfSessions),
            fastestShot: fastestShot,
            quickestReactionTime: quickestReactionTime
        )
        return (sessionViewModels, historicalStatsViewModel)
    }
    
    static func saveSessionModel(model: SessionViewModel) {
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
