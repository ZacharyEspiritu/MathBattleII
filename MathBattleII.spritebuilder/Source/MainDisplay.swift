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
    private var timerLabelIsFlashing: Bool = false
    
    func didLoadFromCCB() {
        topPlayerNameLabel.string = "guest"
        bottomPlayerNameLabel.string = "zespiritu17"
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
    private func setTimerLabel(string string: String) {
        timerLabel.string = string
    }
    
    /**
     Parses the inputted time and updates the `timerLabel` based on the input.
     - parameter timeRemaining:  the amount of time remaining
     */
    func updateTimerLabel(timeRemaining timeRemaining: Int) {
        let seconds: Int = timeRemaining % 60
        let minutes: Int = (timeRemaining / 60) % 60
        self.setTimerLabel(string: String(format: "%02d:%02d", minutes, seconds))
        
        if timeRemaining <= 30 {
            if !timerLabelIsFlashing {
                timerLabel.color = CCColor(red: 1, green: 0, blue: 0)
                timerLabelIsFlashing = true
            }
            else {
                timerLabel.color = CCColor(white: 1, alpha: 1)
                timerLabelIsFlashing = false
            }
        }
    }
}