//
//  Rating.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Rating {
    
    private var rating: Int
    private var numberOfGames: Int
    private var minimumFloor: Int
    
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
    
    func getRating() -> Int {
        return rating
    }
    
    func setRating(newRating: Int) {
        rating = newRating
    }
    
    func addGamePlayed() -> Int {
        numberOfGames++
        return numberOfGames
    }
    
    func getNumberOfGamesPlayed() -> Int {
        return numberOfGames
    }
}