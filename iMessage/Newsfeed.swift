//
//  Newsfeed.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 15.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import RealmSwift

enum typeAttachmentNews : String {
    case photo = "photo"
    case video = "video"
    case audio = "audio"
    case doc = "doc"
    case graffiti = "graffiti"
    case link = "link"
    case note = "note"
    case poll = "poll"
}

protocol Attachment {
    var id : Int { get set }
    var type : typeAttachmentNews { get set }
}

class Newsfeed: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var date : String = ""
    @objc dynamic var groupID : Int = 0
    @objc dynamic var groupPhotoURL : String = ""
    @objc dynamic var groupPhoto : UIImage? = nil
    @objc dynamic var header : String = ""
    @objc dynamic var textBody : String = ""
    @objc dynamic var likesCount : Int = 0
    @objc dynamic var repostsCount : Int = 0
    @objc dynamic var commentsCount : Int = 0
    @objc dynamic var viewsCount : Int = 0
    var attachPhotoURL : [String] = [String]()
    var attachment : [Attachment]? = [Attachment]()
    
    let attachPhoto = List<Photo>()
    
    override static func ignoredProperties() -> [String] {
        return ["groupPhoto", "attachPhotoURL", "attachment"]
    }
    
}



class Photo: Object, Attachment {

    var type : typeAttachmentNews = .photo
    @objc dynamic var id : Int = 0
    @objc dynamic var photoURL : String = ""
    @objc dynamic var photo : UIImage? = nil
    @objc dynamic var height : CGFloat = 0
    @objc dynamic var width  : CGFloat = 0
    
    let owners = LinkingObjects(fromType: Newsfeed.self, property: "attachPhoto")
    
    override static func ignoredProperties() -> [String] {
        return ["vkService", "typeAttachmentNews", "photo", "height", "width"]
    }
    
    
}

class Video: Attachment {
    var id : Int = 0
    var type : typeAttachmentNews = .video
    var title : String = ""
}











