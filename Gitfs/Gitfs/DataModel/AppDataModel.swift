//
//  AppDataModel.swift
//  Gitfs
//
//  Created by Sagar Arora on 17/05/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataConstants: NSObject {
    static let coreDataModelName = "Gitfs"
    static let cdEntityGifs = "Favorites"
}

class DataManager: NSObject {
    static let constAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let managedContext = constAppDelegate.managedObjectContext
    
    private static let modelName = "Favorites"
    public static let shared = DataManager()
    private override init() {}
    
    static func saveMyGif(_ gif: Gifs) {
        let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: managedContext)!
        
        let favorites = Favorites(entity: entity, insertInto: managedContext)
        favorites.id = gif.id
        favorites.gif = gif
        
        do {
            print("Saving session... \(gif.id)")
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to save session data! \(error): \(error.userInfo)")
        }
    }
    
    static func retrieveMyGifs() -> [Gifs] {
        let fetchRequest : NSFetchRequest<Favorites> = NSFetchRequest(entityName: self.modelName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            var gifs: [Gifs] = []
            for data in result {
                let gif = data.gif as! Gifs
                gif.isFavorite = true
                gifs.append(gif)
            }
            
            return gifs
        } catch let error as NSError {
            print("Retrieving user failed. \(error): \(error.userInfo)")
           return []
        }
    }
    
    static func deleteGif(_ gif: Gifs) {
        let fetchRequest : NSFetchRequest<Favorites> = NSFetchRequest(entityName: self.modelName)
        fetchRequest.predicate = NSPredicate(
            format: "id=%@", gif.id
        )
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let data = result.first {
                managedContext.delete(data)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Retrieving data failed. \(error): \(error.userInfo)")
        }
    }
}
