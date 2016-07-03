//
//  LoginModal.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/2/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoginModal: CCNode {
    
    weak var emailTextField, passwordTextField: CCTextField!
    weak var mainButton, detailButton: CCButton!
    
    func didLoadFromCCB() {
        setupTextFields()
    }
    
    // MARK: Button Functions
    
    func mainButtonPressed() {
        let email = emailTextField.string
        let password = passwordTextField.string
        LoginPopupHandler.loginAccount(email: email, password: password)
    }
    
    func detailButtonPressed() {
        LoginPopupHandler.switchModals()
    }
    
    // MARK: Data Functions
    
    private func setupTextFields() {
        LoginPopupHandler.setupTextFields(textFields: [emailTextField.textField, passwordTextField.textField])
        emailTextField.textField.keyboardType = .EmailAddress
        passwordTextField.textField.secureTextEntry = true
    }
}