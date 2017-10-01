//
//  UserAccount.swift
//  BillShare
//
//  Created by Tyler Bobella on 10/1/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import Foundation
import Locksmith

struct UserAccount: ReadableSecureStorable,
                   CreateableSecureStorable,
                   DeleteableSecureStorable,
                   GenericPasswordSecureStorable {
    
    let email: String
    let password: String
    
    let service = "Billshare"
    var account: String { return email }
    var data: [String: Any] {
        return ["password": password]
    }
}
