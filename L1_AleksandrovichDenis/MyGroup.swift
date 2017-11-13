//
//  MyGroups.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 27.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import RealmSwift

class MyGroup: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var desc : String = ""
    @objc dynamic var membersCount : Int = 0
    @objc dynamic var smallPhoto : UIImage? = nil
    @objc dynamic var photoURL : String = ""
    
    override static func ignoredProperties() -> [String] {
        return ["smallPhoto"]
    }
    
    convenience init( _ group : Any) {
        self.init()
        let group  = group as! [String: Any] 
        self.id = group["id"] as! Int
        self.name = group["name"] as! String
        self.desc = group["description"] as? String ?? ""
        self.photoURL = group["photo_50"] as? String ?? ""
        self.membersCount = group["members_count"] as? Int ?? 0
    }
}
