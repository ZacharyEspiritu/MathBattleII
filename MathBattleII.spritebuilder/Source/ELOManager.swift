//
//  ELOManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ELOManager {
    
    func updateRatings(winner oldWinnerRating: Int, loser oldLoserRating: Int) -> (Int, Int) {
        
        // Calculate winner rating
        var winnerKConstant = 10
        if oldWinnerRating < 30 {
            winnerKConstant = 40
        }
        else {
            if oldWinnerRating < 2100 {
                winnerKConstant = 32
            }
            else if oldWinnerRating < 2400 {
                winnerKConstant = 24
            }
        }
        
        let expectedWinnerScore = (1 / (1 + pow(10, ((Double(oldLoserRating) - Double(oldWinnerRating)) / 400))))
        var newWinnerRating = Int(Double(oldWinnerRating) + Double(winnerKConstant) * (1 - expectedWinnerScore))
        if newWinnerRating < 700 {
            newWinnerRating = 700
        }
        
        // Calculate loser rating
        var loserKConstant = 10
        if oldLoserRating < 2100 {
            loserKConstant = 32
        }
        else if oldLoserRating < 2400 {
            loserKConstant = 24
        }
        
        let expectedLoserScore = (1 / (1 + pow(10, ((Double(oldWinnerRating) - Double(oldLoserRating)) / 400))))
        var newLoserRating = Int(Double(oldLoserRating) + Double(loserKConstant) * (0 - expectedLoserScore))
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