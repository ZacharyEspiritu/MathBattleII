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
    private var rating: Rating
    private var numberOfGamesPlayed: Int
    
    init() {
        username = ""
        rating = Rating()
        numberOfGamesPlayed = 0
    }
    
}