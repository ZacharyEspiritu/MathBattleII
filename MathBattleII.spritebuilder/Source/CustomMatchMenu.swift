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
    weak var alertOverlay: CCNodeColor!
    
    var matchMenuType: CustomMatchMenuType = .Create {
        didSet {
            confirmButton.label.string = (matchMenuType == .Create) ? "Create" : "Join"
        }
    }
    
    // MARK: Constants
    
    let animationDuration = 0.4
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        centerAreaGroupingNode.position.x = 1.50
        menuButtonNode.position.x = 0.5
        menuButtonNode.delegate = self
        alertOverlay.cascadeOpacityEnabled = true
        alertOverlay.opacity = 0
    }
    
    func backButtonPressed() {
        if let _ = Matchmaker.sharedInstance.currentMatchData {
            Matchmaker.sharedInstance.deleteCurrentMatchFromFirebase(withCompletionHandler: { _ in
                self.resetModalPositions()
            })
        }
        else {
            resetModalPositions()
        }
    }
    
    func confirmMatchInformation() {
        guard let _ = UserManager.sharedInstance.getCurrentUser() else {
            displayAlertOverlay()
            return
        }
        
        let matchName = customMatchTextEntry.getMatchName()
        let password = customMatchTextEntry.getMatchPassword()
        
        if validateCustomMatchInput(matchName: matchName, password: password) {
            customMatchTextEntry.enabled = false
            confirmButton.enabled = false
            backButton.enabled = false
            messageHeader.setMessage(string: "Attempting\nTo Join...")
            
            registerForCustomMatch(withMatchName: matchName, password: password,
                completionHandler: { _ in
                    self.backButton.enabled = true
                    self.messageHeader.setMessage(string: "Joined Match!\nWaiting For Other\nPlayer...")
                }, errorHandler: { error in
                    self.customMatchTextEntry.enabled = true
                    self.confirmButton.enabled = true
                    if error == "Match with given name not found." {
                        self.messageHeader.setMessage(string: "Match Not\nFound")
                    }
                    else {
                        self.messageHeader.setMessage(string: "An Error Occured\nTry Again")
                    }
                }, startHandler: { hostPlayerName, opposingPlayerName in
                    self.backButton.enabled = false
                    MatchStartingPopupHandler.sharedInstance.displayPopup(withHeader: "Custom Match\nIs Starting...", player1: hostPlayerName, player2: opposingPlayerName, duration: 15)
            })
        }
    }
    
    private func resetModalPositions() {
        let centerAreaXPosition: CGFloat = (matchMenuType == .Join) ? 1.5 : -1.5
        centerAreaGroupingNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: centerAreaXPosition, y: centerAreaGroupingNode.position.y))))
        menuButtonNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 0.5, y: centerAreaGroupingNode.position.y))))
        
        customMatchTextEntry.enabled = true
        confirmButton.enabled = true
        messageHeader.setMessage(string: "Custom\nMatch")
    }
    
    private func displayAlertOverlay() {
        alertOverlay.stopAllActions()
        alertOverlay.runAction(CCActionSequence(array: [CCActionFadeTo(duration: 0.15, opacity: 0.7), CCActionDelay(duration: 2), CCActionFadeTo(duration: 0.2, opacity: 0)]))
    }
    
    private func registerForCustomMatch(withMatchName matchName: String, password: String, completionHandler: (Void -> Void), errorHandler: (String -> Void), startHandler: (String, String) -> (Void)) {
        if matchMenuType == .Create {
            Matchmaker.sharedInstance.createNewCustomMatch(withCustomName: matchName, customPassword: password, completionHandler: completionHandler, errorHandler: errorHandler, startHandler: startHandler)
        }
        else {
            Matchmaker.sharedInstance.attemptToJoinCustomMatch(matchName: matchName, password: password, completionHandler: completionHandler, errorHandler: errorHandler, startHandler: startHandler)
        }
    }
    
    private func validateCustomMatchInput(matchName matchName: String, password: String) -> Bool {
        guard matchName.characters.count >= 6 && password.characters.count >= 6 else {
            messageHeader.setMessage(string: "Six Characters\nMinimum")
            return false
        }
        
        let badCharacters = NSCharacterSet.letterCharacterSet().invertedSet
        guard matchName.rangeOfCharacterFromSet(badCharacters) == nil && password.rangeOfCharacterFromSet(badCharacters) == nil else {
            messageHeader.setMessage(string: "Only Letters\nAre Allowed")
            return false
        }
        
        return true
    }
}

enum CustomMatchMenuType {
    case Create
    case Join
}

extension CustomMatchMenu: CustomMatchMenuButtonsDelegate {
    
    func joinButtonPressed() {
        guard let _ = UserManager.sharedInstance.getCurrentUser() else {
            displayAlertOverlay()
            return
        }
        
        matchMenuType = .Join
        centerAreaGroupingNode.position.x = 1.5
        centerAreaGroupingNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 0.5, y: centerAreaGroupingNode.position.y))))
        menuButtonNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: -1.5, y: centerAreaGroupingNode.position.y))))
    }
    
    func createButtonPressed() {
        guard let _ = UserManager.sharedInstance.getCurrentUser() else {
            displayAlertOverlay()
            return
        }
        
        matchMenuType = .Create
        centerAreaGroupingNode.position.x = -1.5
        centerAreaGroupingNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 0.5, y: centerAreaGroupingNode.position.y))))
        menuButtonNode.runAction(CCActionEaseBackOut(action: CCActionMoveTo(duration: animationDuration, position: CGPoint(x: 1.5, y: centerAreaGroupingNode.position.y))))
    }
}