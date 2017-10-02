//
//  LeftViewController.swift
//  BillShare
//
//  Created by Tyler Bobella on 10/1/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        let tableViewVC = MenuListViewController()
        tableViewVC.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableViewVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewVC.tableView.register(MenuCell.self, forCellReuseIdentifier: "Cell")
        tableViewVC.view.frame = self.view.frame
        
        self.addChildViewController(tableViewVC)
        self.view.addSubview(tableViewVC.tableView)
        self.setSubViewConstraints(["tableVC": tableViewVC.tableView])
    }
    
    private func setSubViewConstraints(_ mainViews: [String: UIView]) {
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[tableVC]-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-300-[tableVC]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
    }

}
