//
//  Species.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 10/17/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation

struct Species: Codable {
    var name: String
    var classification: String
    var designation: String
    var averageHeight: String
    var averageLifespan: String
    var eyeColors: String
    var hairColors: String
    var skinColors: String
    var language: String
    var homeworld: URL
    var people: [URL]
    var films: [URL]
    var url: String
    var created: Date
    var edited: Date
}
