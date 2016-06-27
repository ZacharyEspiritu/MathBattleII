//
//  PracticeMatchMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/20/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class PracticeMatchMenu: CCNode {
    
    weak var scroller: PracticeAIScroller!
    weak var chooseButton: CCButton!
    
    func chooseButtonPressed() {
        setupPracticeDataDefaults()
        setupMatchStartingPopup()
    }
    
    private func setupPracticeDataDefaults() {
        NSUserDefaults.standardUserDefaults()
    }
    
    private func setupMatchStartingPopup() {
        let currentUserDisplayName: String = UserManager.sharedInstance.getCurrentUser() != nil ? UserManager.sharedInstance.getCurrentUser()!.getDisplayName() : "Guest"
        MatchStartingPopupHandler.sharedInstance.displayPopup(withHeader: "Practice Match Is Starting...", player1: currentUserDisplayName, player2: "Math_Bot")
    }
}