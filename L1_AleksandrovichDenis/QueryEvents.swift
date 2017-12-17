//
//  QueryEvents.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 13.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class QueryEvents {
    
    private let sessionURL: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
//    private lazy var url: URL? = {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "api.vk.com"
//        components.path = "/method/groups.getInvites"
//        components.queryItems = [
//            URLQueryItem(name: "access_token", value: VKService.token),
//            URLQueryItem(name: "v", value: "5.69")
//        ]
//        return components.url
//    }()
    
    func getEvents(barItem: UITabBarItem) {
        
        let url: URL? = {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.vk.com"
            components.path = "/method/groups.getInvites"
            components.queryItems = [
                URLQueryItem(name: "access_token", value: VKService.token),
                URLQueryItem(name: "v", value: "5.69")
            ]
            return components.url
        }()
        
        
        if let url = url {
            self.sessionURL.dataTask(with: url) { data, response, error in
                guard let data = data else { assertionFailure(); return }
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(Event.self, from: data)
                    DispatchQueue.main.sync {
                        barItem.badgeValue = String(describing: result.response.count)
                    }
                } catch { print(error) }
                }.resume()
        }
    }
}

struct Event: Codable {
    let response: RootEvent
}

struct RootEvent: Codable {
    let count : Int
    let items : [ItemEvent]
}

struct ItemEvent: Codable {
    let id: Int
    let name: String
    let type: String
    let photo_50: String
}
