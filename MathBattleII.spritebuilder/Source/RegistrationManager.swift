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
    
    
    // MARK: Firebase-Interacting Functions
    
    func registerNewAccount(username username: String, email: String, password: String, passwordConfirmation: String) {
        registerNewAccount(username: username, email: email, password: password, passwordConfirmation: passwordConfirmation, completionHandler: { _ in }, errorHandler: { _ in })
    }
    
    func registerNewAccount(username username: String, email: String, password: String, passwordConfirmation: String, completionHandler: (Void -> Void), errorHandler: (String) -> ()) {
        validateRegistration(username: username, email: email, password: password, passwordConfirmation: passwordConfirmation,
            completionHandler: { accountData in
                FIRAuth.auth()?.createUserWithEmail(accountData.email, password: accountData.password, completion: { user, error in
                    if let user = user {
                        // User authentication complete!
                        let uid = user.uid
                        print("Successfully created user account with uid: \(uid)")                        
                        self.initializeNewAccountData(uid, accountData: accountData, completion: { Void in
                            self.authenticationHandler.authenticateUser(email: accountData.email, password: accountData.password, completionHandler: completionHandler, errorHandler: errorHandler)
                        })
                    } else {
                        if let error = error {
                            if let errorCode = FIRAuthErrorCode(rawValue: error.code) { // TODO: Handle all ErrorCode cases
                                let errorDescription = FirebaseErrorReader.convertToHumanReadableAlertDescription(errorCode)
                                errorHandler(errorDescription)
                            }
                        }
                    }
                })
            }, errorHandler: { errors in
                if let firstError = errors.first {
                    errorHandler(firstError)
                }
                else {
                    errorHandler("An error occurred while registering\nyour account. Try again later.")
                }
        })
    }
    
    private func initializeNewAccountData(uid: String!, accountData: AccountData, completion: (Void -> Void)) {
        let ref = FIRDatabase.database().reference()
        
        // Create a new user dictionary with default user information
        let newUser = User.generateDefaultUserDictionary(withUsername: accountData.username, email: accountData.email)
        
        // Run both setValue operations concurrently and wait to run the completion block until both are complete
        let dispatchGroup = dispatch_group_create()
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            ref.child("users").child(uid).setValue(newUser)
        }
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            ref.child("displayNames").child(accountData.username).setValue(uid)
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            completion()
        }
    }
    
    
    // MARK: Registration Validator Functions
    
    func validateRegistration(username username: String, email: String, password: String, passwordConfirmation: String, completionHandler: (AccountData -> Void), errorHandler: ([String] -> Void)) {
        var errors: [String] = []
        let dispatchGroup = dispatch_group_create()
        // Validate username
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if let error = self.validateUsername(username) {
                errors.append(error)
            }
        }
        // Validate email
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if let error = self.validateEmail(email) {
                errors.append(error)
            }
        }
        // Validate password
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if let error = self.validatePassword(password) {
                errors.append(error)
            }
        }
        // Confirm passwords match
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if let error = self.validateMatchingPasswords(password1: password, password2: passwordConfirmation) {
                errors.append(error)
            }
        }
        // Run completion/error handler
        dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if errors.count > 0 {
                errorHandler(errors)
            }
            else {
                completionHandler(AccountData(username: username, email: email, password: password))
            }
        }
    }
    
    private func validateUsername(username: String) -> String? {
        let usernameRegEx = "^[a-zA-Z-0-9]{3,}$"
        let usernameValidator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        guard usernameValidator.evaluateWithObject(username) else {
            return "Username must be at least 3 characters long\n" +
                   "and can only contain letters and numbers."
        }
        
        let ref = FIRDatabase.database().reference().child("displayNames/\(username)")
        var usernameDoesNotExist: Bool = true
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                usernameDoesNotExist = false
            }
        })
        guard usernameDoesNotExist else {
            return "An account with specified\n" +
                   "username already exists."
        }
        return nil
    }
    
    private func validateEmail(email: String) -> String? {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailValidator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        guard emailValidator.evaluateWithObject(email) else {
            return "Email is not valid."
        }
        return nil
    }
    
    private func validatePassword(password: String) -> String? {
        guard password.characters.count >= 6 else {
            return "Password must be at least\n" +
                   "6 characters long."
        }
        return nil
    }
    
    private func validateMatchingPasswords(password1 password1: String, password2: String) -> String? {
        guard password1 == password2 else {
            return "Passwords do not match."
        }
        return nil
    }
}

enum RegistrationError: ErrorType {
    case UsernameNotValidFormat(String)
    case EmailNotValidFormat(String)
    case PasswordNotValidFormat(String)
    case PasswordsDoNotMatch
}