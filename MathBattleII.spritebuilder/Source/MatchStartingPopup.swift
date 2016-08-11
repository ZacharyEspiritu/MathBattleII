//
//  MatchStartingPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/22/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MatchStartingPopup: CCNode {
    
    weak var background: CCSprite9Slice!
    weak var headerLabel, infoLabel, countdownLabel: CCLabelTTF!
    weak var focusOutButton: CCButton!
    
    
    func didLoadFromCCB() {
        focusOutButton.enabled = false
    }

    func setHeaderLabel(string string: String) {
        headerLabel.string = string
    }
    
    func setInfoLabel(string string: String) {
        infoLabel.string = string
        self.contentSize = CGSize(width: 256, height: infoLabel.contentSize.height + 122)
    }
    
    func setCountdownLabel(string string: String) {
        countdownLabel.string = string
    }
}