//
//  DataHelper.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/4/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import Foundation
import CoreData

public class DataHelper {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seedDataStore() {
        clearAllData()
        print("Seeding CoreData...")
        seedBills()
    }
    
    private func seedBills() {
        let date: Date = NSDate(timeIntervalSince1970: 1505606400) as Date
        let bills = [
            (company: "Comcast", amount: 100.00, dueDate: date)
        ]
        
        bills.forEach { bill in
            let newBill = NSEntityDescription.insertNewObject(forEntityName: "Bill", into: context) as! Bill
            newBill.amount = bill.amount
            newBill.company = bill.company
            newBill.dueDate = bill.dueDate
        }
        
        do {
            try context.save()
            print("Seeding Bill completed.")
        } catch {
            let nsError = error as NSError
            print("Error seeding Drink: \(nsError)")
        }
    }
    
    
    private func clearAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bill")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("Data cleared.")
        } catch let error as NSError {
            let nsError = error as NSError
            print("Error seeding Drink: \(nsError)")
        }
    }
}
