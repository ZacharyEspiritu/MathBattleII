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
                    print("new account data initalized")
                    self.authenticationHandler.authenticateUser(email: account.email, password: account.password)
                })
            }
        })
    }
    
    private func initializeNewAccountData(uid: String!, account: Account, completion: (Void -> Void)) {
        let ref = Firebase(url: Config.firebaseURL)
        
        // Create a new user dictionary with default user information
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
        
        // Create a new dictionary for storing the display name in a secondary list
        let newDisplayName = [ account.username : uid ]
        
        // Run both setValue operations concurrently and wait to run the completion block until both are complete
        let dispatchGroup = dispatch_group_create()
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            ref.childByAppendingPath("users").childByAppendingPath(uid)
                .setValue(newUser)
            NSLog("users done")
        }
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            ref.childByAppendingPath("displayNames").setValue(newDisplayName)
            NSLog("displayNames done")
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            NSLog("running completion")
            completion()
        }
    }
}