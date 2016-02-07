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
            NSLog("users done") // Use NSLog for timestamps
        }
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            ref.childByAppendingPath("displayNames").setValue(newDisplayName)
            NSLog("displayNames done")
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            NSLog("running completion handler")
            completion()
        }
    }
    
    func validateRegistration(username usernameString: String?, email emailString: String?, password passwordString: String?, passwordConfirmation confirmationString: String?) throws -> Account {
        // Validate that registration fields match required format
        guard let username = usernameString where validateUsername(username) else {
            throw RegistrationError.UsernameNotValidFormat
        }
        guard let email = emailString where validateEmail(email) else {
            throw RegistrationError.EmailNotValidFormat
        }
        guard let password = passwordString where validatePassword(password) else {
            throw RegistrationError.PasswordNotValidFormat
        }
        guard let passwordConfirmation = confirmationString where validateMatchingPasswords(password1: password, password2: passwordConfirmation) else {
            throw RegistrationError.PasswordsDoNotMatch
        }
        
        return Account(username: username, email: email, password: password)
    }
    
    private func validateUsername(username: String) -> Bool {
        let usernameRegEx = "^[a-zA-Z-0-9]{3,}$"
        
        guard let usernameValidator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegEx) else {
            return false
        }
        return usernameValidator.evaluateWithObject(username)
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        guard let emailValidator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx) else {
            return false
        }
        return emailValidator.evaluateWithObject(email)
    }
    
    private func validatePassword(password: String) -> Bool {
        return password.characters.count >= 6
    }
    
    private func validateMatchingPasswords(password1 password1: String, password2: String) -> Bool {
        return password1 == password2
    }
}

enum RegistrationError: ErrorType {
    case UsernameNotValidFormat
    case EmailNotValidFormat
    case PasswordNotValidFormat
    case PasswordsDoNotMatch
}