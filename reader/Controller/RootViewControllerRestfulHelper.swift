import Foundation
import Alamofire
import SwiftyJSON

extension RootViewController {
    func retrieveArticles() {
        var urlsToBeRetrieved = [String]()
        for tag in UserProfileController.sharedInstance.tags {
            if tag.selected == true {
                urlsToBeRetrieved.append(tag.url!)
            }
        }
        print(urlsToBeRetrieved)
        
        let group = dispatch_group_create()
        
        for url in urlsToBeRetrieved {
            dispatch_group_enter(group)
            Alamofire.request(.POST, "http://chi01.xuleijr.com/api/subscriptions/7c96422964215320482", parameters: ["channels": url])
                .responseString { response in
                    dispatch_group_leave(group)
                    if let value = response.result.value {
                        let json = JSON.parse(value as String)["items"]
                        for (_, item):(String, JSON) in json {
                            let post = RawPostItem(title: item["title"].string!, creator: "creator", pubDate: NSDate(), link: item["link"].string!, abstract: item["summary"].string!, content: item["original"].string!, imageHeading: item["cover"].string!, creatorAvatar: item["icon"].string!)
                            self.insertData(post)
                        }
                    }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.ifEmptyThenAddTutorial()
            self.header.endRefreshing()
        }
    }
}