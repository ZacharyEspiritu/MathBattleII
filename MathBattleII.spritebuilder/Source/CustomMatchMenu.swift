//
//  CustomMatchMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/20/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CustomMatchMenu: CCNode {
    
    weak var messageHeader: CustomMatchMessageHeader!
    weak var menuButtonNode: CustomMatchMenuButtons!
    weak var centerAreaGroupingNode: CCNode!
    weak var customMatchTextEntry: CustomMatchTextEntry!
    weak var backButton, confirmButton: CCButton!
    
    var matchMenuType: CustomMatchMenuType = .Create {
        didSet {
            confirmButton.label.string = (matchMenuType == .Create) ? "Create" : "Join"
        }
    }
    
    
    func didLoadFromCCB() {
        centerAreaGroupingNode.position.x = 1.50
        menuButtonNode.position.x = 0.5
        menuButtonNode.delegate = self
    }
    
    func backButtonPressed() {
        let centerAreaXPosition: CGFloat = (matchMenuType == .Join) ? 1.5 : -1.5
        centerAreaGroupingNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: centerAreaXPosition, y: centerAreaGroupingNode.position.y))))
        menuButtonNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: 0.5, y: centerAreaGroupingNode.position.y))))
        
        customMatchTextEntry.enabled = true
        confirmButton.enabled = true
        messageHeader.setMessage(string: "Custom Match") // TODO: Error Checking
        
        // TODO: If cancel match, then delete from Firebase database
    }
    
    func confirmMatchInformation() {
        guard let _ = UserManager.sharedInstance.getCurrentUser() else {
            print("User is not logged in!")
            return
        }
        
        let matchName = customMatchTextEntry.getMatchName()
        let password = customMatchTextEntry.getMatchPassword()
        if matchMenuType == .Create {
            Matchmaker.sharedInstance.createNewCustomMatch(withCustomName: matchName, customPassword: password)
        }
        else {
            Matchmaker.sharedInstance.attemptToJoinCustomMatch(matchName: matchName, password: password)
        }
        
        customMatchTextEntry.enabled = false
        confirmButton.enabled = false
        messageHeader.setMessage(string: "Waiting For Opponent") // TODO: Error Checking
    }
}

enum CustomMatchMenuType {
    case Create
    case Join
}

extension CustomMatchMenu: CustomMatchMenuButtonsDelegate {
    
    func joinButtonPressed() {
        matchMenuType = .Join
        centerAreaGroupingNode.position.x = 1.5
        centerAreaGroupingNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: 0.5, y: centerAreaGroupingNode.position.y))))
        menuButtonNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: -1.5, y: centerAreaGroupingNode.position.y))))
    }
    
    func createButtonPressed() {
        matchMenuType = .Create
        centerAreaGroupingNode.position.x = -1.5
        centerAreaGroupingNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: 0.5, y: centerAreaGroupingNode.position.y))))
        menuButtonNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: 0.3, position: CGPoint(x: 1.5, y: centerAreaGroupingNode.position.y))))
    }
}