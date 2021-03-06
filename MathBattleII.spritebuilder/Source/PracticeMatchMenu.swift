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
    
    func didLoadFromCCB() {
        FIRAnalytics.logEventWithName("practice_match_menu_opened", parameters: nil)
    }
    
    func chooseButtonPressed() {
        setupPracticeDataDefaults()
        setupMatchStartingPopup()
    }
    
    private func setupPracticeDataDefaults() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isPracticeMatch")
    }
    
    private func setupMatchStartingPopup() {
        let currentUserDisplayName: String = UserManager.sharedInstance.getCurrentUser() != nil ? UserManager.sharedInstance.getCurrentUser()!.getDisplayName() : "Guest"
        MatchStartingPopupHandler.sharedInstance.displayPopup(withHeader: "Practice Match Is Starting...", player1: currentUserDisplayName, player2: "Math_Bot")
        
        let loggedIn: Bool = (UserManager.sharedInstance.getCurrentUser() != nil) ? true : false
        FIRAnalytics.logEventWithName("practice_match_started", parameters: [
            "logged_in": loggedIn
        ])
    }
}