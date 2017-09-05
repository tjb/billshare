//
//  Bill+CoreDataClass.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/4/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import Foundation
import CoreData

public class Bill: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bill> {
        return NSFetchRequest<Bill>(entityName: "Bill")
    }
    
    @NSManaged public var amount: Double
    @NSManaged public var company: String?
    @NSManaged public var dueDate: Date

}
