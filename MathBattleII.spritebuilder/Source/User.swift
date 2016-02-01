//
//  User.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class User {
    
    var provider: String
    var displayName: String
    
    var rating: Int
    var ratingFloor: Int
    
    var numberOfGamesPlayed: Int
    
    var numberOfWins: Int
    var numberOfLosses: Int
    
    var friends: [String] // [String] of UIDs

    
    init(provider: String, displayName: String, rating: Int, ratingFloor: Int, numberOfGamesPlayed: Int) {
        self.provider = provider
        self.displayName = displayName
        self.rating = rating
        self.ratingFloor = ratingFloor
        self.numberOfGamesPlayed = numberOfGamesPlayed
    }
}