//
//  Rating.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

func == (lhs: Rating, rhs: Rating) -> Bool {
    if lhs.getRating() == rhs.getRating() {
        if lhs.getNumberOfGamesPlayed() == rhs.getNumberOfGamesPlayed() {
            if lhs.getMinimumFloor() == rhs.getMinimumFloor() {
                return true
            }
        }
    }
    return false
}

class Rating: CustomStringConvertible, Equatable {
    
    private var rating: Int
    private var numberOfGames: Int
    private var minimumFloor: Int
    var description: String {
        return "Rating: \(rating)\nNumber of Games Played: \(numberOfGames)\nMinimum Rating Floor: \(minimumFloor)"
    }
    
    init() {
        rating = 1000
        numberOfGames = 0
        minimumFloor = 700
    }
    init(rating: Int, numberOfGames: Int, minimumFloor: Int) {
        self.rating = rating
        self.numberOfGames = numberOfGames
        self.minimumFloor = minimumFloor
    }
    
    static func compareRatings(rating1 rating1: Rating, rating2: Rating) {
        
    }
    
    func getRating() -> Int {
        return rating
    }
    
    func setRating(newRating: Int) {
        rating = newRating
    }
    
    func addGamePlayed() -> Int {
        numberOfGames += 1
        return numberOfGames
    }
    
    func getNumberOfGamesPlayed() -> Int {
        return numberOfGames
    }
    
    func getMinimumFloor() -> Int {
        return minimumFloor
    }
}