//
//  CountdownDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/19/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class CountdownDisplay: CCNode {
    
    weak var background: CCNodeColor!
    weak var label: CCLabelTTF!
    
    
    func updateCountdownLabel(string string: String) {
        label.string = string
    }
    
    func hideCountdownLabel() {
        self.visible = false
    }
    
    func showCountdownLabel() {
        self.visible = true
    }
}