//
//  Account.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/29/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Account {
    
    var username: String
    var email: String
    var password: String
    
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}