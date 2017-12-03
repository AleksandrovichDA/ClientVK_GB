//
//  AppDelegate.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 14.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
//    let realm = Realm.Configuration(fileURL: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lastNews")?.appendingPathComponent("default.realm"))

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lastNews")!.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        print(config)
        
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        
        
        print(realm)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Старт обновления в фоне \(Date())")
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 30 {
            print ("Фоновое обновление не требуется: \(abs(lastUpdate!.timeIntervalSinceNow)) секунд назад (меньше 30)")
            completionHandler(.noData)
            return
        }
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(29), leeway: .seconds(1))
        timer?.setEventHandler {
            print ("Говорим системе, что не смогли загрузить данные")
            completionHandler(.failed)
            return
        }
        
        timer?.resume()

        let groupsInvitations = GroupsInvitations()
        let url = groupsInvitations.baseURLMethod + groupsInvitations.path + groupsInvitations.methodRequest
        let request = Alamofire.request(url, method: .get, parameters: groupsInvitations.parameters)
        
        request.responseJSON(queue: .global(), options: .allowFragments) { [weak self] response in
            guard let data = response.value else { return }
            let json = JSON(data)
            let count = json["response"]["count"].intValue
            print(count)
            let invitations = json["response"]["items"].array?.flatMap { Invitations($0) } ?? []
            DBHandler.saveToDB(invitations)
            timer = nil
            lastUpdate = Date()
            completionHandler(.newData)
        }
    }
}


