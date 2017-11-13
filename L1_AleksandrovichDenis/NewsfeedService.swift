//
//  NewsfeedService.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 24.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

struct NewsfeedService {
    let baseURLMethod = "https://api.vk.com"
    let path = "/method"
    let methodRequest = "/newsfeed.get?"
    let parameters: Parameters = [ "access_token" : VKService.token, "return_banned" : "0", "count" : "25", "v" : "5.68" ]
}
