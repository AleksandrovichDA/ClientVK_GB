//
//  TodayViewController.swift
//  LastNews
//
//  Created by Denis on 26.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import NotificationCenter

struct Root : Codable {
    let response: Response
}

struct Response: Codable {
    let items: [Post]
    let groups: [Source]
}

struct Post: Codable {
    let type: String
    let source_id: Int
}

struct Source: Codable {
    let id: Int
    let name: String
}

//post — новые записи со стен;
//photo — новые фотографии;
//photo_tag — новые отметки на фотографиях;
//wall_photo — новые фотографии на стенах;
//friend — новые друзья;
//note — новые заметки;
//audio — записи сообществ и друзей, содержащие аудиозаписи, а также новые аудиозаписи, добавленные ими;
//video — новые видеозаписи.

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newsLast: UITableView!
    
    var posts: Root?
    var token : String?
    let news : [String] = ["123","qwqwe","wevrbsrb","524t4wfs","dfvsdfv","6htdht","ersvre","764eyt","rewff45","wervw"]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let userDefaults = UserDefaults.standard
        
        if let token = UserDefaults.init(suiteName: "group.lastNews")?.value(forKey: "token") {
            self.token = token as! String
        }
        
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
                self?.newsLast.reloadData()
            } catch {
                print(error)
            }
            }.resume()
        
        newsLast.delegate = self
        newsLast.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.response.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        guard let post = self.posts?.response.items[indexPath.row] else {
            cell.nameSource.text = ""
            return cell
        }
        
        var groups = self.posts?.response.groups
        var group = groups?.filter() { $0.id == abs(post.source_id) }
        let post1 : Source = group![0]
        
        cell.nameSource.text = post1.name
        return cell
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = maxSize //CGSize(width: 0.0, height: 1000.0)
        } else {
            preferredContentSize = maxSize
            //self.newsLast.isHidden
        }
    }
}

