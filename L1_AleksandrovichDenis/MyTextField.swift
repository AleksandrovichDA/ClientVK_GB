//
//  MyTextField.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 15.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import UIKit

class MyTextField: UITextField {
    override func draw(_ rect: CGRect) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
