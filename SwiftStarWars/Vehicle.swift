//
//  Vehicle.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 10/17/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation

struct Vehicle: Codable {
    var name: String
    var model: String
    var vehicleClass: String
    var manufacturer: String
    var costInCredits: String
    var length: String
    var crew: String
    var passengers: String
    var maxAtmospheringSpeed: String
    var cargoCapacity: String
    var consumables: String
    var films: [URL]
    var pilots: [URL]
    var url: String
    var created: Date
    var edited: Date
}
