//
//  User+CoreDataClass.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/5/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var id: Int16
    @NSManaged public var bills: Set<Bill>?
    @NSManaged public var percentage: Percentage?

}
