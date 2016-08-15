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
        let sample: RawPostItem = RawPostItem(title: "Introducing Lazer", creator: "Team Super Monkey Bomb", pubDate: NSDate(), link: "https://github.com/zizhengwu/lazer", abstract: "Welcome to Lazer! Lazer wants to provide meaningful relaxation to you. By choosing your favourite topics, you will get the most interesting content tailored for you.", content: "Welcome to Lazer! Lazer wants to provide meaningful relaxation to you. By choosing your favourite topics, you will get the most interesting content tailored for you. <br><br>Lazer is certainly not another app to overwhelm you with endless information that you are not interested in. You could only read within your accepted relaxation / bucket time. When time is up, you will be reminded that you should get back to work. <br><br>Enjoy reading and keep working!", imageHeading: "http://i.imgur.com/JoTiTtg.png", creatorAvatar: "http://i.imgur.com/hmyoWhi.png")
        insertData(sample)
    }
    
    func loadData() {

    }

}