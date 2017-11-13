//
//  Message.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 14.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation

class Message {
    
    var id : Int
    var body : String
    var userId : Int
    var fromId : Int
    var date : Int
    var readState : Int
    var directionMessage : Bool // 0 - входящее
    
    init( _ message : Any) {
        let message  = message as! [String: Any]
        self.id = message["id"] as! Int
        self.body = message["body"] as! String
        self.userId = message["user_id"] as! Int
        self.fromId = message["from_id"] as! Int
        self.date = message["date"] as! Int
        self.readState = message["read_state"] as! Int
        let out = message["out"] as! Int
        self.directionMessage = out == 0 ? true : false
    }
    
    func sendMessage() {
        
    }
}
