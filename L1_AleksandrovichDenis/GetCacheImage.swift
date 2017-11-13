//
//  GetCacheImage.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 25.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

class GetCacheImage: Operation {
    
    private let cacheLifeTime: TimeInterval = 3600
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private let url: String
    
    private lazy var filePath: String? = {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hasheName = String(describing: self.url.hashValue)
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + "/" + hasheName).path
    }()
    
    var outputImage: UIImage?
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        guard filePath != nil && !isCancelled,
              let fileName = filePath,
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return }
        
        self.outputImage = image
    }
}
