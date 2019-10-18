//
//  People.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 10/17/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import SwiftUI
import CoreData

struct Person: Codable {
    var name: String
    var birthYear: String
    var eyeColor: String
    var gender: String
    var hairColor: String
    var height: String
    var mass: String
    var skinColor: String
    var homeworld: URL
    var films: [URL]
    var species: [URL]
    var starships: [URL]
    var vehicles: [URL]
    var url: String
    var created: Date
    var edited: Date
}

struct People: Codable {    
    var count: Int
    var next: URL?
    var previous: URL?
    var results: [Person]
}

extension CoreDataPerson {
    static func create(in managedObjectContext: NSManagedObjectContext, person: Person) {
        let newPerson = self.init(context: managedObjectContext)
        newPerson.name = person.name
        newPerson.birthYear = person.birthYear
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension Collection where Element == CoreDataPerson, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }
 
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
