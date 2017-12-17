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
    private let queryEvents = QueryEvents()
    override func viewDidLoad() {
        super.viewDidLoad()
        setBadgeTab()
        queryEvents.getEvents(barItem: (self.tabBar.items?[2])!)
    }
    
    func setBadgeTab() {
        do {
            
            let realm = try Realm()
            let count = realm.objects(Invitations.self).count
            self.tabBar.items?[2].badgeValue = (count != 0) ? String(count) : nil
        } catch {
            print(error)
        }
    }
}
