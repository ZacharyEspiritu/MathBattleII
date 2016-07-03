//
//  LoginPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/27/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoginPopup: CCNode {
    
    weak var focusOut: CCSprite!
    weak var loginModal: LoginModal!
    weak var registrationModal: RegistrationModal!
    
    func didLoadFromCCB() {
        runOpeningAnimations()
    }
    
    private func runOpeningAnimations() {
        focusOut.opacity = 0
        focusOut.runAction(CCActionEaseSineOut(action: CCActionFadeTo(duration: 0.5, opacity: 1)))
        loginModal.position = CGPoint(x: 0.5, y: -0.5)
        loginModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: 0.5, position: CGPoint(x: 0.5, y: 0.5))))
        registrationModal.position = CGPoint(x: 1.5, y: 0.5)
    }
}
