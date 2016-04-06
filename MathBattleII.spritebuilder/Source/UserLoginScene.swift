//
//  UserLoginScene.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/28/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserLoginScene: CCNode {
    
    let auth = AuthenticationHandler.sharedInstance
    
    weak var emailTextField:           CCTextField!
    weak var passwordTextField:        CCTextField!
    
    
    func didLoadFromCCB() {
        setupEmailTextField()
        setupPasswordTextField()
    }
    
    func submitLogin() {
        let email: String = emailTextField.string
        let password: String = passwordTextField.string
        auth.authenticateUser(email: email, password: password)
    }
    
    func menu() {
        let scene = CCScene()
        scene.addChild(CCBReader.load("MainScene") as! MainScene)
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
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
        passwordTextField.textField.returnKeyType = .Done
        passwordTextField.textField.autocapitalizationType = .None
        passwordTextField.textField.autocorrectionType = .No
        passwordTextField.textField.spellCheckingType = .No
        passwordTextField.textField.clearButtonMode = .WhileEditing
        
        passwordTextField.textField.secureTextEntry = true
        passwordTextField.textField.placeholder = "Password"
    }
}

extension UserLoginScene: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField.textField { // Move to next textField if first textField.
            textField.resignFirstResponder()
            passwordTextField.textField.becomeFirstResponder()
        }
        else if textField == passwordTextField.textField { // Call submitLogin() function if last textField.
            textField.resignFirstResponder()
            submitLogin()
        }
        return false
    }
}