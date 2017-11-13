//
//  Newsfeed.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 15.10.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation
import SwiftyJSON
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
    var attachment : [Attachment] = [Attachment]()
    
    let attachPhoto = List<Photo>()
    
    override static func ignoredProperties() -> [String] {
        return ["groupPhoto", "attachPhotoURL", "attachment"]
    }
    
    convenience init(json: JSON, groups: [JSON]) {
        self.init()
        self.id = Int(Date().timeIntervalSince1970)
        
        let timeResult = json["date"].doubleValue
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeResult))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
        dateFormatter.timeZone = TimeZone.current
        self.date = dateFormatter.string(from: date as Date)
        
        self.groupID = abs(json["source_id"].intValue)
        self.groupPhotoURL = json["photo_50"].stringValue
        
        let group = groups.filter { $0["id"].intValue == groupID }
        if group.count > 0 {
            self.groupPhotoURL = group[0]["photo_50"].stringValue
            self.header = group[0]["name"].stringValue
        }
        
        self.textBody = json["text"].stringValue
        self.likesCount = json["likes"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue
        
        let typeAttachmentJSON = json["attachments"].arrayValue
        
        for element in typeAttachmentJSON {
            let typeAttachment = element["type"].stringValue
            
            switch typeAttachment {
            case typeAttachmentNews.photo.rawValue:
                let photoAttachment = Photo(json: element)
                attachPhoto.append(photoAttachment)
                attachment.append(photoAttachment)
                self.attachPhotoURL.append(photoAttachment.photoURL)
            default:
                return
            }
        }
    }
}



class Photo: Object, Attachment {
    let vkService = VKService()
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
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["photo"]["id"].intValue
        self.photoURL = json["photo"]["photo_604"].stringValue
    }
}

class Video: Attachment { //  ...
    var id : Int = 0
    var type : typeAttachmentNews = .video
    var title : String = ""
    // ......
}










