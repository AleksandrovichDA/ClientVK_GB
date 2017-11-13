//
//  MyGroupCell.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 27.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit

class MyGroupCell: UITableViewCell {
    
    @IBOutlet weak var avatarMyGroup: UIImageView!
    @IBOutlet weak var nameMyGroup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
