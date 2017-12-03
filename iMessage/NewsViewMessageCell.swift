//
//  NewsViewMessageCell.swift
//  iMessage
//
//  Created by Denis on 29.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class NewsViewMessageCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var textNews: UILabel!
    @IBOutlet weak var photoNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
