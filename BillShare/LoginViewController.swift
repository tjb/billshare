//
//  LoginViewController.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/13/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var logoLabel: UILabel?
    var username: UITextField?
    var password: UITextField?
    var login: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.initLabels()
        self.setupActions()
        self.setupViews()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func submit(sender: UIButton) {
//        print("CLICKED HOMIE")
//    }
    
    private func initLabels() {
        self.logoLabel = {
            let label = UILabel()
            label.text = "BillShare"
            label.textAlignment = NSTextAlignment.center
            label.font = label.font.withSize(28)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.username = {
            let textField = UITextField()
            textField.placeholder = "Username"
            textField.borderStyle = UITextBorderStyle.line
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        self.password = {
            let textField = UITextField()
            textField.placeholder = "Password"
            textField.borderStyle = UITextBorderStyle.line
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        self.login = {
            let button = UIButton()
            button.titleLabel?.text = "Login"
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    }
    
    private func setupActions() {
        self.login?.addTarget(self, action: Selector(("submit:")), for: UIControlEvents.touchUpInside)
    }
    
    private func setupViews() {
        if let logoLabel = self.logoLabel,
           let username = self.username,
           let password = self.password,
           let login = self.login {
            self.view.addSubview(logoLabel)
            self.view.addSubview(username)
            self.view.addSubview(password)
            self.view.addSubview(login)
            let viewMap = ["logo": logoLabel, "username": username, "password": password, "login": login]
            self.setSubViewConstraints(viewMap)
        }
    }
    
    private func setSubViewConstraints(_ mainViews: [String: UIView]) {
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[logo]-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[username]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[password]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[login]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[logo]-50-[username]-10-[password]-20-[login]-230-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
