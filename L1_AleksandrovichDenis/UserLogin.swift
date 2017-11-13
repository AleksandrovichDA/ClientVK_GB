//
//  UserLogin.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 06.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserLogin {
    let id : String
    let date : String
    
    init(_ id : String){
        
        self.id = "id" + id
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy, HH:mm"
        dateFormatter.timeZone = TimeZone.current
        self.date = dateFormatter.string(from: date as Date)
    }
    
    var toAnyObject: Any {
        return [
            "date": date,
        ]
    }
}
