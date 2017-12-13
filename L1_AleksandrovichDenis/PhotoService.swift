//
//  photoService.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 24.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

class PhotoService {
    
    static func loadPhoto( _ imageURL : String, container: UITableView?, containerCell: UICollectionView?, indexPath: IndexPath) -> UIImage? {
        let queue = OperationQueue()
        
        let getCacheImage = GetCacheImage(url: imageURL)
        let setPhoto = SetPhoto()
        setPhoto.addDependency(getCacheImage)
        queue.addOperations([getCacheImage, setPhoto], waitUntilFinished: true)

        if let image = setPhoto.outputImage {
            return image
        }
        
        let request = Alamofire.request(imageURL)
        let loadPhoto = LoadPhoto(request: request)
        loadPhoto.addDependency(getCacheImage)
        
        let setPhoto1 = SetPhoto()
        setPhoto1.addDependency(loadPhoto)
        let saveImageToChache = SaveImageToChache(url: imageURL)
        saveImageToChache.addDependency(loadPhoto)
        queue.addOperations([loadPhoto, setPhoto1, saveImageToChache], waitUntilFinished: true)
        
        if let container = container {
            let reloadRow = ReloadRow(atIndexpath: indexPath, container: container)
            reloadRow.addDependency(setPhoto)
            OperationQueue.main.addOperation(reloadRow)
        } else {
            let reloadCell = ReloadCell(atIndexpath: indexPath, container: containerCell!)
            reloadCell.addDependency(setPhoto)
            OperationQueue.main.addOperation(reloadCell)
        }
        
        return nil
    }
}
