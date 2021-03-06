//
//  NewsCell.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 16.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class NewsCell: UITableViewCell {
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 25.0, left: 10.0, bottom: 25.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    var attachPhoto : List<Photo>?
    var custIndexPath: IndexPath?
    var photoArray : [UIImage] = [UIImage]()
    weak var custTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupPhoto: UIImageView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textBody: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var repostsCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {

        var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)

        collectionView.layoutIfNeeded()
        size.height += collectionView.contentSize.height
        return size

    }
    
}

extension NewsCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachPhoto?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoNewsCell", for: indexPath) as! PhotoNewsCell
        
        guard let photo = attachPhoto?[indexPath.row] else { return cell }
        var rowIndexPath = self.custIndexPath
        
        cell.photoNews.image = PhotoService.loadPhoto(photo.photoURL, container: self.custTableView, containerCell: nil, cellForItemAt: rowIndexPath!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var count : CGFloat = 1
        
        if let countPhoto = attachPhoto?.count, countPhoto > 1 {
            count = 2
        }
        
        let paddingSpace = sectionInsets.left * (count + 1)
        let availableWidth = self.collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / count
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

