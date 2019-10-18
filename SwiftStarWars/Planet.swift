//
//  Planet.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 10/17/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation

struct Planet: Codable {
    var name: String
    var diameter: String
    var rotationPeriod: String
    var orbitalPeriod: String
    var gravity: String
    var population: String
    var climate: String
    var terrain: String
    var surfaceWater: String
    var residents: [URL]
    var films: [URL]
    var url: String
    var created: Date
    var edited: Date
}
