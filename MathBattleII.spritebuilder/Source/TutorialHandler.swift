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
    var currentTutorialPhase: TutorialPhase = .Starting {
        didSet {
            loadTutorialPhase(phase: currentTutorialPhase)
        }
    }
    
    func loadTutorialCover() {
        let tutorialCover = CCBReader.load("TutorialCover") as! TutorialCover
        tutorialCover.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        tutorialCover.position = CGPoint(x: 0.5, y: 0.5)
        CCDirector.sharedDirector().runningScene.addChild(tutorialCover)
        tutorialCover.changeTutorialCover(toType: .Normal)
    }
    
    func switchToNextTutorialPhase() {
        if let phase = TutorialPhase(rawValue: currentTutorialPhase.rawValue + 1) {
            currentTutorialPhase = phase
        }
        else {
            currentTutorialPhase = .EndTutorial
        }
    }
    
    private func loadTutorialPhase(phase tutorialPhase: TutorialPhase) {
        switch tutorialPhase {
        case .Starting:
            tutorialCover.changeTutorialCover(toType: .Normal)
            tutorialCover.setText(string: Config.tutorial.starting)
        case .Grid:
            tutorialCover.changeTutorialCover(toType: .Grid)
            tutorialCover.setText(string: Config.tutorial.grid)
        case .TargetNumber:
            tutorialCover.changeTutorialCover(toType: .TargetNumber)
            tutorialCover.setText(string: Config.tutorial.targetNumber)
        case .ConfirmButton:
            tutorialCover.changeTutorialCover(toType: .ConfirmButton)
            tutorialCover.setText(string: Config.tutorial.confirmButton)
        case .SolveFirstPuzzle:
            tutorialCover.changeTutorialCover(toType: .None)
            tutorialCover.setText(string: Config.tutorial.solveFirstPuzzle)
        case .Timer:
            tutorialCover.changeTutorialCover(toType: .Timer)
            tutorialCover.setText(string: Config.tutorial.timer)
        case .ScoreCounter:
            tutorialCover.changeTutorialCover(toType: .ScoreCounter)
            tutorialCover.setText(string: Config.tutorial.scoreCounter)
        case .SolveFourMorePuzzles:
            tutorialCover.changeTutorialCover(toType: .None)
            tutorialCover.setText(string: Config.tutorial.fourMorePuzzles)
        case .EndGame:
            tutorialCover.changeTutorialCover(toType: .Normal)
            tutorialCover.setText(string: Config.tutorial.endGame)
        case .MainMenu:
            tutorialCover.changeTutorialCover(toType: .Normal)
            tutorialCover.setText(string: Config.tutorial.mainMenu)
        case .MenuButtons:
            tutorialCover.changeTutorialCover(toType: .MenuButtons)
            tutorialCover.setText(string: Config.tutorial.menuButtons)
        case .DataButtons:
            tutorialCover.changeTutorialCover(toType: .DataButtons)
            tutorialCover.setText(string: Config.tutorial.dataButtons)
        case .RankedMatchMenu:
            tutorialCover.changeTutorialCover(toType: .Normal)
            tutorialCover.setText(string: Config.tutorial.rankedMatchMenu)
        case .RankedHeader:
            tutorialCover.changeTutorialCover(toType: .RankedHeader)
            tutorialCover.setText(string: Config.tutorial.rankedHeader)
        case .EndTutorial:
            tutorialCover.changeTutorialCover(toType: .Normal)
            tutorialCover.setText(string: Config.tutorial.endTutorial)
        default:
            assertionFailure("Tutorial Phase not found...")
        }
    }
}

enum TutorialPhase: Int {
    case Starting = 0
    case Grid = 1
    case TargetNumber = 2
    case ConfirmButton = 3
    case SolveFirstPuzzle = 4
    case Timer = 5
    case ScoreCounter = 6
    case SolveFourMorePuzzles = 7
    case EndGame = 8
    case MainMenu = 9
    case MenuButtons = 10
    case DataButtons = 11
    case RankedMatchMenu = 12
    case RankedHeader = 13
    case EndTutorial = 14
}