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
    
    
    // MARK: CCB Functions 
    
    func didLoadFromCCB() {
        focusOutButton.enabled = false
        setupDelegates()
        runOpeningAnimations()
        userInteractionEnabled = true
    }
    
    func closePopup() {
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
    
    private func runClosingAnimations() {
        focusOutButton.enabled = false
        focusOut.opacity = 1
        focusOut.runAction(CCActionEaseSineOut(action: CCActionFadeTo(duration: animationDuration, opacity: 0)))
        let modalFlyOutAnimation = CCActionSequence(array: [CCActionEaseSineOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 0.5, y: 1.5))), CCActionCallBlock(block: { LoginPopupHandler.hideLoginPopupHandler() })])
        switch currentModal {
        case .LoginModal:
            loginModal.runAction(modalFlyOutAnimation)
        case .RegistrationModal:
            registrationModal.runAction(modalFlyOutAnimation)
        }
    }
}

extension LoginPopup: LoginModalDelegate {
    
    func loginDetailButtonPressed(loginModal: LoginModal) {
        toggleModals()
    }
    
    func loginAuthenticationCompletedSuccessfully(loginModal: LoginModal) {
        runClosingAnimations()
    }
    
    func loginCloseButtonPressed(loginModal: LoginModal) {
        closePopup()
    }
}

extension LoginPopup: RegistrationModalDelegate {
    
    func registrationDetailButtonPressed(registrationModal: RegistrationModal) {
        toggleModals()
    }
    
    func registrationCompletedSuccessfully(registrationModal: RegistrationModal) {
        runClosingAnimations()
    }
    
    func registrationCloseButtonPressed(registrationModal: RegistrationModal) {
        closePopup()
    }
}

enum AuthenticationModalType {
    case LoginModal
    case RegistrationModal
}