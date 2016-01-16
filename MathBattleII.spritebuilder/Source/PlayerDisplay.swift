//
//  PlayerDisplay.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/15/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class PlayerDisplay: CCSprite {
    
    weak var targetNumberLabel: CCLabelTTF!
    weak var equationLabel: CCLabelTTF!
    
    /**
     Sets the `targetNumberLabel` to display the `targetNumber` parameter.
     - parameter targetNumber:   the `Int` to display
     */
    func setTargetNumberLabel(targetNumber targetNumber: Int) {
        targetNumberLabel.string = "\(targetNumber)"
    }
    
    /**
     Sets the `equationLabel` to display the `equation` parameter.
     - parameter equation:   the `String` to display
     */
    func setEquationLabel(equation equation: String) {
        equationLabel.string = equation
    }
    
    /**
     Returns the `String` currently displaying on the `equationLabel`.
     - returns:   the `String` currently displaying on the `equationLabel`
     */
    func getEquationLabelString() -> String {
        return equationLabel.string
    }
    
    /**
     Clears the `equationLabel`.
     */
    func clearEquationLabel() {
        equationLabel.string = ""
    }
}