//
//  AppDelegate.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 14.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import Alamofire
import SwiftyJSON
import RealmSwift
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        configRealm()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
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
    
    func configRealm() {
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lastNews")!.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        print(config)
        
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        
        
        print(realm)
    }
    
//    func scheduleNotification(identifier: String, title: String, subtitle: String, body: String, timeInterval: TimeInterval, repeats: Bool = false) {
//        if #available(iOS 10, *) {
//            let content = UNMutableNotificationContent()
//            content.title = title
//            content.subtitle = subtitle
//            content.body = body
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
//            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        } else {
//            let notification = UILocalNotification()
//            notification.alertBody = "\(title)\n\(subtitle)\n\(body)"
//            notification.fireDate = Date(timeIntervalSinceNow: 1)
//
//            application.scheduleLocalNotification(notification)
//        }
//    }
    
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

extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        // Change this to your preferred presentation option
        completionHandler([])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        completionHandler()
    }
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


