//
//  OnboardingViewController.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/30/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit
import Locksmith

class OnboardingViewController: UIViewController {
    
    var login: UIButton?
    var signUp: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.initLabels()
        self.setupViews()
        self.setupActions()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if checkKeychainForCredentials() {
            self.present(ViewController(), animated: true, completion: nil)
        }
    }
    
    private func initLabels() {
        self.login = {
            let login = UIButton()
            login.titleLabel?.text = "Login"
            login.setTitle("Login", for: UIControlState.normal)
            login.backgroundColor = UIColor.gray
            login.translatesAutoresizingMaskIntoConstraints = false
            return login
        }()
        
        self.signUp = {
            let signUp = UIButton()
            signUp.titleLabel?.text = "Sign Up"
            signUp.setTitle("Sign Up", for: UIControlState.normal)
            signUp.backgroundColor = UIColor.gray
            signUp.translatesAutoresizingMaskIntoConstraints = false
            return signUp
        }()
    }
    
    func login(sender: UIButton) {
        let loginVc = LoginViewController()
        self.present(loginVc, animated: true, completion: nil)
    }
    
    func signUp(sender: UIButton) {
        
    }
    
    private func setupViews() {
        if let login = self.login, let signUp = self.signUp {
            self.view.addSubview(login)
            self.view.addSubview(signUp)
            let viewMap = ["login": login, "signUp": signUp]
            self.setSubViewConstraints(viewMap)
        }
    }
    
    private func checkKeychainForCredentials() -> Bool {
        let prefs = UserDefaults.standard
        if let email = prefs.value(forKey: "email") as? String {
            let result = Locksmith.loadDataForUserAccount(userAccount: email, inService: "Billshare")
            if (result == nil) {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    private func setupActions() {
        self.login?.addTarget(self, action: #selector(login(sender:)), for: UIControlEvents.touchUpInside)
        self.signUp?.addTarget(self, action: #selector(signUp(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    private func setSubViewConstraints(_ mainViews: [String: UIView]) {
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[signUp]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[login]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-560-[login]-10-[signUp]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))

    }

}
