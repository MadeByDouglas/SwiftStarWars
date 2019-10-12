//
//  StarWarsAPI.swift
//  StarwarsAPI
//
//  Created by Douglas Hewitt on 10/11/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation

enum StarWarsAPI {
    
    
    /*
     films string -- The URL root for Film resources
     people string -- The URL root for People resources
     planets string -- The URL root for Planet resources
     species string -- The URL root for Species resources
     starships string -- The URL root for Starships resources
     vehicles string -- The URL root for Vehicles resources
     */

    case films
    case people
    case planets
    case species
    case starships
    case vehicles
    
}

extension StarWarsAPI {
    //TODO: move this to plist and xcode build configs
    var environmentBase: String {
        switch NetworkManager.env {
        case .dev:
            return "https://swapi.co/api-dev/"
        case .prod:
            return "https://swapi.co/api/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBase) else { fatalError("Base URL not setup properly. You did something wrong.")}
        return url
    }
    
    var path: String {
        switch self {
        case .films: return "films/"
        case .people: return "people/"
        case .planets: return "planets/"
        case .species: return "species/"
        case .starships: return "starships/"
        case .vehicles: return "vehicles/"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    public var sampleData: Data {
      return Data()
    }
    
    public var body: Data? {
        //TODO: add cases where you want to add a http body to a request
        
        //see about encoding JSON
//        body = try JSONEncoder().encode(data)

        return  nil
    }
    
    public var task: String {
        //TODO: not sure how to make this work with alamofire since request tasks are not enums
        return ""

    }
    
    func request(completion: @escaping dataTaskCompletion) {
        let url = baseURL.appendingPathComponent(path)
        
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.timeoutInterval = 7
        req.allHTTPHeaderFields = headers
        req.httpBody = body
        
        let task = URLSession.shared.dataTask(with: url) { (result) in
            completion(result)
        }
        task.resume()
    }

    public var headers: [String: String]? {
        let headers = ["Content-Type": "application/json"]
        return headers
    }


}
