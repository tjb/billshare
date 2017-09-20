//
//  UserService.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/12/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import UIKit
import Alamofire
import Sync

class UserService: NSObject {
    
    let dataStack: DataStack
    
    required init(_ dataStack: DataStack) {
        self.dataStack = dataStack
    }
    
    func findById(_ id: Int16) {
        Alamofire.request("http://localhost:8080/user/\(id)").responseJSON { response in
            let data = response.result.value as! [String : Any]
            
            self.dataStack.sync([data], inEntityNamed: "User", completion: { error in
                if let err = error {
                    print("Error syncing: \(String(describing: err))")
                }
            })
        }
    }
}
