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
    
    func shakeDisplay() {
        let targetNumberShake = CCActionMoveTo(duration: 0.2, position: CGPoint(x: (((CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5 ? -1 : 1) * (drand48() / 10)) + 0.50), y: (CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5 ? -1 : 1) * Double(arc4random_uniform(3)) + 51.5))
        let targetNumberPositionRestore = CCActionMoveTo(duration: 0.2, position: CGPoint(x: 0.50, y: 51.5))
        let targetNumberRotate = CCActionRotateTo(duration: 0.2, angle: (CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5 ? -1 : 1) * Float(arc4random_uniform(5)))
        let targetNumberRotationRestore = CCActionRotateTo(duration: 0.2, angle: 0)
        targetNumberLabel.runAction(CCActionSequence(array: [targetNumberShake, targetNumberPositionRestore]))
        targetNumberLabel.runAction(CCActionSequence(array: [targetNumberRotate, targetNumberRotationRestore]))
        
        let equationLabelShake = CCActionMoveTo(duration: 0.2, position: CGPoint(x: (((CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5 ? -1 : 1) * (drand48() / 10)) + 0.50), y: (CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5 ? -1 : 1) * Double(arc4random_uniform(3)) + 2.5))
        let equationLabelPositionRestore = CCActionMoveTo(duration: 0.2, position: CGPoint(x: 0.50, y: 2.5))
        let equationLabelRotate = CCActionRotateTo(duration: 0.2, angle: (CGFloat(Float(arc4random()) / Float(UINT32_MAX)) < 0.5 ? -1 : 1) * Float(arc4random_uniform(3)))
        let equationLabelRotationRestore = CCActionRotateTo(duration: 0.2, angle: 0)
        equationLabel.runAction(CCActionSequence(array: [equationLabelShake, equationLabelPositionRestore]))
        equationLabel.runAction(CCActionSequence(array: [equationLabelRotate, equationLabelRotationRestore]))
    }
    
    func sneakIntoCorrectPosition() {
        let targetNumberPositionRestore = CCActionMoveTo(duration: 0.2, position: CGPoint(x: 0.50, y: 51.5))
        let targetNumberRotationRestore = CCActionRotateTo(duration: 0.2, angle: 0)
        targetNumberLabel.runAction(targetNumberPositionRestore)
        targetNumberLabel.runAction(targetNumberRotationRestore)
        
        let equationLabelPositionRestore = CCActionMoveTo(duration: 0.2, position: CGPoint(x: 0.50, y: 2.5))
        let equationLabelRotationRestore = CCActionRotateTo(duration: 0.2, angle: 0)
        equationLabel.runAction(equationLabelPositionRestore)
        equationLabel.runAction(equationLabelRotationRestore)
    }
}