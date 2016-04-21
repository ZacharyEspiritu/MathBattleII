//
//  ELOManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class ELOManager {
    
    static func updateRatings(winner oldWinnerRating: Int, loser oldLoserRating: Int) -> (Int, Int) {
        
        // Calculate winner rating
        let winnerKConstant = determineKConstant(rating: oldWinnerRating)
        
        let expectedWinnerScore = (1 / (1 + pow(10, ((Double(oldLoserRating) - Double(oldWinnerRating)) / 400))))
        var newWinnerRating = Int(Double(oldWinnerRating) + Double(winnerKConstant) * (1 - expectedWinnerScore))
        if newWinnerRating < 700 {
            newWinnerRating = 700
        }
        
        // Calculate loser rating
        let loserKConstant = determineKConstant(rating: oldLoserRating)
        
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
    
    static func calculateRatingDifference(rating1 rating1: Int, rating2: Int) -> Int {
        return abs(rating1 - rating2)
    }
    
    private static func determineKConstant(rating rating: Int) -> Int {
        if rating > 2400 {
            return 10
        }
        else if rating > 2100 {
            return 24
        }
        else {
            return 32
        }
    }
    
    private static func calculateNewRating(winnerRating oldWinnerRating: Int, loserRating oldLoserRating: Int, kConstant: Int) {
        let expectedWinnerScore = (1 / (1 + pow(10, ((Double(oldLoserRating) - Double(oldWinnerRating)) / 400))))
        var newWinnerRating = Int(Double(oldWinnerRating) + Double(kConstant) * (1 - expectedWinnerScore))
        if newWinnerRating < 700 {
            newWinnerRating = 700
        }
    }
}