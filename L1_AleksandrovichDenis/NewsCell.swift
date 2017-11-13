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
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 2.0, bottom: 5.0, right: 2.0)
    
    var attachPhoto : List<Photo>?
    var photoArray : [UIImage] = [UIImage]()
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
        cell.photoNews.image = PhotoService.loadPhoto(photo.photoURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let photo = attachPhoto?[indexPath.row] else { return CGSize(width: 0, height: 0) }
        let image = PhotoService.loadPhoto(photo.photoURL)
        photoArray.append(image!)
        let width = image?.size.width ?? 0
        let height = image?.size.height ?? 0
        return CGSize(width: width * 0.5, height: height * 0.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
