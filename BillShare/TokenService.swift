//
//  TokenService.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/30/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit
import Alamofire

class TokenService: NSObject {
    let env = ProcessInfo.processInfo.environment
    let userPreferences = UserDefaults.standard
    
    func getToken(completionHandler: @escaping (_ token: String?, _ error: String?) -> ()) {
        guard let api = env["api"], env["api"] != nil else {
            print("Error getting API URL from Environment")
            return
        }
        
        let headers: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        if let email = userPreferences.value(forKey: "email") as? String, let password = userPreferences.value(forKey: "password") as? String {
            let params: [String: Any] = [
                "grant_type": "password",
                "scope": "read write",
                "username": email,
                "password": password
            ]
            
            Alamofire.request("\(api)/oauth/token", method: .post, parameters: params, encoding: URLEncoding(destination: .queryString), headers: headers)
                .authenticate(user: "billshare", password: "")
                .responseJSON { response in
                    switch response.result {
                    case .failure:
                        completionHandler(nil, nil)
                    case .success:
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            self.userPreferences.setValue(JSON["access_token"] as! String, forKey: "token")
                            self.userPreferences.synchronize()
                            if (JSON["access_token"] as? String) != nil {
                                completionHandler(JSON["access_token"] as? String, nil)
                            }
                        }
                    }
            }
        }
        print("Error with User Preferences")
    }
    
    func storeToken(token: String?, completionHandler: @escaping (_ didSave: Bool) -> ()) {
        if (token != nil) {
            self.userPreferences.setValue(token, forKey: "token")
            self.userPreferences.synchronize()
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
}
