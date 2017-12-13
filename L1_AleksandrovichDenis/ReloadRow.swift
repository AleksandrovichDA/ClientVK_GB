//
//  ReloadRow.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 13.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import UIKit

class ReloadRow: Operation {
    var container: UITableView
    var indexPath: IndexPath
    
    init(atIndexpath indexPath: IndexPath, container: UITableView) {
        self.container = container
        self.indexPath = indexPath
    }
    
    override func main() {
        if let _ = dependencies.first as? SetPhoto {
            container.reloadRows(at: [indexPath], with: .none)
        } else {
            return
        }
    }
}
