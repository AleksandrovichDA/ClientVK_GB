//
//  AllGroupsController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 21.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController, UISearchBarDelegate {
    
    let vkService = VKService()
    let delay = Delay() 
    var filterGroups = [MyGroup]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGroups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 77.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
        
        if isSearching {
            cell.idGroup = filterGroups[indexPath.row].id
            cell.nameGroup.text = filterGroups[indexPath.row].name
            cell.imageGroup?.image = PhotoService.loadPhoto(filterGroups[indexPath.row].photoURL)
            cell.membersCount.text = String(filterGroups[indexPath.row].membersCount)
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            delay.delayTime{ 
                self.vkService.searchGroups(searchText: searchBar.text!.lowercased()){ [weak self] filterGroups in
                    self?.filterGroups = filterGroups
                    self?.tableView?.reloadData()
                }
            }
        }
    }
}






