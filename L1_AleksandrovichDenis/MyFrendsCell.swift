//
//  MyFrendsCell.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 21.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class MyFrendsCell: UITableViewCell {
    
    var idFrend : Int!
    var firstName : String?
    var lastName : String?
    var bigPhotoURL : String?
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
