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
    private var provider: String
    private var email: String
    
    private var displayName:      String { didSet { delegate?.localUserDataDidUpdate(self) }}
    
    private var numberOfGamesPlayed: Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    private var numberOfWins:        Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    private var numberOfLosses:      Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    
    private var numberOfSolves:      Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    
    private var rating:              Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    private var ratingFloor:         Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    
    private var experienceLevel:     Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    private var coins:               Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    
    private var practiceHighScore:   Int { didSet { delegate?.localUserDataDidUpdate(self) }}
    
    private var items:             [Int] { didSet { delegate?.localUserDataDidUpdate(self) }}
    
    private var friends:        [String] { didSet { delegate?.localUserDataDidUpdate(self) }}
        // [friends] should always be kept sorted alphabetically whenever possible
    
    var delegate: UserDelegate?

    
    // MARK: Utility Functions
    
    init(uid: String, displayName: String, email: String, provider: String, numberOfGamesPlayed: Int, numberOfWins: Int, numberOfLosses: Int, numberOfSolves: Int, rating: Int, ratingFloor: Int, experienceLevel: Int, coins: Int, practiceHighScore: Int, items: [Int], friends: [String]) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.provider = provider
        self.numberOfGamesPlayed = numberOfGamesPlayed
        self.numberOfWins = numberOfWins
        self.numberOfLosses = numberOfLosses
        self.numberOfSolves = numberOfSolves
        self.rating = rating
        self.ratingFloor = ratingFloor
        self.experienceLevel = experienceLevel
        self.coins = coins
        self.practiceHighScore = practiceHighScore
        self.items = items
        self.friends = friends
    }
    
    static func generateDefaultUserDictionary(withUsername username: String, email: String) -> [String : AnyObject] {
        return [
            "displayName": username,
            "email": email,
            "numberOfGamesPlayed": 0,
            "numberOfWins": 0,
            "numberOfLosses": 0,
            "numberOfSolves": 0,
            "provider": "password",
            "rating": 1000,
            "ratingFloor": 700,
            "experienceLevel": 0,
            "coins": 0,
            "practiceHighScore": 0,
            "items": [],
            "friends": []
        ]
    }
    
    func convertToDictionaryFormat() -> [String : AnyObject] {
        return [
            "displayName": displayName,
            "email": email,
            "numberOfGamesPlayed": numberOfGamesPlayed,
            "numberOfWins": numberOfWins,
            "numberOfLosses": numberOfLosses,
            "numberOfSolves": numberOfSolves,
            "provider": provider,
            "rating": rating,
            "ratingFloor": ratingFloor,
            "experienceLevel": experienceLevel,
            "coins": coins,
            "practiceHighScore": practiceHighScore,
            "items": items,
            "friends": friends
        ]
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
    
    func getNumberOfSolves() -> Int {
        return numberOfSolves
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
    
    func getExperienceLevel() -> Int {
        return experienceLevel
    }
    
    func getCalculatedPlayerLevel() -> Int {
        var playerExperienceLevel = experienceLevel
        var levelCount = 0
        var levelExperienceCap = 10
        while playerExperienceLevel > 0 {
            levelCount += 1
            playerExperienceLevel -= 10
            levelExperienceCap = 10
            if levelCount >= 2 {
                playerExperienceLevel -= 25 * (levelCount - 1)
                levelExperienceCap = 25 * (levelCount - 1)
                if levelCount >= 4 {
                    playerExperienceLevel -= 25 * (levelCount - 3)
                    levelExperienceCap += 25 * (levelCount - 3)
                    if levelCount >= 13 {
                        playerExperienceLevel -= 50 * (levelCount - 12)
                        levelExperienceCap += 50 * (levelCount - 12)
                        if levelCount >= 33 {
                            playerExperienceLevel -= 100 * (levelCount - 32)
                            levelExperienceCap += 50 * (levelCount - 32)
                        }
                    }
                }
            }
        }
        return levelCount
    }
    
    func getCoins() -> Int {
        return coins
    }
    
    func getPracticeHighScore() -> Int {
        return practiceHighScore
    }
    
    func getItems() -> [Int]? {
        return items
    }
    
    func getFriends() -> [String]? {
        return friends
    }
    
    // MARK: Setter Functions
    
    func setDisplayName(newDisplayName newDisplayName: String) -> String {
        displayName = newDisplayName
        return displayName
    }
    
    func incrementNumberOfGamesPlayed() -> Int {
        numberOfGamesPlayed += 1
        return numberOfGamesPlayed
    }
    
    func incrementNumberOfWins() -> Int {
        numberOfWins += 1
        return numberOfWins
    }
    
    func incrementNumberOfLosses() -> Int {
        numberOfLosses += 1
        return numberOfLosses
    }
    
    func setRating(newRating newRating: Int) -> Int {
        rating = newRating
        return rating
    }
    
    func setRatingFloor(newRatingFloor newRatingFloor: Int) -> Int {
        ratingFloor = newRatingFloor
        return ratingFloor
    }
    
    func calculateNewExperienceLevel(withScore score: Int, didWin: Bool) -> Int {
        var newExperience = 2 + score // 2 EXP for each game, plus 1 EXP per completed puzzle
        if score == 5 {
            newExperience += 1 // 1 EXP for completing all five puzzles
        }
        if didWin {
            newExperience += 2 // 2 EXP for winning the match
        }
        experienceLevel += newExperience
        MenuDisplayManager.sharedInstance.updateLevelDisplays(experienceLevel: experienceLevel)
        return experienceLevel
    }
    
    func setCoins(newCoins newCoins: Int) -> Int {
        coins = newCoins
        MenuDisplayManager.sharedInstance.updateCoinDisplays(coins: coins)
        return coins
    }
    
    func setPracticeHighScore(newHighScore score: Int) -> Int {
        if score > practiceHighScore {
            practiceHighScore = score
        }
        return score
    }
    
    func addToNumberOfSolves(newSolves newSolves: Int) -> Int {
        numberOfSolves += newSolves
        return numberOfSolves
    }
    
    func addItem(itemID id: Int) -> [Int] {
        if !items.contains(id) {
            items.append(id)
            items.sortInPlace()
        }
        return items
    }
    
    func addFriend(displayName displayName: String) -> [String] {
        if !friends.contains(displayName) {
            friends.append(displayName)
            friends.sortInPlace()
        }
        return friends
    }
    
    func removeFriend(displayName displayName: String) -> Bool {
        if let index = friends.indexOf(displayName) {
            friends.removeAtIndex(index)
            return true
        }
        else {
            return false
        }
    }
}

extension User: CustomStringConvertible {
    // MARK: Custom String Printable Format
    var description: String {
        // Swift doesn't support string literals broken up into different lines; sorry about this mess:
        return "UID: \(uid) {\n    displayName: \(displayName)\n    email: \(email)\n    numberOfGamesPlayed: \(numberOfGamesPlayed)\n    numberOfWins: \(numberOfWins)\n    numberOfLosses: \(numberOfLosses)\n    rating: \(rating)\n    ratingFloor: \(ratingFloor)\n    friends: \(friends)\n}"
    }
}

protocol UserDelegate {
    func localUserDataDidUpdate(user: User)
}