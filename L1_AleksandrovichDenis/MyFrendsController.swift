//
//  MyFrendsController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 21.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import RealmSwift

class MyFrendsController: UITableViewController {
    
    let vkService = VKService()
    var myFrendsRealm : Results<MyFrend>?
    var token : NotificationToken?
    
    func setConfNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfNavigationBar()
        pairTableAndRealm()
        vkService.getFrends() {  }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { // переделать в do
            return
        }
        myFrendsRealm = realm.objects(MyFrend.self)
        token = myFrendsRealm?.observe{ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { // переделать в do
                return
            }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath( row: $0, section: 0) }), with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFrendsRealm?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFrendsCell", for: indexPath) as! MyFrendsCell
        
        guard let frend = myFrendsRealm?[indexPath.row] else {
            cell.idFrend = 0
            cell.name?.text = ""
            cell.photo?.image = nil
            return cell
        }
        
        cell.idFrend = frend.id
        cell.firstName = frend.firstName
        cell.lastName = frend.lastName
        cell.bigPhotoURL = frend.bigPhotoURL
        cell.name.text = frend.firstName + " " + frend.lastName
        cell.photo?.image = PhotoService.loadPhoto(frend.smallPhotoURL, container: self.tableView, containerCell: nil, cellForItemAt: indexPath)
        cell.status?.text = (frend.status == 0) ? "" : "онлайн"
        cell.status?.textColor = (frend.status == 0) ? UIColor.gray : UIColor.green
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDialog" {
            guard let cell = sender as? MyFrendsCell else {
                return
            }
            let messageViewController = segue.destination as! MessagesViewController
            messageViewController.friendID = cell.idFrend
            messageViewController.firstName = cell.firstName
            messageViewController.lastName = cell.lastName
            messageViewController.bigPhotoURL = cell.bigPhotoURL
        }
    }
}













