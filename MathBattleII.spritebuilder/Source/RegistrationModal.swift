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
    weak var safetyButton: CCButton!
    weak var loginPopupAlertModal: LoginPopupAlertModal!
    
    var delegate: RegistrationModalDelegate?
    
    func didLoadFromCCB() {
        safetyButton.enabled = false
        setupTextFields()
    }
    
    // MARK: Button Functions
    
    func mainButtonPressed() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        let username = usernameTextField.string
        let email = emailTextField.string
        let password = passwordTextField.string
        let passwordConfirmation = confirmPasswordTextField.string
        RegistrationManager.sharedInstance.registerNewAccount(username: username, email: email, password: password, passwordConfirmation: passwordConfirmation, errorHandler: { errorDescription in
            self.loginPopupAlertModal.setAlert(string: errorDescription)
            self.loginPopupAlertModal.displayAlert()
        })
    }
    
    func detailButtonPressed() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        delegate?.registrationDetailButtonPressed(self)
    }
    
    // MARK: Data Functions
    
    private func setupTextFields() {
        LoginPopupHandler.setupTextFields(textFields: [usernameTextField.textField, emailTextField.textField, passwordTextField.textField, confirmPasswordTextField.textField])
        emailTextField.textField.keyboardType = .EmailAddress
        passwordTextField.textField.secureTextEntry = true
    }
}

protocol RegistrationModalDelegate {
    
    func registrationDetailButtonPressed(registrationModal: RegistrationModal)
}