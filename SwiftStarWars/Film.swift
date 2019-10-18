//
//  Film.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 10/17/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation

struct Film: Codable {
    var title: String
    var episodeID: Int
    var openingCrawl: String
    var director: String
    var producer: String
    var releaseDate: Date
    var species: [URL]
    var starships: [URL]
    var vehicles: [URL]
    var characters: [URL]
    var planets: [URL]
    var url: String
    var created: Date
    var edited: Date
    
    //already converted from snake case, just map capital ID
    enum CodingKeys: String, CodingKey {
        case title, episodeID = "episodeId", openingCrawl, director, producer, releaseDate, species, starships, vehicles, characters, planets, url, created, edited
    }
    
}
