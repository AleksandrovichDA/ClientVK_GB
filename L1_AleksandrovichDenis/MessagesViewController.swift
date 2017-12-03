//
//  MessagesViewController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 14.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UICollectionViewDataSource {
    let vkService = VKService()
    var friendID : Int?
    var firstName : String?
    var lastName : String?
    var bigPhotoURL : String?
    @IBOutlet weak var newsfeed: UITableView!
    var messages = [Message]()
    
    
    @IBOutlet weak var textNewMessage: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func sendMessage(_ sender: UIButton) {
        vkService.sendMessage(friendID: friendID!, messageText: textNewMessage.text!) { [weak self] response in   // <--- !!!!!
            print(response)
            self?.textNewMessage.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.firstName! + " " + self.lastName!
        vkService.getHistory(friendID!) { [weak self] messages in
            self?.messages = messages
            self?.collectionView?.reloadData()
        }
        
        collectionView.register(UINib.init(nibName: "MessageCell", bundle: nil), forCellWithReuseIdentifier: "MessageCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.textLabel.text = messages[indexPath.row].body
        cell.firstName = self.firstName
        cell.lastName = self.lastName
        cell.bigPhotoURL = self.bigPhotoURL
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMyFrend" {
            let fotoMyFrendCollectionController = segue.destination as! FotoMyFrendCollectionViewController
            fotoMyFrendCollectionController.firstName = self.firstName!
            fotoMyFrendCollectionController.lastName = self.lastName!
            fotoMyFrendCollectionController.bigPhotoURL = self.bigPhotoURL!
        }
    }
}
