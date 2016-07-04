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
        do {
            let accountData = try validateRegistration(username: username, email: email, password: password, passwordConfirmation: passwordConfirmation)
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
        }
        catch RegistrationError.UsernameNotValidFormat {
            errorHandler("Username is not in a valid format.")
        }
        catch RegistrationError.EmailNotValidFormat {
            errorHandler("Email is not in a valid format.")
        }
        catch RegistrationError.PasswordNotValidFormat {
            errorHandler("Password is not in a valid format.")
        }
        catch RegistrationError.PasswordsDoNotMatch {
            errorHandler("Passwords do not match.")
        }
        catch {
            errorHandler("Account was unable to be created at this time.")
        }
    }
    
    private func initializeNewAccountData(uid: String!, accountData: AccountData, completion: (Void -> Void)) {
        let ref = FIRDatabase.database().reference()
        
        // Create a new user dictionary with default user information
        let newUser = User.generateDefaultUserDictionary(withUsername: accountData.username, email: accountData.email)
        
        // Run both setValue operations concurrently and wait to run the completion block until both are complete
        let dispatchGroup = dispatch_group_create()
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            ref.child("users").child(uid).setValue(newUser)
            NSLog("users done") // Use NSLog for timestamps
        }
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            ref.child("displayNames").child(accountData.username).setValue(uid)
            NSLog("displayNames done")
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            NSLog("running completion handler")
            completion()
        }
    }
    
    
    // MARK: Registration Validator Functions
    
    func validateRegistration(username usernameString: String?, email emailString: String?, password passwordString: String?, passwordConfirmation confirmationString: String?) throws -> AccountData {
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
        
        return AccountData(username: username, email: email, password: password)
    }
    
    private func validateUsername(username: String) -> Bool {
        let usernameRegEx = "^[a-zA-Z-0-9]{3,}$"
        
        guard let usernameValidator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegEx) else {
            return false
        }
        guard usernameValidator.evaluateWithObject(username) else {
            return false
        }
        
        let ref = FIRDatabase.database().reference().child("displayNames/\(username)")
        var usernameDoesNotExist: Bool = true
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                usernameDoesNotExist = false
            }
        })
        
        return usernameDoesNotExist
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