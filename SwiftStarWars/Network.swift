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

typealias peopleResult = Swift.Result<People, Error>
typealias peopleCompletion = (peopleResult) -> Void


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
    
    let decoder = JSONDecoder()
    
    func getAllPeople(completion: @escaping peopleCompletion) {
        let api = StarWarsAPI.people
        
        api.request { (result) in
            switch result {
            case .success(let response, let data):
                print(response.description)
                
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                print(dataString!)
                
                let decoder = JSONDecoder()

                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)

                    let formatter = DateFormatter.SWAPIFormatter
                    if let date = formatter.date(from: dateStr) {
                        return date
                    }
                    let formatter2 = DateFormatter.SWAPIFormatterReleaseDate
                    if let date = formatter2.date(from: dateStr) {
                        return date
                    }
                    throw DateError.invalidDate
                })
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let people = try! decoder.decode(People.self, from: data)
                
                completion(.success(people))
                
            case .failure(let error):
                print(error)
                
                completion(.failure(error))
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

enum DateError: String, Error {
    case invalidDate
}

extension DateFormatter {
    static let SWAPIFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    static let SWAPIFormatterReleaseDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
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
