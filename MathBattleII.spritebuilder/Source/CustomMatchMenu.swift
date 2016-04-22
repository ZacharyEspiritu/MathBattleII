//
//  CustomMatchMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/20/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CustomMatchMenu: CCNode {
    
    weak var playerHeader: CCSprite!
    weak var customMatchTextEntry: CustomMatchTextEntry!
    weak var backButton, confirmButton: CCButton!
    
    var matchMenuType: CustomMatchMenuType = .Create {
        didSet {
            confirmButton.label.string = (matchMenuType == .Create) ? "Create" : "Join"
        }
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
    }
}

enum CustomMatchMenuType {
    case Create
    case Join
}