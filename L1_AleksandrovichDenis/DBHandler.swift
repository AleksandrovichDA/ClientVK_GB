//
//  DBHandler.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 11.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import RealmSwift

class DBHandler {
    static func saveToDB <T: Object> (_ objects: [T]){
        do {
            let realm = try Realm()
            let oldObjects = realm.objects(T.self)
            print(realm.configuration.fileURL ?? "")
            realm.beginWrite()
            realm.delete(oldObjects)
            realm.add(objects)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
