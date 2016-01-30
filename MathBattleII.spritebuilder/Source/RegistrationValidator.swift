//
//  RegistrationValidator.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/29/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RegistrationValidator {
    
    static let sharedInstance = RegistrationValidator()
    private init() {}
    
    
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
        // A password must have at least 8 characters and have a number, capital letter, and lowercase letter. Since RegEx doesn't have an AND operator, we check to see if the string matches disallowed cases.
        let passwordRegEx = "^(.{0,7}|[^0-9]*|[^A-Z]*|[^a-z]*)$"
        
        guard let passwordValidator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx) else {
            return false
        }
        return !passwordValidator.evaluateWithObject(password)
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