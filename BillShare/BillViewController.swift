//
//  BillViewControllerCollectionViewController.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/4/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class BillViewController: UIViewController {
    
    var bills: [Bill] = []
    let billsFetch: NSFetchRequest<Bill> = NSFetchRequest<Bill>(entityName: "Bill")
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Register cell classes
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.dataController.managedObjectContext
        
        do {
            let fetchedBills = try moc.fetch(billsFetch)
            bills = fetchedBills
        } catch {
            fatalError("Failed to fetch bills: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BillViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width - 25, height: 75)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return bills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BillCell else {
            fatalError("Cannot cast cell!")
        }
        
        // Configure the cell
        
        cell.bill = bills[indexPath.row]
        cell.backgroundColor = UIColor.lightText
        
        return cell
    }
    
}
