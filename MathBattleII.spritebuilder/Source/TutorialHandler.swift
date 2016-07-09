//
//  TutorialHandler.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/9/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class TutorialHandler {
    
    static let sharedInstance = TutorialHandler()
    private init() { }
    
    var tutorialCover: TutorialCover!
    
    func loadTutorialCover() {
        let tutorialCover = CCBReader.load("TutorialCover") as! TutorialCover
        tutorialCover.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        tutorialCover.position = CGPoint(x: 0.5, y: 0.5)
        CCDirector.sharedDirector().runningScene.addChild(tutorialCover)
    }
    
    func switchToNextTutorialPhase() {
        
    }
}

enum TutorialPhase: Int {
    case Starting
    case Grid = 1
    case TargetNumber
    case ConfirmButton
    case SolveFirstPuzzle
    case Timer
    case ScoreCounter
    case SolveFourMorePuzzles
    case None, Normal, DataButtons, MenuButtons, RankedHeader
}