//
//  UserPopupHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/7/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserPopupHandler {
    
    static var currentUserPopup: UserPopup!
    
    // MARK: Visual Functions
    
    static func displayUserPopup(forUser user: User) {
        currentUserPopup = CCBReader.load("UserPopup") as! UserPopup
        currentUserPopup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .TopLeft)
        currentUserPopup.position = CGPoint(x: 0.5, y: 0.5)
        currentUserPopup.displayUserData(forUser: user)
        CCDirector.sharedDirector().runningScene.addChild(currentUserPopup)
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
    
    static func hideUserPopup() {
        currentUserPopup.removeFromParent()
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
    }
}