//
//  Player.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Player {
    
    private var username: String
    private var rating: Int
    
    private var numberOfGamesPlayed: Int
    private var ratingFloor: Int
    
    init(name: String) {
        username = name
        rating = 1000
        numberOfGamesPlayed = 0
        ratingFloor = 700
    }
    
}