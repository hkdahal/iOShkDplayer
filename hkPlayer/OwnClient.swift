//
//  OwnClient.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/10/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import Foundation

// feeding the necessary urls
enum Forecast: EndPoint {
    
    case item(token: String)
    
    var baseURL: URL{
        let apiLink = "http://www.kathmandukitchenandbar.com/api/v1/"
        return URL(string: apiLink)!
    }
    
    var path: String {
        switch self {
        case .item(let token):
            return "\(token)"
        }
    }
    
    var request: URLRequest{
        let url = URL(string: path, relativeTo: baseURL)!
        return URLRequest(url: url)
    }
}

// make an extension of the card to conform JSONDecodable{init?(JSON: [String: AnyObject])}

// creating own client based on APIClient
class MyClient: APIClient{
    
    let configuration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    fileprivate let token: String
    
    // constructor
    required init(config: URLSessionConfiguration, token: String){
        self.configuration = config
        self.token = token
    }
    
    // easy constructor
    convenience init(token: String){
        self.init(config: URLSessionConfiguration.default, token: token)
    }
    
    // getting the data
    func fetchCurrentWeather(_ completion: @escaping (APIResult<SongDetails>) -> Void){
        let request = Forecast.item(token: self.token).request
        
        fetch(request, parse: {json -> SongDetails? in
            //Parse from JSON response to ItemDetails
            //if let currentWeatherDictionary = json as? [[String: AnyObject]]{
            return SongDetails(JSONList: json)!
            // }else{
            //    return nil
            //}
            
            }, completion: completion)
    }
}
