//
//  APIClient.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/10/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import Foundation

public let NetworkingErrorDomain = "com.InternHackDay.ECard.NetworkingError"
public let MissingHTTPResponseError: Int = 11
public let UnexpectedResponseError: Int = 22


typealias JSON = [String: AnyObject]
typealias JSONList = [JSON]
typealias JSONTaskCompletion = (JSONList?, HTTPURLResponse?, NSError?) -> Void
typealias JSONTask = URLSessionDataTask


// to track generic result returned by API
enum APIResult<T>{
    case success(T)
    case failure(Error)
}

// make the use of the url more efficient
protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

// making sure there exists JSON as wanted
protocol JSONDecodable {
    init?(JSONList: JSONList)
}

// creating an API Client with necessary protocols
protocol APIClient {
    var configuration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    init(config: URLSessionConfiguration, token: String)
    
    //func JSONTaskWithRequest(_ request: URLRequest, completion: JSONTaskCompletion) -> JSONTask
    //func fetch<T: JSONDecodable>(_ request: URLRequest, parse: (JSONList) -> T?, completion: @escaping (APIResult<T>) -> Void)
}

// doing the necessary stuffs for API Client
extension APIClient{
    
    // sending data
    func JSONTaskWithRequest(_ request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask {
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            
            guard let HTTPResponse = response as? HTTPURLResponse else{
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: NetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            
            if data == nil{
                if let error = error{
                    completion(nil, HTTPResponse, error as NSError?)
                }
            }else{
                switch HTTPResponse.statusCode{
                case 200:
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? JSONList
                        completion(json, HTTPResponse, nil)
                    }catch let error as NSError{
                        completion(nil, HTTPResponse, error)
                    }
                default: print("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
                }
            }
        })
        
        return task
    }
    
    
    // fetching the data after sending the request
    func fetch<T>(_ request: URLRequest, parse: @escaping (JSONList) -> T?, completion: @escaping (APIResult<T>) -> Void){
        let task = JSONTaskWithRequest(request) {json, response, error in
            guard let json = json else{
                if let error = error{
                    completion(.failure(error))
                }else{
                    // to do
                }
                return
            }
            if let value = parse(json){
                //print(value)
                //print(json)
                completion(.success(value))
            }else{
                let error = NSError(domain: NetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


