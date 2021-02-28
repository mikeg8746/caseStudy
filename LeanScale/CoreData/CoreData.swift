//
//  CoreData.swift
//  LeanScale
//
//  Created by Mayank G on 27/02/21.
//  Copyright © 2021 Mayank G. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreData {
    static func saveViewedGame(id: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ViewedGame", in: context)
        let mainContext = NSManagedObject(entity: entity!, insertInto: context)
        mainContext.setValue(id, forKey: "id")
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    static func fetchViewedGames() -> Array<Int> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ViewedGame")
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.managedContext().fetch(request)
            return result.map { Int(($0 as AnyObject).id) }
        } catch {
            print("Fetching data Failed")
        }
        return []
    }
    
    static func managedContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    public static func saveFavouriteGame(game: GameData) {
        let context = self.managedContext()
        let entity = NSEntityDescription.entity(forEntityName: "FavGame", in: context)
        let favouriteGame = NSManagedObject(entity: entity!, insertInto: context)
        
        favouriteGame.setValue(game.id, forKey: "id")
        favouriteGame.setValue(game.name, forKey: "name")
        favouriteGame.setValue(game.metacritic, forKey: "metacritic")
        favouriteGame.setValue(game.backgroundImage, forKey: "backgroundImage")
        let favGenre = NSMutableSet()
        if let genres = game.genres {
            for genre in genres {
                let genreEntity = NSEntityDescription.insertNewObject(forEntityName: "FavGenre", into: context)
                genreEntity.setValue(genre.id, forKey: "id")
                genreEntity.setValue(genre.name, forKey: "name")
                favGenre.add(genreEntity)
            }
        }
        favouriteGame.setValue(favGenre, forKey: "favgenre")
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
    
    public static func fetchFavGaame() -> [FavGame] {
        let context = self.managedContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavGame")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            var results  = [FavGame]()
            results = try context.fetch(fetchRequest) as! [FavGame]
            return results
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    public static func removeFavGame(game: NSManagedObject) {
        let context = self.managedContext()
        context.delete(game as NSManagedObject)
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
}
