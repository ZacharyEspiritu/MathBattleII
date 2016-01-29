//
//  UserRegistrationScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/28/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserRegistrationScene: CCNode {
    
    weak var usernameTextField:        CCTextField!
    weak var emailTextField:           CCTextField!
    weak var passwordTextField:        CCTextField!
    weak var confirmPasswordTextField: CCTextField!
    
    func submitRegistration() {
        do {
            try validateRegistration()
        }
        catch RegistrationError.UsernameNotValidFormat {
            print("Username is not in a valid format.")
        }
        catch RegistrationError.EmailNotValidFormat {
            print("Email is not in a valid format.")
        }
        catch RegistrationError.PasswordNotValidFormat {
            print("Password is not in a valid format.")
        }
        catch RegistrationError.PasswordsDoNotMatch {
            print("Passwords do not match.")
        }
        catch {
            print("Something went wrong...")
        }
    }
    
    func validateRegistration() throws {
        // Validate that registration fields match required format
        guard let username = usernameTextField.string where validateUsername(username) else {
            throw RegistrationError.UsernameNotValidFormat
        }
        guard let email = emailTextField.string where validateEmail(email) else {
            throw RegistrationError.EmailNotValidFormat
        }
        guard let password = passwordTextField.string where validatePassword(password) else {
            throw RegistrationError.PasswordNotValidFormat
        }
        guard let passwordConfirmation = confirmPasswordTextField.string where validateMatchingPasswords(password1: password, password2: passwordConfirmation) else {
            throw RegistrationError.PasswordsDoNotMatch
        }
        
        
    }
    
    private func validateUsername(username: String) -> Bool {
        if username.characters.count < 3 {
            return false
        }
        return true
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        guard let emailValidator: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx) else {
            return false
        }
        return emailValidator.evaluateWithObject(email)
    }
    
    private func validatePassword(password: String) -> Bool {
        if password.characters.count < 6 {
            return false
        }
        return true
    }
    
    private func validateMatchingPasswords(password1 password1: String, password2: String) -> Bool {
        if password1 == password2 {
            return true
        }
        return false
    }
}

enum RegistrationError: ErrorType {
    case UsernameNotValidFormat
    case EmailNotValidFormat
    case PasswordNotValidFormat
    case PasswordsDoNotMatch
}