//
//  MyFrends.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 26.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import RealmSwift

class MyFrend: Object {
    @objc dynamic var id            : Int     = 0
    @objc dynamic var firstName     : String  = ""
    @objc dynamic var lastName      : String  = ""
    @objc dynamic var smallPhotoURL : String  = ""
    @objc dynamic var smallPhoto    : UIImage? 
    @objc dynamic var bigPhotoURL   : String  = ""
    @objc dynamic var status : Int = 0
    
    override static func ignoredProperties() -> [String] {
        return ["smallPhoto"]
    }
    
    convenience init( _ user : Any) {
        self.init()
        let user  = user as? [String: Any]
        self.id = user!["user_id"] as! Int
        self.firstName = user!["first_name"] as! String
        self.lastName = user!["last_name"] as! String
        self.smallPhotoURL = user!["photo_50"] as! String
        self.bigPhotoURL = user!["photo_100"] as! String
        self.status = user!["online"] as! Int
    }
}
