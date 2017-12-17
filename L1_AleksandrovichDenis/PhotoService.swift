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
    
    static func loadPhoto( _ imageURL : String, container: UITableView?, containerCell: UICollectionView?, cellForItemAt indexPath: IndexPath) -> UIImage? {
        let queue = OperationQueue()
        
        let getCacheImage = GetCacheImage(url: imageURL)
        queue.addOperations([getCacheImage], waitUntilFinished: true)

        if let image = getCacheImage.outputImage {
            return image
        }
        
        let request = Alamofire.request(imageURL)
        let loadPhoto = LoadPhoto(request: request)
        loadPhoto.addDependency(getCacheImage)
        
        let setPhoto = SetPhoto()
        setPhoto.addDependency(loadPhoto)
        let saveImageToChache = SaveImageToChache(url: imageURL)
        saveImageToChache.addDependency(loadPhoto)
        queue.addOperations([loadPhoto, setPhoto, saveImageToChache], waitUntilFinished: false)
        
        if let container = container {
            let reloadRow = ReloadRow(atIndexpath: indexPath, container: container)
            reloadRow.addDependency(setPhoto)
            OperationQueue.main.addOperation(reloadRow)
            return setPhoto.outputImage
        }
        return nil
    }
}
