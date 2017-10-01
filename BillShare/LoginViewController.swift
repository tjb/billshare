//
//  LoginViewController.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/13/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController {
    
    var logoLabel: UILabel?
    var username: UITextField?
    var password: UITextField?
    var login: UIButton?
    var close: UIButton?
    var loginError: UIAlertController = UIAlertController(title: "Error", message: "Incorrect email and/or password", preferredStyle: UIAlertControllerStyle.alert)
    var tokenError: UIAlertController = UIAlertController(title: "Error", message: "Token error. Please contact support.", preferredStyle: UIAlertControllerStyle.alert)
    let dashboardVC = ViewController()

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
        self.username?.becomeFirstResponder()
    }
    
    
    func submit(sender: UIButton!) {
        if let username = self.username?.text, let password = self.password?.text {
            LoginService().authenticateUser(username: username, password: password, completionHandler: { reponse, error in
                if let error = error as NSError? {
                    //segue to popup
                    print("Error: \(error)")
                    self.present(self.loginError, animated: true, completion: nil)
                }
                
                // Locksmith
                
                let account = UserAccount(email: username, password: password)
                
                if self.store(account) {
                    TokenService().getToken(completionHandler: { token, error in
                        if (error == nil) {
                            TokenService().storeToken(token: token, completionHandler: { didStore in
                                if (didStore) {
                                    self.present(self.dashboardVC, animated: true, completion: nil)
                                } else {
                                    self.present(self.loginError, animated: true, completion: nil)
                                }
                            })
                        }
                    })
                    
                }
            })
        }
    }
    
    func close(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func store(_ account: UserAccount) -> Bool {
        do {
            try account.createInSecureStore()
        } catch LocksmithError.duplicate {
            guard let _ = try? account.updateInSecureStore() else { return false }
        } catch let error {
            print("Couldn't store: \(error)")
            return false
        }
        return true
    }
    
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
            textField.autocapitalizationType = .none
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        self.password = {
            let textField = UITextField()
            textField.placeholder = "Password"
            textField.borderStyle = UITextBorderStyle.line
            textField.autocapitalizationType = .none
            textField.isSecureTextEntry = true
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        self.login = {
            let button = UIButton()
            button.titleLabel?.text = "Login"
            button.backgroundColor = UIColor.gray
            button.setTitle("Login", for: UIControlState.normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        self.close = {
            let close = UIButton()
            close.titleLabel?.text = "x"
            close.backgroundColor = UIColor.gray
            close.setTitle("x", for: UIControlState.normal)
            close.translatesAutoresizingMaskIntoConstraints = false
            return close
        }()
    }
    
    private func setupActions() {
        self.login?.addTarget(self, action: #selector(submit(sender:)), for: UIControlEvents.touchUpInside)
        self.close?.addTarget(self, action: #selector(close(sender:)), for: UIControlEvents.touchUpInside)
        
        // alert actions
        loginError.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        tokenError.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
    }
    
    private func setupViews() {
        if let logoLabel = self.logoLabel,
           let username = self.username,
           let password = self.password,
           let close = self.close,
           let login = self.login {
            self.view.addSubview(logoLabel)
            self.view.addSubview(username)
            self.view.addSubview(password)
            self.view.addSubview(login)
            self.view.addSubview(close)
            let viewMap = ["logo": logoLabel, "username": username, "password": password, "login": login, "close": close]
            self.setSubViewConstraints(viewMap)
        }
    }
    
    private func setSubViewConstraints(_ mainViews: [String: UIView]) {
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[close]", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[logo]-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[username]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[password]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[login]-100-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[close]", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[logo]-25-[username]-10-[password]-20-[login]-355-|", options: NSLayoutFormatOptions(), metrics: nil, views: mainViews))
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
