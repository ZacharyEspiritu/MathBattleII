//
//  LocalMatchMenu.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/20/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LocalMatchMenu: CCNode {
    
    weak var topMenuButton, bottomMenuButton: CCButton!
    weak var scoreOptionButton, timeOptionButton: CCButton!
    
    var currentTimeOption: TimeOption = .Ninety {
        didSet {
            timeOptionButton.label.string = "Time: \(currentTimeOption.rawValue)"
        }
    }
    
    var currentScoreOption: ScoreOption = .Normal {
        didSet {
            scoreOptionButton.label.string = "Score: \(currentScoreOption.rawValue)"
        }
    }
    
    func readyButtonPressed() {
        OALSimpleAudio.sharedInstance().playEffect("pop.wav")
        if topMenuButton.selected && bottomMenuButton.selected {
            saveOptionsToUserDefaults()
            MatchStartingPopupHandler.sharedInstance.displayPopup(withHeader: "Local Match Is Starting...", info: "Guest vs Guest")
            self.userInteractionEnabled = false
        }
    }
    
    func timeOptionButtonPressed() {
        switch currentTimeOption {
        case .Thirty:
            currentTimeOption = .Sixty
        case .Sixty:
            currentTimeOption = .Ninety
        case .Ninety:
            currentTimeOption = .OneTwenty
        case .OneTwenty:
            currentTimeOption = .Thirty
        }
    }
    
    func scoreOptionButtonPressed() {
        switch currentScoreOption {
        case .Lowest:
            currentScoreOption = .Low
        case .Low:
            currentScoreOption = .Normal
        case .Normal:
            currentScoreOption = .Lowest
        }
    }
    
    private func saveOptionsToUserDefaults() {
        let timeInteger: Int!
        switch currentTimeOption {
        case .Thirty:
            timeInteger = 30
        case .Sixty:
            timeInteger = 60
        case .Ninety:
            timeInteger = 90
        case .OneTwenty:
            timeInteger = 120
        }
        NSUserDefaults.standardUserDefaults().setInteger(timeInteger, forKey: "gameLengthOption")
        NSUserDefaults.standardUserDefaults().setInteger(currentScoreOption.rawValue, forKey: "scoreLimitOption")
    }
}

enum TimeOption: String {
    case Thirty = "0:30"
    case Sixty = "1:00"
    case Ninety = "1:30"
    case OneTwenty = "2:00"
}

enum ScoreOption: Int {
    case Lowest = 3
    case Low = 4
    case Normal = 5
}