//
//  Post.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 15.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

struct PostService {
    let baseURLMethod = "https://api.vk.com"
    let path = "/method"
    let methodRequest = "/wall.post?"
    let parameters: Parameters
    
    init(_ text: String) {
        self.parameters = [ "owner_id" : VKService.userId, "access_token" : VKService.token, "message" : text, "v" : "5.69"]
    }
}
