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
}