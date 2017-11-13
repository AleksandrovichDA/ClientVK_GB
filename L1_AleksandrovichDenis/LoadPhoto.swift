//
//  LoadPhoto.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 23.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

class LoadPhoto: AsyncOperation {
    private var request : DataRequest
    var image: UIImage?
    
    init(request : DataRequest) {
        self.request = request
    }
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        guard let сacheImage = dependencies.first as? GetCacheImage else { return }
        request.responseData(queue: .global()) { [weak self] response in
            self?.image = UIImage(data: response.data!)
            self?.state = .finished
        }
    }
}
