//
//  DBManagerTests.swift
//  HomeAssignment
//
//  Created by Hrishbha Jain on 30/03/25.
//

import XCTest
import CoreData
@testable import HomeAssignment

class DBManagerTests: XCTestCase {
    
    var dbManager: DBManager!
    var mockPersistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()

        let modelName = "Database"
        
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            XCTFail("Failed to load Core Data Model")
            return
        }

        mockPersistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockPersistentContainer.persistentStoreDescriptions = [description]

        let expectation = XCTestExpectation(description: "Load persistent stores")
        
        mockPersistentContainer.loadPersistentStores { (storeDescription, error) in
            XCTAssertNil(error, "Error loading in-memory Core Data store: \(error?.localizedDescription ?? "")")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

        dbManager = DBManager(forTesting: mockPersistentContainer)
    }

    
    override func tearDown() {
        clearData()
        dbManager = nil
        super.tearDown()
    }
    
    /// Helper function to clear the in-memory database
    private func clearData() {
        let context = mockPersistentContainer.viewContext
        let entities = ["Movie"]

        do {
            for entity in entities {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                
                results?.forEach { context.delete($0) }
            }
            try context.save()
        } catch {
            XCTFail("Failed to clear Core Data: \(error.localizedDescription)")
        }
    }


    
    // Test adding a movie to favorites
    func testAddToFavorites() {
        let movieID: Int64 = 123
        let movieTitle = "Test Movie"

        dbManager.addToFavorites(title: movieTitle, id: movieID)

        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", movieID)

        do {
            let movies = try mockPersistentContainer.viewContext.fetch(fetchRequest)
            XCTAssertEqual(movies.count, 1, "Movie should be saved in Core Data")
            XCTAssertEqual(movies.first?.title, movieTitle, "Movie title should match")
        } catch {
            XCTFail("Fetch failed: \(error.localizedDescription)")
        }
    }

    
    //  Test removing a movie from favorites
    func testRemoveFromFavorites() {
        let movieID: Int64 = 456
        dbManager.addToFavorites(title: "Another Test Movie", id: movieID)

        dbManager.removeFromFavorites(id: movieID)

        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", movieID)

        do {
            let movies = try mockPersistentContainer.viewContext.fetch(fetchRequest)
            XCTAssertEqual(movies.count, 0, "Movie should be deleted from Core Data")
        } catch {
            XCTFail("Fetch failed: \(error.localizedDescription)")
        }
    }

    
    //  Test checking if a movie is favorited
    func testIsMovieFavorited() {
        let movieID: Int64 = 789

        XCTAssertFalse(dbManager.isMovieFavorited(id: movieID), "Movie should not be favorited before adding")

        dbManager.addToFavorites(title: "Favorite Movie", id: movieID)

        XCTAssertTrue(dbManager.isMovieFavorited(id: movieID), "Movie should be marked as favorited after adding")
    }

}
