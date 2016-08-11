import Foundation

class RawPostItem {
    
    var title: String
    var creator: String
    var pubDate: NSDate
    var link: String
    var abstract: String
    var content: String
    var imageHeading: String
    var creatorAvatar: String
    
    init (title: String, creator: String, pubDate: NSDate, link: String, abstract: String, content: String, imageHeading: String, creatorAvatar: String) {
        self.title = title
        self.creator = creator
        self.pubDate = pubDate
        self.link = link
        self.abstract = abstract
        self.content = content
        self.imageHeading = imageHeading
        self.creatorAvatar = creatorAvatar
    }
}
