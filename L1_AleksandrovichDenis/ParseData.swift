//
//  ParseData.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 23.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParseData: Operation {
    var outputData : [Newsfeed] = []
    
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        let json = JSON(data)
        let groups = json["response"]["groups"].arrayValue
        let _ = json["response"]["items"].array?.flatMap{ outputData.append(Newsfeed(json: $0, groups: groups)) } ?? []
    }
}
