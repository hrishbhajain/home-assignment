//
//  DBManager.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 29/03/25.
//

import CoreData
import UIKit

class DBManager {
    
    static let shared = DBManager()

    private var persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    init(forTesting container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Movie to Core Data
    func addToFavorites(title: String, id: Int64) {
        let movieEntity = Movie(context: context)
        movieEntity.id = id
        movieEntity.title = title
        do {
            try context.save()
        } catch {
            print("Failed to save movie: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete Movie from Core Data
    func removeFromFavorites(id: Int64) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        do {
            if let movie = try context.fetch(fetchRequest).first {
                context.delete(movie)
                try context.save()
            }
        } catch {
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }

    // MARK: - Check if a Movie is Favorited
    func isMovieFavorited(id: Int64) -> Bool {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        do {
            let movies = try context.fetch(fetchRequest)
            return !movies.isEmpty
        } catch {
            print("Failed to check movie: \(error.localizedDescription)")
            return false
        }
    }
}
