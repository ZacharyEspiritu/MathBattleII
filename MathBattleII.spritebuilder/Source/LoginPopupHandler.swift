//
//  LoginPopupHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/28/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoginPopupHandler {
    
    static var currentLoginPopup: LoginPopup!
    
    // MARK: Visual Functions
    
    static func displayLoginPopupHandler() {
        currentLoginPopup = CCBReader.load("LoginPopup") as! LoginPopup
        currentLoginPopup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .TopLeft)
        currentLoginPopup.position = CGPoint(x: 0.5, y: 0.5)
        CCDirector.sharedDirector().runningScene.addChild(currentLoginPopup)
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
    
    static func hideLoginPopupHandler() {
        currentLoginPopup.removeFromParent()
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
    
    static func switchModals() {
        
    }
    
    // MARK: Text Field Setup Functions
    
    static func setupTextFields(textFields textFields: [UITextField]) {
        for textField in textFields {
            textField.clipsToBounds = true
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = 8.0
            textField.returnKeyType = .Next
            textField.autocapitalizationType = .None
            textField.autocorrectionType = .No
            textField.spellCheckingType = .No
            textField.clearButtonMode = .WhileEditing
        }
    }
    
    // MARK: Authentication Functions
    
    static func loginAccount(email email: String, password: String) {
        AuthenticationHandler.sharedInstance.authenticateUser(email: email, password: password)
    }
    
    static func registerAccount(username username: String, email: String, password: String, passwordConfirmation: String) {
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
}