//
//  MainDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MainDisplay: CCSprite {
    
    weak var topPlayerNameLabel, bottomPlayerNameLabel, timerLabel: CCLabelTTF!
    
    func didLoadFromCCB() {
        topPlayerNameLabel.string = "testset"
        bottomPlayerNameLabel.string = "Testasfsdf"
    }
    
    /**
     Sets the `topPlayerNameLabel` string.
     - parameter string:  the `String` to set the `topPlayerNameLabel` to
     */
    func setTopPlayerLabel(string string: String) {
        topPlayerNameLabel.string = string
    }
    
    /**
     Sets the `bottomPlayerNameLabel` string.
     - parameter string:  the `String` to set the `bottomPlayerNameLabel` to
     */
    func setBottomPlayerLabel(string string: String) {
        bottomPlayerNameLabel.string = string
    }
    
    /**
     Sets the `timerLabel` string.
     - parameter string:  the `String` to set the `timerLabel` to
     */
    func setTimerLabel(string string: String) {
        timerLabel.string = string
    }
}