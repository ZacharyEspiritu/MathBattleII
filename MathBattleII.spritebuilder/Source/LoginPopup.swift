//
//  LoginPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/27/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoginPopup: CCNode {
    
    let loginViewHeight: CGFloat = 137
    let registrationViewHeight: CGFloat = 233
    let animationConstant: CGFloat = 10
    
    weak var background: CCSprite9Slice!
    weak var detailButton, mainButton: CCButton!
    weak var usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField: CCTextField!
    
    var currentLoginView: LoginView = .Login
    
    
    // MARK: CCBReader Callbacks
    
    func didLoadFromCCB() {
        setupTextFields()
    }
    
    func detailButtonPressed() {
        toggleView()
    }
    
    func mainButtonPressed() {
        switch currentLoginView {
        case .Login:
            loginAccount()
        case .Registration:
            registerAccount()
        }
    }
    
    
    // MARK: Data Functions
    
    private func toggleView() {
        if currentLoginView == .Login {
            currentLoginView = .Registration
        }
        else {
            currentLoginView = .Login
        }
    }
    
    private func loginAccount() {
        let email: String = emailTextField.string
        let password: String = passwordTextField.string
        
        AuthenticationHandler.sharedInstance.authenticateUser(email: email, password: password)
    }
    
    private func registerAccount() {
        let username: String = usernameTextField.string
        let email: String = emailTextField.string
        let password: String = passwordTextField.string
        let passwordConfirmation: String = confirmPasswordTextField.string
        
        do {
            let newAccountData: AccountData = try RegistrationManager.sharedInstance.validateRegistration(username: username, email: email, password: password, passwordConfirmation: passwordConfirmation)
            RegistrationManager.sharedInstance.registerNewAccount(accountData: newAccountData)
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
    
    private func setupTextFields() {
        let textFields = [usernameTextField.textField, emailTextField.textField, passwordTextField.textField, confirmPasswordTextField.textField]
        for textField in textFields {
            textField.delegate = self
            textField.clipsToBounds = true
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = 8.0
            textField.returnKeyType = .Next
            textField.autocapitalizationType = .None
            textField.autocorrectionType = .No
            textField.spellCheckingType = .No
            textField.clearButtonMode = .WhileEditing
        }
        
        usernameTextField.textField.placeholder = "Username"
        
        emailTextField.textField.keyboardType = .EmailAddress
        emailTextField.textField.placeholder = "Email"
        
        passwordTextField.textField.secureTextEntry = true
        passwordTextField.textField.placeholder = "Password"
        
        confirmPasswordTextField.textField.secureTextEntry = true
        confirmPasswordTextField.textField.placeholder = "Confirm Password"
    }
    
    
    // MARK: Animation Functions
    
    override func update(delta: CCTime) {
        if currentLoginView == .Login && self.contentSize.height > loginViewHeight {
            self.contentSize.height -= animationConstant
            if self.contentSize.height < loginViewHeight {
                self.contentSize.height = loginViewHeight
            }
        }
        else if currentLoginView == .Login && self.contentSize.height < registrationViewHeight {
            self.contentSize.height += animationConstant
            if self.contentSize.height > registrationViewHeight {
                self.contentSize.height = registrationViewHeight
            }
        }
    }
}

extension LoginPopup: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField.textField { // Move to next textField if first textField.
            textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        }
        else if textField == passwordTextField.textField { // Call submitLogin() function if last textField.
            textField.resignFirstResponder()
            // submitLogin()
        }
        return false
    }
}

enum LoginView {
    case Login
    case Registration
}
