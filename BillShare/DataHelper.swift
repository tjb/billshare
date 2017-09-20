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
            (name: "Comcast", price: 100.00, dueDate: date)
        ]
        
        bills.forEach { bill in
            let newBill = NSEntityDescription.insertNewObject(forEntityName: "Bill", into: context) as! Bill
            newBill.price = bill.price
            newBill.name = bill.name
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
    
    private func seedUsers() {
        let users = [
            (first: "Tyler", last: "Bobella", id: 1)
        ]
        
        users.forEach { user in
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            newUser.first = user.first
            newUser.last = user.last
            newUser.id = Int16(user.id)
        }
        
        do {
            try context.save()
            print("Seeding Users completed.")
        } catch {
            let nsError = error as NSError
            print("Error seeding Users: \(nsError)")
        }
    }
    
    private func seedBillPercentage() {
        let percentages = [
            (id: 1, bill_id: 1, user_id: 1, percentage: 0.25)
        ]
        
        percentages.forEach { percentage in
            let newPercentage = NSEntityDescription.insertNewObject(forEntityName: "Percentage", into: context) as! Percentage
            newPercentage.id = Int16(percentage.id)
            newPercentage.user_id = Int16(percentage.user_id)
            newPercentage.bill_id = Int16(percentage.bill_id)
            newPercentage.percentage = percentage.percentage as? NSDecimalNumber
        }
        
        do {
            try context.save()
            print("Seeding Percentages completed.")
        } catch {
            let nsError = error as NSError
            print("Error seeding Percentages: \(nsError)")
        }
    }
    
    private func seedRelationships() {
        do {
            let bills = try context.fetch(NSFetchRequest<Bill>(entityName: "Bill"))
            let percentages = try context.fetch(NSFetchRequest<Percentage>(entityName: "Percentage"))
            let users = try context.fetch(NSFetchRequest<User>(entityName: "User"))
            
            bills.forEach { bill in
                users.first?.bills?.update(with: bill)
                percentages.first?.bill = bill
            }
            
            percentages.forEach { percentage in
                bills.first?.percentages?.update(with: percentage)
            }

            
            try context.save()
            print("Relationships set.")
        } catch {
            let nsError = error as NSError
            print("Error setting relationships: \(nsError)")
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
