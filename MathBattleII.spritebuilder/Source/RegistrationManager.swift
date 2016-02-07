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
        print("registering new account")
        let ref = Firebase(url: Config.firebaseURL)
        ref.createUser(account.email, password: account.password, withValueCompletionBlock: { error, result in
            if error != nil {
                // There was an error creating the account
                print("Account was unable to be created.")
            } else {
                // User authentication complete!
                let uid = result["uid"] as? String
                print("Successfully created user account with uid: \(uid)")
                
                self.initializeNewAccountData(uid, account: account, completion: { Void in
                    self.authenticationHandler.authenticateUser(email: account.email, password: account.password)
                })
            }
        })
    }
    
    private func initializeNewAccountData(uid: String!, account: Account, completion: (Void -> Void)) {
        let ref = Firebase(url: Config.firebaseURL)
        // Create a new user dictionary accessing the user's info
        // provided by the authData parameter
        let newUser = [
            "displayName": account.username,
            "email": account.email,
            "numberOfGamesPlayed": 0,
            "numberOfWins": 0,
            "numberOfLosses": 0,
            "provider": "password",
            "rating": 1000,
            "ratingFloor": 700,
            "friends": []
        ]
        
        // Create a child path with a key set to the uid underneath the "users" node
        // This creates a URL path like the following:
        //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
        ref.childByAppendingPath("users").childByAppendingPath(uid)
            .setValue(newUser)
        
        completion()
    }
}