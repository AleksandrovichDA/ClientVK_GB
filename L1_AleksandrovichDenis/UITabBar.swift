//
//  UINavigationController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 20.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import RealmSwift

class UITabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountBadge()
    }
    
    func getCountBadge () {
        do {
            let realm = try Realm()
            let count = realm.objects(Invitations.self).count
            self.tabBar.items?[2].badgeValue = (count != 0) ? String(count) : ""
        } catch {
            print(error)
        }
    }
}
