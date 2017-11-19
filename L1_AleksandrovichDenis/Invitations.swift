//
//  GroupsInvitations.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 19.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Invitations: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var smallPhoto : UIImage? = nil
    @objc dynamic var photoURL : String = ""
    
    override static func ignoredProperties() -> [String] {
        return ["smallPhoto"]
    }
    
    convenience init( _ invitation : JSON) {
        self.init()
        self.id = invitation["id"].intValue
        self.name = invitation["name"].stringValue
        self.type = invitation["type"].stringValue
        self.photoURL = invitation["photo_50"].stringValue
    }
}

