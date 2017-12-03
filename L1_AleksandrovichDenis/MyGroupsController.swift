//
//  MyGroupsController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 21.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController {
    
    let vkService = VKService()
    var myGroupsRealm : Results<MyGroup>?
    var token : NotificationToken?
    
    func setConfNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() { // работаем только с БД
        super.viewDidLoad()
        setConfNavigationBar()
        pairTableAndRealm()
        vkService.getMyGroups(){ [weak self] in }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroupsRealm?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupCell
        
        guard let group = myGroupsRealm?[indexPath.row] else {
            cell.nameMyGroup?.text = ""
            cell.avatarMyGroup?.image = #imageLiteral(resourceName: "defaultAvatarGroup.png")
            return cell
        }
        
        cell.nameMyGroup.text = group.name
        cell.avatarMyGroup?.image = PhotoService.loadPhoto(group.photoURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let group = myGroupsRealm?[indexPath.row] else {
                return
            }
            vkService.leaveGroup(group.id){ _ in
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    realm.delete(group)
                    try realm.commitWrite()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func pairTableAndRealm() { // этот метод вызываем один раз
        guard let realm = try? Realm() else { // переделать в do
            return
        }
        myGroupsRealm = realm.objects(MyGroup.self)
        token = myGroupsRealm?.observe{ [weak self] (changes: RealmCollectionChange) in
            
            guard let tableView = self?.tableView else { // переделать в do
                return
            }
            
            switch changes {
            // 1. подписались на уведомление
            case .initial:
                tableView.reloadData()
                
            // 2. что-то изменилось
            case .update(_, let deletions, let insertions, let modifications):
                // deletions - какие позиции были удалены
                // deletions - какие позиции добавились
                // modifications - какие позиции изменились
                
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath( row: $0, section: 0) }), with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath( row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
                
            // 3. ошибки
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77.0
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupsController = segue.source as! AllGroupsController
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                let selectGroup = allGroupsController.filterGroups[indexPath.row]
                vkService.joinGroup( selectGroup.id ){ _ in
                    do {
                        let realm = try Realm()
                        realm.beginWrite()
                        realm.add(selectGroup)
                        try realm.commitWrite()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}




