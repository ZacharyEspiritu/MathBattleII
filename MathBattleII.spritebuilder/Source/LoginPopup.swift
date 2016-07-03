//
//  LoginPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/27/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LoginPopup: CCNode {
    
    weak var focusOutButton: CCButton!
    weak var focusOut: CCSprite!
    weak var loginModal: LoginModal!
    weak var registrationModal: RegistrationModal!
    
    var currentModal: AuthenticationModalType = .LoginModal
    
    let animationDuration = 0.4
    
    
    // MARK: Button Functions 
    
    func didLoadFromCCB() {
        setupDelegates()
        runOpeningAnimations()
    }
    
    func focusOutButtonPressed() {
        LoginPopupHandler.hideLoginPopupHandler()
    }
    
    
    // MARK: Data Functions
    
    private func setupDelegates() {
        loginModal.delegate = self
        registrationModal.delegate = self
    }
    
    // MARK: Animation Functions
    
    private func runOpeningAnimations() {
        focusOut.opacity = 0
        focusOut.runAction(CCActionEaseSineOut(action: CCActionFadeTo(duration: animationDuration, opacity: 1)))
        loginModal.position = CGPoint(x: 0.5, y: -0.5)
        loginModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 0.5, y: 0.5))))
        registrationModal.position = CGPoint(x: 1.5, y: 0.5)
    }
    
    private func toggleModals() {
        stopAllActions()
        currentModal = currentModal == .LoginModal ? .RegistrationModal : .LoginModal
        switch currentModal {
        case .LoginModal:
            loginModal.position = CGPoint(x: -0.5, y: 0.5)
            registrationModal.position = CGPoint(x: 0.5, y: 0.5)
            loginModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 0.5, y: 0.5))))
            registrationModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 1.5, y: 0.5))))
        case .RegistrationModal:
            loginModal.position = CGPoint(x: 0.5, y: 0.5)
            registrationModal.position = CGPoint(x: 1.5, y: 0.5)
            loginModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: -0.5, y: 0.5))))
            registrationModal.runAction(CCActionEaseSineOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 0.5, y: 0.5))))
        }
    }
}

extension LoginPopup: LoginModalDelegate {
    
    func loginDetailButtonPressed(loginModal: LoginModal) {
        toggleModals()
    }
}

extension LoginPopup: RegistrationModalDelegate {
    
    func registrationDetailButtonPressed(registrationModal: RegistrationModal) {
        toggleModals()
    }
}

enum AuthenticationModalType {
    case LoginModal
    case RegistrationModal
}