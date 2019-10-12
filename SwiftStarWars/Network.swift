//
//  Network.swift
//  StarwarsAPI
//
//  Created by Douglas Hewitt on 10/11/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation

typealias dataTaskResult = Swift.Result<(URLResponse, Data), Error>
typealias dataTaskCompletion = (dataTaskResult) -> Void


enum NetworkError: String, Error {
    case badToken = "invalid token"
    case unknown = "unknown"
    case badURL = "badURL"
    case decodingError = "decodingError"
}



enum NetworkEnvironment {
    case dev
    case prod
}

struct NetworkManager {
    static let env = NetworkEnvironment.prod
    
    func getAllPeople() {
        let api = StarWarsAPI.people
        
        api.request { (result) in
            switch result {
            case .success(let response, let data):
                print(response.description)
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension URLSession {
    func dataTask(with url: URL, result: @escaping dataTaskCompletion) -> URLSessionDataTask {
    return dataTask(with: url) { (data, response, error) in
        if let error = error {
            result(.failure(error))
            return
        }
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
            return
        }
        result(.success((response, data)))
    }
}
}


public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
