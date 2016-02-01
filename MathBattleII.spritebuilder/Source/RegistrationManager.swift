//
//  RegistrationManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/29/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RegistrationManager {
    
    let authenticationHandler = AuthenticationHandler.sharedInstance
    
    static let sharedInstance = RegistrationManager()
    private init() {}
    
    
    func registerNewAccount(account account: Account) {
        let firebaseReference = Firebase(url: Config.firebaseURL)
        firebaseReference.createUser(account.email, password: account.password,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                    print("Account was unable to be created.")
                } else {
                    // User authentication complete!
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    self.authenticationHandler.authenticateUser(email: account.email, password: account.password)
                }
        })
    }
}