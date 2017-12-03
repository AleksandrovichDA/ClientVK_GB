//
//  NewsViewCell.swift
//  LastNews
//
//  Created by Denis on 26.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {

    @IBOutlet weak var nameSource: UILabel!
    @IBOutlet weak var typePost: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
