//
//  AllGroupsCell.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 21.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    var idGroup : Int!
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var membersCount: UILabel!
    @IBOutlet weak var imageGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
