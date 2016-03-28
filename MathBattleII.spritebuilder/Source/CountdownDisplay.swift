//
//  CountdownDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CountdownDisplay: CCLabelTTF {
        
    /**
     Displays the specified `string` on the `CountdownDisplay`.
     - parameter string:   the `String` to be displayed on the `CountdownDisplay`
     */
    func updateCountdownLabel(string string: String) {
        self.string = string
    }
    
    /**
     Hides the `CountdownDisplay`.
     */
    func hideCountdownLabel() {
        self.visible = false
    }
    
    /**
     Makes the `CountdownDisplay` visible.
     */
    func showCountdownLabel() {
        self.visible = true
    }
}