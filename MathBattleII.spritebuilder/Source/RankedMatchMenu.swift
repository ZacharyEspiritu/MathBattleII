//
//  RankedMatchMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class RankedMatchMenu: CCNode {
    
    weak var rankingsButton, activityLogButton, achievementsButton, infoButton: CCButton!
    weak var rankedMatchButtonGroupingNode, playerHeaderGroupingNode: CCNode!
    weak var rankedPlayerHeader: RankedPlayerHeader!
    weak var focusOut: CCNodeColor!
    
    var delegate: RankedMatchMenuDelegate?
    
    // MARK: Button Functions
    
    func didLoadFromCCB() {
        focusOut.opacity = 0
        MenuDisplayManager.sharedInstance.attachToRankedPlayerHeader(rankedPlayerHeader)
        userInteractionEnabled = true
    }
    
    func battleButtonPressed() {
        let gameplayScene = CCBReader.load("MatchCreate") as! MatchCreate
        let scene = CCScene()
        scene.addChild(gameplayScene)
        let transition = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func rankingsButtonPressed() {
        delegate?.rankingsButtonPressed(self)
    }
    
    func activityLogButtonPressed() {
        delegate?.activityLogButtonPressed(self)
    }
    
    func achievementsButtonPressed() {
        delegate?.achievementsButtonPressed(self)
    }
    
    func infoButtonPressed() {
        delegate?.infoButtonPressed(self)
    }
    
    private func rankedPlayerHeaderPressed() {
        if let user = UserManager.sharedInstance.getCurrentUser() {
            UserPopupHandler.displayUserPopup(forUser: user)
        }
        else {
            LoginPopupHandler.displayLoginPopup()
        }
    }
    
    // MARK: User Interaction Function
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if CGRectContainsPoint(rankedPlayerHeader.boundingBox(), touch.locationInNode(playerHeaderGroupingNode)) {
            rankedPlayerHeader.runAction(CCActionScaleTo(duration: 0.05, scale: 0.95))
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if rankedPlayerHeader.scale < 1 {
            if CGRectContainsPoint(rankedPlayerHeader.boundingBox(), touch.locationInNode(playerHeaderGroupingNode)) {
                rankedPlayerHeaderPressed()
            }
            rankedPlayerHeader.stopAllActions()
            rankedPlayerHeader.runAction(CCActionEaseBackOut(action: CCActionScaleTo(duration: 0.15, scale: 1)))
        }
    }
}

protocol RankedMatchMenuDelegate {
    
    func rankingsButtonPressed(rankedMatchMenu: RankedMatchMenu)
    func activityLogButtonPressed(rankedMatchMenu: RankedMatchMenu)
    func achievementsButtonPressed(rankedMatchMenu: RankedMatchMenu)
    func infoButtonPressed(rankedMatchMenu: RankedMatchMenu)
}