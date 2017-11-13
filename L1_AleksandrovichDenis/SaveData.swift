//
//  SaveData.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 23.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import RealmSwift

class SaveData: AsyncOperation {
    
    override func main() {
        guard let parseData = dependencies.first as? ParseData else { return }
        DBHandler.saveToDB(parseData.outputData)
    }
}
