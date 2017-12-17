//
//  ReloadCell.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 13.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import UIKit

class ReloadCell: Operation {
    var container: UICollectionView
    var indexPath: IndexPath
    
    init(atIndexpath indexPath: IndexPath, container: UICollectionView) {
        self.container = container
        self.indexPath = indexPath
    }
    
    override func main() {
        if let _ = dependencies.first as? SetPhoto {
            
           // container.reloadItems(at: [indexPath])
          //  container.performBatchUpdates({
               // container.reloadItems(at: [indexPath])
               // for update in updates {
                 //   switch update {
                   // case .Add(let index):
             //   container.insertItems(at: [indexPath])
                     //   itemCount += 1
                   // case .Delete(let index):
                   //     collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
                  //      itemCount -= 1
                  //  }
               // })
           // }, completion: nil)
        
        } else {
            return
        }
    }
}
