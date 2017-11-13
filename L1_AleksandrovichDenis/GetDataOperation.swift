//
//  GetDataOperation.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 22.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import Alamofire

class GetDataOperation: AsyncOperation {
    private var request : DataRequest
    var data: Data?
    
    init(request : DataRequest) {
        self.request = request
    }
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        request.responseJSON(queue: .global(), options: .allowFragments) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
}
