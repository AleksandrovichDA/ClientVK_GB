//
//  InterfaceController.swift
//  NewsfeedWatch Extension
//
//  Created by Denis on 03.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var newsfeed: WKInterfaceTable!
    private var token : String?
    lazy var servide = Service(container: newsfeed)
    var posts: Root?
    var news = [NewsWath]()
    
    // наш сеанс
    private let session: WCSession = WCSession.default
    
    let sessionURL: URLSession = {
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
        session.delegate = self
        session.activate()
    }
    
    func setupSession() {
        guard let url = url else { assertionFailure(); return }
        print(url)
        sessionURL.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else { assertionFailure(); return }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(Root.self, from: data)
                self?.news = result.response.items.flatMap(){ itemNews in
                    let text = itemNews.text ?? ""
                    let group = result.response.groups.filter(){ $0.id == abs(itemNews.source_id) }
                    let news = NewsWath(text: text, url: (group.first?.photo_50)!)
                    return news
                }
                self?.setupTable()
            } catch {
                print(error)
            }
            }.resume()
    }
    
    private func showNewsfeed() {
        guard self.token != nil else {
            //self.showAlert(title: "Ошибка доступа", message: "Войдите в приложение на телефоне")
            return
        }
        self.setupSession()
    }
    
    private func showAlert(title: String?, message: String?) {
        let closeButton = WKAlertAction(title: "Close", style: .cancel, handler: {})
        self.presentAlert(withTitle: title, message: message, preferredStyle: .alert, actions: [closeButton])
    }
    
    func setupTable() {
        newsfeed.setNumberOfRows(news.count, withRowType: "NewsfeedRow")
        for i in news.enumerated() {
            if let row = newsfeed.rowController(at: i.offset) as? NewsfeedRow {
                row.textNews.setText(self.news[i.offset].text)
                row.photoGroup.setImage(servide.photo(atIndexpath: i.offset, byUrl: news[i.offset].url))
            }
        }
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard activationState == .activated else {
            self.showAlert(title: "Error activation session", message: "Try again later")
            return
        }
        self.showNewsfeed()
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let token = userInfo["token"] {
            self.token = token as? String
            showNewsfeed()
        }
    }
}

