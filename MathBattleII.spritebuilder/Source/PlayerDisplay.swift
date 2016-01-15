//
//  PlayerDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class PlayerDisplay: CCSprite {
    
    private weak var targetNumberLabel: CCLabelTTF!
    private weak var equationLabel: CCLabelTTF!
    
    func setTargetNumberLabel(targetNumber targetNumber: Int) {
        targetNumberLabel.string = "\(targetNumber)"
    }
    
    func setEquationLabel(equation equation: String) {
        equationLabel.string = equation
    }
}