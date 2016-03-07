import Foundation

class RssItem {
    
    var title: String?
    var creator: String?
    var pubDate: NSDate?
    var link: String?
    var description: String?
    var content: String?
    var imageHeading: String?
    
    init (title: String, creator: String, pubDate: NSDate, link: String, description: String, content: String, imageHeading: String) {
        self.title = title
        self.creator = creator
        self.pubDate = pubDate
        self.link = link
        self.description = description
        self.content = content
        self.imageHeading = imageHeading
    }
}
