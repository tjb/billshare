//
//  ViewController.swift
//  BillShare
//
//  Created by Tyler Bobella on 8/29/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit
import CoreData
import SideMenu

class ViewController: UIViewController {
    
    var bills: [Bill] = []
    let billsFetch: NSFetchRequest<Bill> = NSFetchRequest<Bill>(entityName: "Bill")
    var totalMonthlyAmountLabel: UILabel?
    
    var hamburger: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let leftVC = UISideMenuNavigationController(rootViewController: MenuViewController())
        leftVC.leftSide = true
        leftVC.setNavigationBarHidden(true, animated: false)
        SideMenuManager.menuLeftNavigationController = leftVC
        SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
        SideMenuManager.menuFadeStatusBar = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.dataController.managedObjectContext

        do {
            let fetchedBills = try moc.fetch(billsFetch)
            bills = fetchedBills
            initLabels()
            setupViews()
            setupActions()
        } catch {
            fatalError("Failed to fetch bills: \(error)")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openMenu(sender: UIButton!) {
        self.present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func initLabels() {
        self.totalMonthlyAmountLabel = {
            let label = UILabel()
            label.text = Double().currencyFormatter(value: self.calculateTotalOwed(self.bills))
            label.textAlignment = NSTextAlignment.center
            label.font = label.font.withSize(28)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.hamburger = {
            let hamburger = UIButton()
            hamburger.setImage(UIImage(named: "Hamburger"), for: UIControlState.normal)
            hamburger.translatesAutoresizingMaskIntoConstraints = false
            return hamburger
        }()
    }
    
    func setupViews() {
        if let line = LineSeparator().draw(Line.horizontal) {
            
            let collectionVC = BillViewController()
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: 200, height: 200)
            collectionVC.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionVC.collectionView.register(BillCell.self, forCellWithReuseIdentifier: "Cell")
            collectionVC.collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            collectionVC.view.frame = self.view.frame
            self.addChildViewController(collectionVC)
            self.view.addSubview(collectionVC.collectionView)
            self.view.addSubview(line)
            self.view.addSubview(self.totalMonthlyAmountLabel!)
            self.view.addSubview(self.hamburger!)
            collectionVC.didMove(toParentViewController: self)
            self.setSubViewConstraints(["mainLabel": self.totalMonthlyAmountLabel!, "line": line, "billCV": collectionVC.collectionView, "hamburger": self.hamburger!])
        }
    }
    
    func setupActions() {
        self.hamburger?.addTarget(self, action: #selector(openMenu(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    private func setSubViewConstraints(_ mainViews: [String: UIView]) {
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[hamburger]", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[billCV]-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[mainLabel]-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[line]-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[billCV]-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[mainLabel]-15-[line(1)]-15-[billCV]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[hamburger]", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        
    }
    
    private func calculateTotalOwed(_ bills: [Bill]) -> Double {
        
        return bills.map({ (bill: Bill) -> Double in
            if let percent = bill.percentages?.first,
               let amount = Double().getProperAmountDue(price: bill.price, percentage: percent) {
                return amount
            }
            return 0.0
        }).reduce(0, {$0 + $1})
        
    }

}

