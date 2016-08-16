//
//  PostItem+CoreDataProperties.swift
//  Lazer
//
//  Created by Zizheng Wu on 8/11/16.
//  Copyright © 2016 zizhengwu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PostItem {
    
    @NSManaged var title: String?
    @NSManaged var creator: String?
    @NSManaged var creatorAvatar: String?
    @NSManaged var imageHeading: String?
    @NSManaged var link: String?
    @NSManaged var pubDate: NSDate?
    @NSManaged var abstract: String?
    @NSManaged var content: String?
    
}
