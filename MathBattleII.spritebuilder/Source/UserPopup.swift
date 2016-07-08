//
//  UserPopup.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 7/7/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class UserPopup: CCNode {
    
    weak var playerNameLabel, ratingLabel, practiceHighScoreLabel, experienceLevelLabel: CCLabelTTF!
    weak var totalExperienceLabel, coinsLabel, numberOfGamesPlayedLabel, totalPuzzleSolvesLabel, onlineMatchWinsLabel, onlineMatchLossesLabel, itemsBoughtLabel: CCLabelTTF!
    weak var focusOutButton: CCButton!
    
    
    func didLoadFromCCB() {
        focusOutButton.enabled = false
    }
        
    func closeButtonPressed() {
        UserPopupHandler.hideUserPopup()
    }
    
    func displayUserData(forUser user: User) {
        playerNameLabel.string = user.getDisplayName()
        ratingLabel.string = "Rating: \(user.getRating())"
        practiceHighScoreLabel.string = "Practice: \(user.getPracticeHighScore())"
        experienceLevelLabel.string = "\(user.getCalculatedPlayerLevel())"
        totalExperienceLabel.string = "\(user.getExperienceLevel())"
        coinsLabel.string = "\(user.getCoins())"
        numberOfGamesPlayedLabel.string = "\(user.getNumberOfGamesPlayed())"
        totalPuzzleSolvesLabel.string = "\(user.getNumberOfSolves())"
        onlineMatchWinsLabel.string = "\(user.getNumberOfWins())"
        onlineMatchLossesLabel.string = "\(user.getNumberOfLosses())"
        itemsBoughtLabel.string = user.getItems() != nil ? "\(user.getItems()!.count)" : "0"
    }
}