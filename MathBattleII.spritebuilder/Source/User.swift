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
    
    private var friends:        [String] { didSet { delegate?.localUserDataDidUpdate(self) }}
        // [friends] should always be kept sorted alphabetically whenever possible
    
    var delegate: UserDelegate?

    
    // MARK: Utility Functions
    
    init(uid: String, displayName: String, email: String, provider: String, numberOfGamesPlayed: Int, numberOfWins: Int, numberOfLosses: Int, numberOfSolves: Int, rating: Int, ratingFloor: Int, experienceLevel: Int, coins: Int, friends: [String]) {
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
        self.friends = friends
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
    
    func getCoins() -> Int {
        return coins
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
        return experienceLevel
    }
    
    func setCoins(newCoins newCoins: Int) -> Int {
        coins = newCoins
        return coins
    }
    
    func addToNumberOfSolves(newSolves newSolves: Int) -> Int {
        numberOfSolves += newSolves
        return numberOfSolves
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
    
//    func retrieveFriendInformationFromFirebase(displayNames displayNames: [String], completion: ([String : FIRDataSnapshot] -> Void)) {
//        let dispatchGroup = dispatch_group_create()
//        let friendRef = FIRDatabase.database().reference().child("displayNames")
//        var friendData = [String : FIRDataSnapshot]()
//        for friend in friends {
//            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
//                friendRef.child(friend).observeSingleEventOfType(.Value, withBlock: { snapshot in
//                    let friendUID = snapshot.value.uid
//                    let friendDataRef = FIRDatabase.database().reference().child("/users/\(friendUID)")
//                    friendDataRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//                        friendData[friendUID] = snapshot
//                    })
//                })
//            })
//        }
//        dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
//            completion(friendData)
//        }
//    }
//    
//    func saveFriendInformationToFirebase() {
//        let userFriendsRef = FIRDatabase.database().reference().child("users/\(uid)/friends")
//        userFriendsRef.removeValue()
//        for friend in friends {
//            userFriendsRef.childByAutoId().setValue(friend)
//        }
//    }
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