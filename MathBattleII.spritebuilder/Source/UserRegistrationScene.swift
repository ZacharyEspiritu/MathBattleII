//
//  UserRegistrationScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/28/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserRegistrationScene: CCNode {
    
    let manager = RegistrationManager.sharedInstance
    
    weak var usernameTextField:        CCTextField!
    weak var emailTextField:           CCTextField!
    weak var passwordTextField:        CCTextField!
    weak var confirmPasswordTextField: CCTextField!
    
    
    func didLoadFromCCB() {
        setupUsernameTextField()
        setupEmailTextField()
    }
    
    func submitRegistration() {
        let username: String? = usernameTextField.string
        let email: String? = emailTextField.string
        let password: String? = passwordTextField.string
        let passwordConfirmation: String? = confirmPasswordTextField.string
        
        do {
            let newAccountData: AccountData = try manager.validateRegistration(username: username, email: email, password: password, passwordConfirmation: passwordConfirmation)
            manager.registerNewAccount(accountData: newAccountData)
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
    
    func menu() {        
        let scene = CCScene()
        scene.addChild(CCBReader.load("MainScene") as! MainScene)
        
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    private func setupUsernameTextField() {
        usernameTextField.textField.delegate = self
        usernameTextField.textField.clipsToBounds = true
        usernameTextField.textField.adjustsFontSizeToFitWidth = true
        usernameTextField.textField.minimumFontSize = 8.0
        usernameTextField.textField.returnKeyType = .Next
        usernameTextField.textField.autocapitalizationType = .None
        usernameTextField.textField.autocorrectionType = .No
        usernameTextField.textField.spellCheckingType = .No
        usernameTextField.textField.clearButtonMode = .WhileEditing
        
        usernameTextField.textField.placeholder = "Username"
    }
    
    private func setupEmailTextField() {
        emailTextField.textField.delegate = self
        emailTextField.textField.clipsToBounds = true
        emailTextField.textField.adjustsFontSizeToFitWidth = true
        emailTextField.textField.minimumFontSize = 8.0
        emailTextField.textField.returnKeyType = .Next
        emailTextField.textField.autocapitalizationType = .None
        emailTextField.textField.autocorrectionType = .No
        emailTextField.textField.spellCheckingType = .No
        emailTextField.textField.clearButtonMode = .WhileEditing
        
        emailTextField.textField.keyboardType = .EmailAddress
        emailTextField.textField.placeholder = "Email"
    }
    
    private func setupPasswordTextField() {
        //        passwordTextField.textField.delegate = self
        passwordTextField.textField.clipsToBounds = true
        passwordTextField.textField.adjustsFontSizeToFitWidth = true
        passwordTextField.textField.minimumFontSize = 8.0
        passwordTextField.textField.returnKeyType = .Next
        passwordTextField.textField.autocapitalizationType = .None
        passwordTextField.textField.autocorrectionType = .No
        passwordTextField.textField.spellCheckingType = .No
        passwordTextField.textField.clearButtonMode = .WhileEditing
        
        passwordTextField.textField.secureTextEntry = true
        passwordTextField.textField.placeholder = "Password"
    }
    
    private func setupConfirmPasswordTextField() {
        //        confirmPasswordTextField.textField.self = self
        confirmPasswordTextField.textField.clipsToBounds = true
        confirmPasswordTextField.textField.adjustsFontSizeToFitWidth = true
        confirmPasswordTextField.textField.minimumFontSize = 8.0
        confirmPasswordTextField.textField.returnKeyType = .Done
        confirmPasswordTextField.textField.autocapitalizationType = .None
        confirmPasswordTextField.textField.autocorrectionType = .No
        confirmPasswordTextField.textField.spellCheckingType = .No
        confirmPasswordTextField.textField.clearButtonMode = .WhileEditing
        
        confirmPasswordTextField.textField.secureTextEntry = true
        confirmPasswordTextField.textField.placeholder = "Confirm Password"
    }
}

extension UserRegistrationScene: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField.textField {
            textField.resignFirstResponder()
            emailTextField.textField.becomeFirstResponder()
        }
        else if textField == emailTextField.textField { // Move to next textField if first textField.
            textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        }
        else if textField == passwordTextField.textField {
            textField.resignFirstResponder()
            confirmPasswordTextField.textField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField.textField { // Call submitLogin() function if last textField.
            textField.resignFirstResponder()
            submitRegistration()
        }
        return false
    }
}