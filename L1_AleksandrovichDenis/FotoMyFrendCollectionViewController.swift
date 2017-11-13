//
//  FotoMyFrendCollectionViewController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 21.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FotoMyFrendCollectionViewController: UICollectionViewController {
    
    let vkService = VKService()
    
    var firstName   = ""
    var lastName    = ""
    var bigPhotoURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = firstName + " " + lastName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoMyFrendCell", for: indexPath)
            as! FotoMyFrendCell
        
        cell.fotoFrend.setImageFromURl(stringImageUrl: bigPhotoURL)
        return cell
    }
}















