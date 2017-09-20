//
//  BillPercentage+CoreDataClass.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/10/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import Foundation
import CoreData

@objc(Percentage)
public class Percentage: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Percentage> {
        return NSFetchRequest<Percentage>(entityName: "Percentage")
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var percentage: NSDecimalNumber?
    @NSManaged public var user_id: Int16
    @NSManaged public var bill_id: Int16
    @NSManaged public var user: User?
    @NSManaged public var bill: Bill?

}
