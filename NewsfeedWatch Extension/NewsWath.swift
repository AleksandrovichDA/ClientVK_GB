//
//  NewsWath.swift
//  NewsfeedWatch Extension
//
//  Created by Denis on 11.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation

class NewsWath {
    var text: String
    var url: String
    init(text: String, url: String){
        self.text = text
        self.url = url
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
