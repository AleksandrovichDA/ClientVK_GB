//
//  MessageCell.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 14.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var firstName : String?
    var lastName : String?
    var bigPhotoURL : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 12)
    }

}
