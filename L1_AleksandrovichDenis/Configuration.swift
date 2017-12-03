//
//  Configuration.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 12.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation

class Configuration {
    static let shared = Configuration()
    var responseType : String
    var displayMode : String
    var redirectURI : String
    var versionAPI : String
    var clientID : Int
    var scope : Int
    
    private init() {
        var format = PropertyListSerialization.PropertyListFormat.xml
        var plistData : [String: AnyObject] = [:]
        let plistPath : String? = Bundle.main.path(forResource: "Configuration", ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        
        do{
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &format) as! [String: AnyObject]
        }
        catch{
            print("Error reading Configuration.plist: \(error), format: \(format)")
        }
        
        self.clientID     = plistData["clientID"]     as? Int      ?? 0
        self.displayMode  = plistData["displayMode"]  as? String   ?? ""
        self.redirectURI  = plistData["redirectURI"]  as? String   ?? ""
        self.scope        = plistData["scope"]        as? Int      ?? 0
        self.responseType = plistData["responseType"] as? String   ?? ""
        self.versionAPI   = plistData["versionAPI"]   as? String   ?? ""
    }
}
