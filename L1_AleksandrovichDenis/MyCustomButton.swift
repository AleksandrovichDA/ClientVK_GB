//
//  MyCustomButton.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 15.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import UIKit

class MyCustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.tintColor = UIColor.blue
    }
}
