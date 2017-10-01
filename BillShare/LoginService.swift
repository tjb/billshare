//
//  LoginService.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/23/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit
import Alamofire

class LoginService: NSObject {

    let env = ProcessInfo.processInfo.environment
    let userPreferences = UserDefaults.standard
    
    func authenticateUser(username: String, password: String, completionHandler: @escaping (_ data: Result<Any>?, _ error: Error?) -> ()) {
        guard let api = env["api"], env["api"] != nil else {
            print("Error getting API URL from Environment")
            return
        }
        
        let params: [String: Any] = [
            "email": username,
            "password": password
        ]
        
        Alamofire.request("\(api)/user/login", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .failure:
                completionHandler(nil, response.error)
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    let email = JSON["email"] as! String
                    self.userPreferences.setValue(email, forKey: "email")
                    self.userPreferences.setValue(password, forKey: "password")
                    self.userPreferences.synchronize()
                    print("Saving email and password successful!")
                }
                
                completionHandler(response.result, nil)
            }
        }
    }
}
