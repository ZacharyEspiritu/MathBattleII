//
//  ELOManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ELOManager {
    
    func updateRatings(winner oldWinnerRating: Rating, loser oldLoserRating: Rating) -> (Int, Int) {
        
        // Calculate winner rating
        var winnerKConstant = 10
        if oldWinnerRating.getNumberOfGamesPlayed() < 30 {
            winnerKConstant = 40
        }
        else {
            if oldWinnerRating.getRating() < 2100 {
                winnerKConstant = 32
            }
            else if oldWinnerRating.getRating() < 2400 {
                winnerKConstant = 24
            }
        }
        
        let expectedWinnerScore = (1 / (1 + pow(10, ((Double(oldLoserRating.getRating()) - Double(oldWinnerRating.getRating())) / 400))))
        var newWinnerRating = Int(Double(oldWinnerRating.getRating()) + Double(winnerKConstant) * (1 - expectedWinnerScore))
        if newWinnerRating < 700 {
            newWinnerRating = 700
        }
        
        // Calculate loser rating
        var loserKConstant = 10
        if oldLoserRating.getNumberOfGamesPlayed() < 30 {
            
        }
        else {
            if oldLoserRating.getRating() < 2100 {
                loserKConstant = 32
            }
            else if oldLoserRating.getRating() < 2400 {
                loserKConstant = 24
            }
        }
        
        let expectedLoserScore = (1 / (1 + pow(10, ((Double(oldWinnerRating.getRating()) - Double(oldLoserRating.getRating())) / 400))))
        var newLoserRating = Int(Double(oldLoserRating.getRating()) + Double(loserKConstant) * (0 - expectedLoserScore))
        if newLoserRating < 700 {
            newLoserRating = 700
        }
        
        print("Winner K: \(winnerKConstant)")
        print("Expected Winner: \(expectedWinnerScore)")
        print("New Winner Rating: \(newWinnerRating)")
        print("Loser K: \(loserKConstant)")
        print("Expected Loser: \(expectedLoserScore)")
        print("New Loser Rating: \(newLoserRating)")
        
        return (newWinnerRating, newLoserRating)
    }
    
    func calculateRatingDifference(rating1 rating1: Int, rating2: Int) -> Int {
        return rating1 - rating2
    }
}