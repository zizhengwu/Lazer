import Foundation
import CoreData
import UIKit

extension RootViewController {
    
    func clearData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                let entityNames = ["PostItem"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest(entityName: entityName)
                    
                    let objects = try(context.executeFetchRequest(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.deleteObject(object)
                        try(context.save())
                    }
                }
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func insertData(rawPostItem: RawPostItem) {
        if let context = delegate?.managedObjectContext {
            
            let sample = NSEntityDescription.insertNewObjectForEntityForName("PostItem", inManagedObjectContext: context) as! PostItem
            
            sample.title = rawPostItem.title
            sample.creator = rawPostItem.creator
            sample.pubDate = rawPostItem.pubDate
            sample.link = rawPostItem.link
            sample.abstract = rawPostItem.abstract
            sample.content = rawPostItem.content
            sample.imageHeading = rawPostItem.imageHeading
            sample.creatorAvatar = rawPostItem.creatorAvatar
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func loadSampleData() {
        let sample: RawPostItem = RawPostItem(title: "Introducing Lazer", creator: "Team Super Monkey Bomb", pubDate: NSDate(), link: "https://zizhengwu.com/about", abstract: "Welcome to Lazer! Lazer works as an information hub that aims to provide meaningful relax to the users. By choosing from different topic categories, users will build their own personal information hub with up to date articles.", content: "Welcome to Lazer! Lazer works as an information hub that aims to provide meaningful relax to the users. By choosing from different topic categories, users will build their own personal information hub with up to date articles. Now Lazer is available on both iOS and Android platform.<br><br>Lazer is certainly not another app to overwhelm you with endless information that you are not interested in. Lazer allows you to change topic preference at any time. After setting up each relax time period, Lazer articles will only be active within that period. When time is up, users will only see a quote after reading their current article. Only after the preset cool down time, which must be more than 30 minutes, will our inspiring quote be updated by new article set. <br><br>Categorizing and aggregating information is not easy. One of our goals is to make the life easier for our users, who only need to care about topics. What happens behind the curtain is more delicate. We modelled topics as top layer nodes. They point to source nodes in the intermediate hidden layer. Each source node generates new articles and hence needs checking periodically. <br><br>Harvesting articles from various sources is an automated process, while the association between topics and sources are maintained by content strategists. By simply connecting or disconnecting sources with topics, they could vastly alter what the users get. To help this role efficiently tailor content, an application is crucial to reduce the overhead that every tiny modification has go through the backend engineers. <br><br>This interface is available on both desktops and handheld devices. Source could be easily filtered by name and locate the ones to modify. Changes to the sources are automatically saved and accompanied by a very handy preview feature when applicable. We believe that content strategists are empowered by this responsive design to discover, re-organize and optimize, so that the articles delivered to the end devices are pertinent, abundant and engaging. <br><br>", imageHeading: "http://i.imgur.com/JoTiTtg.png", creatorAvatar: "http://i.imgur.com/hmyoWhi.png")
        insertData(sample)
    }
    
    func loadData() {

    }

}