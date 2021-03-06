//
//  NewsfeedController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 15.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class NewsfeedController: UITableViewController, UITabBarDelegate {

    
    let opq = OperationQueue()
    let vkService = VKService()
    var newsfeedRealm : Results<Newsfeed>?
    var token : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfNavigationBar()
        configurationCell()
        pairTableAndRealm()
        loadData()
    }
        
    func setConfNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configurationCell () {
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadData() {
        let newsfeedService = NewsfeedService()
        
        let url = newsfeedService.baseURLMethod + newsfeedService.path + newsfeedService.methodRequest
        let request = Alamofire.request(url, method: .get, parameters: newsfeedService.parameters)
        
        let getDataOperation = GetDataOperation(request: request)
        opq.addOperation(getDataOperation)
        
        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        opq.addOperation(parseData)
        
        let saveData = SaveData()
        saveData.addDependency(parseData)
        opq.addOperation(saveData)
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        newsfeedRealm = realm.objects(Newsfeed.self)
        token = newsfeedRealm?.observe{ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath( row: $0, section: 0) }), with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath( row: $0, section: 0) }), with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath( row: $0, section: 0) }), with: .none)
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
        return newsfeedRealm?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        guard let newsfeed = newsfeedRealm?[indexPath.row] else {
            cell.header.text = ""
            cell.date.text = ""
            cell.textBody.text = ""
            cell.likesCount.text = ""
            cell.viewsCount.text = ""
            cell.groupPhoto.image = nil
            return cell
        }
        
        cell.header.text = newsfeed.header
        cell.date.text = String(newsfeed.date)
        cell.textBody.text = newsfeed.textBody
        cell.likesCount.text = String(newsfeed.likesCount)
        cell.viewsCount.text = String(newsfeed.viewsCount)
        cell.commentsCount.text = String(newsfeed.commentsCount)
        cell.repostsCount.text = String(newsfeed.repostsCount)
        cell.custTableView = self.tableView
        cell.custIndexPath = indexPath
        cell.attachPhoto = newsfeed.attachPhoto
        cell.collectionView.reloadData()
        cell.groupPhoto.image = PhotoService.loadPhoto(newsfeed.groupPhotoURL, container: self.tableView, containerCell: nil, cellForItemAt: indexPath)
        return cell
    }
}
