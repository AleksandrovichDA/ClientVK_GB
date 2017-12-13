//
//  SetPhoto.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 23.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

class SetPhoto: Operation {
    var outputImage : UIImage?
    
    override func main() {        
        if let photo = dependencies.first as? LoadPhoto {
            outputImage = photo.image
        } else if let photo = dependencies.first as? GetCacheImage {
            outputImage = photo.outputImage 
        } else {
            return
        }
    }
}


