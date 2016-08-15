//
//  IncorrectPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 8/14/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class IncorrectPopup: CCNode {
    
    weak var label: CCLabelTTF!
    
    let startingPosition = CGPoint(x: 0.5, y: 167)
    
    func didLoadFromCCB() {
        self.label.opacity = 0
    }
    
    func setLabel(string string: String) {
        label.string = string
    }
    
    func displayPopup() {
        self.stopAllActions()
        self.label.stopAllActions()
        self.label.position = startingPosition
        self.animationManager.runAnimationsForSequenceNamed("DisplayPopup")
    }
}