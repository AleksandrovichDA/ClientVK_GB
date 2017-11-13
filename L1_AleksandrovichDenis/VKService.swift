//
//  VKService.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 24.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum methodRequest : String {
    case getMyFrends   = "/friends.get?"
    case getPhotos     = "/photos.getAll?"
    case getGroups     = "/groups.get?"
    case getGroupsById = "/groups.getById?"
    case searchGroup   = "/groups.search?"
    case joinGroup     = "/groups.join?"
    case leaveGroup    = "/groups.leave?"
    case getHistory    = "/messages.getHistory?"
    case sendMessage   = "/messages.send?"
    case newsFeed      = "/newsfeed.get?"
}

class VKService {
    
    fileprivate let baseURLMethod = "https://api.vk.com"
    fileprivate let client_id = "6196076"
    fileprivate let path = "/method"
    fileprivate let version = "5.68"
    static var token = ""
    static var userId = 0
    
    func getNewsfeed ( completion: @escaping (Int) -> Void ) {
        let parameters: Parameters = [ "access_token" : VKService.token,
                                       "return_banned" : "0",
                                       "count" : "5",
                                       "v" : version]
        let url = baseURLMethod + path + methodRequest.newsFeed.rawValue
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(), options: .allowFragments) { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                let json = JSON(value)
                let groups = json["response"]["groups"].arrayValue
                let _ = json["response"]["items"].array?.flatMap { Newsfeed(json: $0, groups: groups) } ?? []
                completion(1)
            }
        }
    }
    
    func sendMessage(friendID userID : Int, messageText text : String, completion: @escaping (Int) -> Void) {
        let parameters: Parameters = [ "access_token" : VKService.token,
                                       "user_id"      : userID, //"133147917"
                                       "message"      : text,
                                       "v"            : version]
        
        let url = baseURLMethod + path + methodRequest.sendMessage.rawValue
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVk = response.value as! [String: Any]
                let messageId = responseVk["response"] as? Int ?? 0
                completion(messageId)
            }
        }
    }
    
    func getHistory(_ friendID : Int, completion: @escaping ([Message]) -> Void) {  // _ idFrend: Int,
        let parameters: Parameters = [ "access_token" : VKService.token,
                                       "offset"       : "0",
                                       "count"        : "20",
                                       "peer_id"      : friendID,
                                       "rev"          : "0",
                                       "v"            : version]
        
        let url = baseURLMethod + path + methodRequest.getHistory.rawValue
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVk = response.value as! [String: Any]
                let dataAny = responseVk["response"] as! [String: Any]
                let dataMessageAny = dataAny["items"] as! [Any]
                let myMessage = dataMessageAny.map(){ Message($0) }
                completion(myMessage)
            }
        }
    }
    
    func leaveGroup( _ idGroup: Int, completion: @escaping () -> Void) {
        let parameters: Parameters = [ "access_token" : VKService.token,
                                       "group_id"     : idGroup,
                                       "v"            : version]
        let url = baseURLMethod + path + methodRequest.leaveGroup.rawValue
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVk = response.value as! [String: Any]
                _ = responseVk["response"] as? Int ?? 0
                completion()
            }
        }
    }
    
    func joinGroup(_ idGroup : Int, completion: @escaping ( ) -> Void) {
        let parameters: Parameters = [ "access_token" : VKService.token,
                                       "group_id"     : idGroup,
                                       "v"            : version]
        
        let url = baseURLMethod + path + methodRequest.joinGroup.rawValue
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVk = response.value as! [String: Any]
                _ = responseVk["response"] as? Int ?? 0
                completion()
            }
        }
    }
    
    func getFrends( completion: @escaping ( ) -> Void) {
        let parameters: Parameters = ["user_id"  : VKService.userId,
                                      "order"    : "name",
                                      "fields"   : "nickname,photo_50,photo_100",
                                      "version"  : version]
        
        let url = baseURLMethod + path + methodRequest.getMyFrends.rawValue
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVk = response.value as! [String: Any]
                let dataUsersAny = responseVk["response"] as! [Any]
                let myFrends = dataUsersAny.map(){ MyFrend($0) }
                DBHandler.saveToDB(myFrends)
                completion()
            }
        }
    }
    
    func getMyGroups( completion: @escaping ( ) -> Void) {
        
        let parameters: Parameters = [ "access_token" : VKService.token,
                                       "user_id"      : VKService.userId,
                                       "extended"     : "1",
                                       "fields"       : "description",
                                       "v"            : version]
        
        let url = baseURLMethod + path + methodRequest.getGroups.rawValue
        print(parameters)
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure( let error ):
                print(error)
            case .success:
                let responseVk = response.value as! [String: Any]
                let dataAny = responseVk["response"] as! [String : Any]
                let dataGroupsAny = dataAny["items"] as! [Any]
                let myGroups = dataGroupsAny.map(){ MyGroup($0) }
                DBHandler.saveToDB(myGroups)
                completion()
            }
        }
    }
    
    func searchGroups( searchText : String, completion: @escaping ([MyGroup]) -> Void) {
        guard searchText != ""  else { return }
        var groupsId = ""
        var parameters: Parameters = [ "access_token" : VKService.token,
                                       "q"       : searchText,
                                       "type"    : "group",
                                       "count"   : "20",
                                       "v"       : version]
        
        var url = baseURLMethod + path + methodRequest.searchGroup.rawValue
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                let responseVk = response.value as! [String: Any]
                let dataAny = responseVk["response"] as! [String : Any]
                let dataGroupsAny = dataAny["items"] as! [Any]
                let dataCount = dataAny["count"] as! UInt
                
                guard dataCount != 0 else { return }
                
                for number in 0..<dataGroupsAny.count {
                    let group  = dataGroupsAny[number] as! [String : Any]
                    let id = group["id"] as! UInt
                    groupsId = groupsId + "," + String(id)
                }
                
                parameters.removeAll()
                parameters = [ "access_token" : VKService.token,
                               "group_ids" : groupsId,
                               "fields"    : "members_count",
                               "v"         : self.version]
                
                url = self.baseURLMethod + self.path + methodRequest.getGroupsById.rawValue
                
                Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        print(error)
                    case .success:
                        let responseVk = response.value as! [String: Any]
                        let dataGroupsAny = responseVk["response"] as! [Any]
                        let myGroups = dataGroupsAny.map(){ MyGroup($0) }
                        completion(myGroups)
                    }
                }
            }
        }
    }
    
    func loadingFoto( photoURL : String, completion: @escaping (UIImage) -> Void ) {
        Alamofire.request(photoURL).responseData {response in
            if let error = response.error {
                print(error)
            } else if let data = response.data {
                if let smallPhoto = UIImage(data: data) {
                    completion(smallPhoto)
                }
            }
        }
    }
} 









