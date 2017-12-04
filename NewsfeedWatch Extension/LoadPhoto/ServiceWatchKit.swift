//
//  ServiceWatchKit.swift
//  NewsfeedWatch Extension
//
//  Created by Denis on 04.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import WatchKit
import UIKit

class Service {
    let queue = OperationQueue()
    private let container: WKInterfaceTable
    var images = [String: UIImage]()
    
    init(container: WKInterfaceTable) {
        self.container = container
    }
    
    func photo(atIndexpath IndexSet: Int, byUrl url: String) -> UIImage? {
        var image: UIImage?
        
        if let photo = images[url] {
            image = photo
        } else {
            let loadPhoto = LoadPhoto(url: url)
            
            let setPhoto = SetPhoto(url: url, container: self)
            setPhoto.addDependency(loadPhoto)
            queue.addOperations([loadPhoto, setPhoto], waitUntilFinished: false)
            
            let reloadRow = ReloadRow(atIndexpath: IndexSet, container: container)
            reloadRow.addDependency(setPhoto)
            OperationQueue.main.addOperation(reloadRow)
        }
        return image
    }
}

fileprivate protocol DataReloadable {
    func reloadRow(atIndexpath indexPath: Int)
}

class LoadPhoto: AsyncOperation {
    var image : UIImage?
    var url : String?
    
    init(url : String) {
        self.url = url
    }
    
    override func cancel() {
        super.cancel()
    }
    
    override func main() {
        if let url = NSURL(string: self.url!) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
        self.state = .finished
    }
}

class SetPhoto: Operation {
    var container: Service
    var outImage : UIImage?
    var url : String
    
    init(url: String, container: Service) {
        self.container = container
        self.url = url
    }
    
    override func main() {
        if let photo = dependencies.first as? LoadPhoto {
            self.outImage = photo.image
            container.images[self.url] = photo.image
        } else {
            return
        }
    }
}

class ReloadRow: Operation {
    var container: WKInterfaceTable
    var indexSet : Int
    
    init(atIndexpath indexSet: Int, container: WKInterfaceTable) {
        self.container = container
        self.indexSet = indexSet
    }
    
    override func main() {
        if let photo = dependencies.first as? SetPhoto {
            if let row = container.rowController(at: indexSet) as? NewsfeedRow {
                row.photoGroup.setImage(photo.outImage)
            }
            
        } else {
            return
        }
    }
}
