//
//  TutorialCover.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/9/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class TutorialCover: CCNode {
    
    weak var normalFadeOut, confirmButtonFadeOut, dataButtonsFadeOut, gridFadeOut, menuButtonsFadeOut, rankedHeaderFadeOut, scoreCounterFadeOut, targetNumberFadeOut, timerFadeOut: CCSprite!
    var tutorialCovers: [CCSprite] = []
    
    var currentTutorialCover: TutorialCoverType = .None {
        didSet {
            changeTutorialCover(toType: currentTutorialCover)
        }
    }
    
    func didLoadFromCCB() {
        tutorialCovers = [normalFadeOut, confirmButtonFadeOut, dataButtonsFadeOut, gridFadeOut, menuButtonsFadeOut, rankedHeaderFadeOut, scoreCounterFadeOut, targetNumberFadeOut, timerFadeOut]
        resetAllTutorialCovers()
    }
    
    private func resetAllTutorialCovers() {
        for tutorialCover in tutorialCovers {
            tutorialCover.opacity = 0
        }
    }
    
    
    private func changeTutorialCover(toType newTutorialCover: TutorialCoverType) {
        resetAllTutorialCovers()
        switch currentTutorialCover {
        case        .Normal: normalFadeOut.opacity = 1
        case .ConfirmButton: confirmButtonFadeOut.opacity = 1
        case   .DataButtons: dataButtonsFadeOut.opacity = 1
        case          .Grid: gridFadeOut.opacity = 1
        case   .MenuButtons: menuButtonsFadeOut.opacity = 1
        case  .RankedHeader: rankedHeaderFadeOut.opacity = 1
        case  .ScoreCounter: scoreCounterFadeOut.opacity = 1
        case  .TargetNumber: targetNumberFadeOut.opacity = 1
        case         .Timer: timerFadeOut.opacity = 1
        default: break;
        }
    }
}

enum TutorialCoverType {
    case None, Normal, ConfirmButton, DataButtons, Grid, MenuButtons, RankedHeader, ScoreCounter, TargetNumber, Timer
}