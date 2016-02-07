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
    
    
    func submitLogin() {
        let email: String = emailTextField.string
        let password: String = passwordTextField.string
        
        auth.authenticateUser(email: email, password: password)
    }
}