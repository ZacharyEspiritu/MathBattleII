//
//  User.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 1/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class User {
    
    // MARK: User Data
    
    private var uid: String
    
    private var displayName: String
    private var email: String
    private var provider: String
    
    private var numberOfGamesPlayed: Int
    private var numberOfWins: Int
    private var numberOfLosses: Int
    
    private var rating: Int
    private var ratingFloor: Int
    
    private var friends: [String]?

    
    // MARK: Utility Functions
    
    init(uid: String, displayName: String, email: String, provider: String, numberOfGamesPlayed: Int, numberOfWins: Int, numberOfLosses: Int, rating: Int, ratingFloor: Int, friends: [String]?) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.provider = provider
        self.numberOfGamesPlayed = numberOfGamesPlayed
        self.numberOfWins = numberOfWins
        self.numberOfLosses = numberOfLosses
        self.rating = rating
        self.ratingFloor = ratingFloor
        self.friends = friends
    }
    
    
    // MARK: Getter Functions
    
    func getUID() -> String {
        return uid
    }
    
    func getDisplayName() -> String {
        return displayName
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getNumberOfGamesPlayed() -> Int {
        return numberOfGamesPlayed
    }
    
    func getNumberOfWins() -> Int {
        return numberOfWins
    }
    
    func getNumberOfLosses() -> Int {
        return numberOfLosses
    }
    
    func getRating() -> Int {
        return rating
    }
    
    func getRatingFloor() -> Int {
        return ratingFloor
    }
    
    func getFriends() -> [String]? {
        return friends
    }
}

extension User: CustomStringConvertible {
    // MARK: Custom String Printable Format
    var description: String {
        return "UID: \(uid) {\n    displayName: \(displayName)\n    email: \(email)\n    numberOfGamesPlayed: \(numberOfGamesPlayed)\n    numberOfWins: \(numberOfWins)\n    numberOfLosses: \(numberOfLosses)\n    rating: \(rating)\n    ratingFloor: \(ratingFloor)\n    friends: \(friends)\n}"
    }
}