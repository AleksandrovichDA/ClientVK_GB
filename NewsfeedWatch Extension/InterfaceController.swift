//
//  InterfaceController.swift
//  NewsfeedWatch Extension
//
//  Created by Denis on 03.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var newsfeed: WKInterfaceTable!
    lazy var servide = Service(container: newsfeed)
    var posts: Root?
    var token : String?
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    lazy var url: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: self.token),
            URLQueryItem(name: "return_banned", value: "0"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "v", value: "5.69")
        ]
        return components.url
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setupSession()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func setupSession() {
       
        self.token = ExtensionDelegate.token
        
        guard let url = url else {
            assertionFailure()
            return
        }
        print(url)
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                assertionFailure()
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(Root.self, from: data)
                self?.posts = result
                self?.setupTable()
            } catch {
                print(error)
            }
            }.resume()

    }
    
    func setupTable() {
        newsfeed.setNumberOfRows((posts?.response.groups.count)!, withRowType: "NewsfeedRow")
        for i in (posts?.response.groups.enumerated())! {
            if let row = newsfeed.rowController(at: i.offset) as? NewsfeedRow {
                row.textNews.setText(self.posts?.response.items[i.offset].text)
                row.photoGroup.setImage(servide.photo(atIndexpath: i.offset, byUrl: (self.posts?.response.groups[0].photo_50)!))
            }
        }
        
    }
}

struct Root : Codable {
    let response: Response
}

struct Response: Codable {
    let items: [Post]
    let groups: [Source]
}

struct Post: Codable {
    let type: String
    let text: String?
    let source_id: Int
}

struct Source: Codable {
    let id: Int
    let name: String
    let photo_50 : String
}
