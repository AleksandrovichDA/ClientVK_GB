//
//  SaveImageToChache.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 26.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

class SaveImageToChache: Operation {
    
    private var inputImage: UIImage?
    
    private static let pathName: String = {
        
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private lazy var filePath: String? = {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hasheName = String(describing: self.url.hashValue)
        return cachesDirectory.appendingPathComponent(SaveImageToChache.pathName + "/" + hasheName).path
    }()
    
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        guard let photo = dependencies.first as? LoadPhoto,
                  filePath != nil && !isCancelled else { return }
        inputImage = photo.image
        saveImageToChache()
    }
    
    private func saveImageToChache() {
        guard let fileName = filePath, let image = inputImage else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
