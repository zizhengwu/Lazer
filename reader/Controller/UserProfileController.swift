import SwiftyJSON

class UserProfileController: NSObject {
    static let sharedInstance = UserProfileController()
    
    var tags = [Tag]()
    var preferredRelaxationTime: Double
    dynamic var zenMode: Bool
    
    override init () {
        preferredRelaxationTime = 5.0
        zenMode = false
    }
    
    func initializeTags() {
        for tagOption in Constant.TAG_OPTIONS {
            let tag = Tag()
            tag.name = tagOption[0]
            tag.url = tagOption[1]
            self.tags.append(tag)
        }
    }
    
    func reloadTags() {
        var tagsSelectedJson: JSON
        if LoginManager.sharedInstance.dataset != nil {
            if let tagsSelectedString = LoginManager.sharedInstance.dataset!.stringForKey("tags") {
                print("fetch tags")
                tagsSelectedJson = JSON.parse(tagsSelectedString)
            }
            else {
                tagsSelectedJson = JSON.parse("")
            }
        }
        else {
            tagsSelectedJson = JSON.parse("")
        }
        
        var selectedTags = [String]()
        
        for (key, _):(String, JSON) in tagsSelectedJson {
            selectedTags.append(key)
        }
        
        for tag in self.tags {
            if selectedTags.contains(tag.name!) {
                tag.selected = true
            }
            else {
                tag.selected = false
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("TagsUpdate", object: nil)

    }
}