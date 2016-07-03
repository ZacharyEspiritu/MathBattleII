//
//  RegistrationModal.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/2/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RegistrationModal: CCNode {
    
    weak var usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField: CCTextField!
    weak var mainButton, detailButton: CCButton!
    
    func didLoadFromCCB() {
        setupTextFields()
    }
    
    // MARK: Button Functions
    
    func mainButtonPressed() {
        let username = usernameTextField.string
        let email = emailTextField.string
        let password = passwordTextField.string
        let passwordConfirmation = confirmPasswordTextField.string
        LoginPopupHandler.registerAccount(username: username, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func detailButtonPressed() {
        LoginPopupHandler.switchModals()
    }
    
    // MARK: Data Functions
    
    private func setupTextFields() {
        LoginPopupHandler.setupTextFields(textFields: [usernameTextField.textField, emailTextField.textField, passwordTextField.textField, confirmPasswordTextField.textField])
        emailTextField.textField.keyboardType = .EmailAddress
        passwordTextField.textField.secureTextEntry = true
    }
}