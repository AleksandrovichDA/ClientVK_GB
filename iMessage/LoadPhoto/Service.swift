//
//  Service.swift
//  iMessage
//
//  Created by Denis on 02.12.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import UIKit

class Service {
    let queue = OperationQueue()
    private let container: UITableView
    var images = [String: UIImage]()
    var flags = [Int: Bool]()
    
    init(container: UITableView) {
        self.container = container
    }
    
    func photo(atIndexpath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
       
        if let photo = images[url] {
            image = photo
        } else {
            flags[indexPath.row] = true
            let loadPhoto = LoadPhoto(url: url)
            
            let setPhoto = SetPhoto(url: url, container: self)
            setPhoto.addDependency(loadPhoto)
            queue.addOperations([loadPhoto, setPhoto], waitUntilFinished: false)
            
            let reloadRow = ReloadRow(atIndexpath: indexPath, container: container)
            reloadRow.addDependency(setPhoto)
            OperationQueue.main.addOperation(reloadRow)
        }
        return image
    }
}

fileprivate protocol DataReloadable {
    func reloadRow(atIndexpath indexPath: IndexPath)
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
    var container: UITableView
    var indexPath : IndexPath
    
    init(atIndexpath indexPath: IndexPath, container: UITableView) {
        self.container = container
        self.indexPath = indexPath
    }
    
    override func main() {
        if let _ = dependencies.first as? SetPhoto {
            container.reloadRows(at: [indexPath], with: .none)
        } else {
            return
        }
    }
}
