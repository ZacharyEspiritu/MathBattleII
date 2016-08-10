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
    weak var loginPopupAlertModal: LoginPopupAlertModal!
    
    var delegate: LoginModalDelegate?
    
    func didLoadFromCCB() {
        setupTextFields()
    }
    
    // MARK: Button Functions
    
    func mainButtonPressed() {
        disableButtons()
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        
        let email = emailTextField.string
        let password = passwordTextField.string
        AuthenticationHandler.sharedInstance.authenticateUser(email: email, password: password,
            completionHandler: {
                self.delegate?.loginAuthenticationCompletedSuccessfully(self)
                self.mainButton.label.string = "Success!"
            }, errorHandler: { errorDescription in
                self.loginPopupAlertModal.setAlert(string: errorDescription)
                self.loginPopupAlertModal.displayAlert()
                self.enableButtons()
        })
    }
    
    func detailButtonPressed() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        delegate?.loginDetailButtonPressed(self)
    }
    
    func closeButtonPressed() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        delegate?.loginCloseButtonPressed(self)
    }
    
    // MARK: Safety Functions
    
    private func disableButtons() {
        detailButton.enabled = false
        mainButton.enabled = false
        mainButton.label.string = "Loading..."
    }
    
    private func enableButtons() {
        detailButton.enabled = true
        mainButton.enabled = true
        mainButton.label.string = "Log In"
    }
    
    // MARK: Data Functions
    
    private func setupTextFields() {
        LoginPopupHandler.setupTextFields(textFields: [emailTextField.textField, passwordTextField.textField])
        emailTextField.textField.keyboardType = .EmailAddress
        passwordTextField.textField.secureTextEntry = true
    }
}

protocol LoginModalDelegate {
    
    func loginDetailButtonPressed(loginModal: LoginModal)
    func loginAuthenticationCompletedSuccessfully(loginModal: LoginModal)
    func loginCloseButtonPressed(loginModal: LoginModal)
}