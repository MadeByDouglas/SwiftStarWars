//
//  DataManager.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 10/17/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import CoreData

class DataManager: NSObject {
    static var shared = DataManager()
    
    
    let network = NetworkManager()
    
    func savePeopleFromServer(viewContext: NSManagedObjectContext) {
        network.getAllPeople { (result) in
            switch result {
            case .success(let people):
                
                //TODO: check for existing items in core data and only update as necessary.
                
                for person in people.results {
                    CoreDataPerson.create(in: viewContext, person: person)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
