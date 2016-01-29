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
    
    func submitRegistration() {
        do {
            try manager.validateRegistration(username: usernameTextField.string, email: emailTextField.string, password: passwordTextField.string, passwordConfirmation: confirmPasswordTextField.string)
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