//
//  GroupsInvitations.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 19.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

struct GroupsInvitations {
    let baseURLMethod = "https://api.vk.com"
    let path = "/method"
    let methodRequest = "/groups.getInvites?"
    let parameters: Parameters = [ "access_token" : VKService.token, "v" : "5.69" ]
}

