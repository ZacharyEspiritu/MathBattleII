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
    
    private var friends:        [String] { didSet { delegate?.localUserDataDidUpdate(self) }}
        // [friends] should always be kept sorted alphabetically whenever possible
    
    var delegate: UserDelegate?

    
    // MARK: Utility Functions
    
    init(uid: String, displayName: String, email: String, provider: String, numberOfGamesPlayed: Int, numberOfWins: Int, numberOfLosses: Int, numberOfSolves: Int, rating: Int, ratingFloor: Int, friends: [String]) {
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
        self.friends = friends
    }
    
    func convertToDictionaryFormat() -> [String : AnyObject] {
        return [
            "displayName": displayName,
            "email": email,
            "numberOfGamesPlayed": numberOfGamesPlayed,
            "numberOfWins": numberOfWins,
            "numberOfLosses": numberOfLosses,
            "provider": provider,
            "rating": rating,
            "ratingFloor": ratingFloor,
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
    
    func retrieveFriendInformationFromFirebase(displayNames displayNames: [String], completion: ([String : FDataSnapshot] -> Void)) {
        let dispatchGroup = dispatch_group_create()
        let friendRef = Firebase(url: Config.firebaseURL + "/displayNames/")
        var friendData = [String : FDataSnapshot]()
        for friend in friends {
            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                friendRef.childByAppendingPath(friend).observeSingleEventOfType(.Value, withBlock: { snapshot in
                    let friendUID = snapshot.value.uid
                    let friendDataRef = Firebase(url: Config.firebaseURL + "/users/\(friendUID)")
                    friendDataRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        friendData[friendUID] = snapshot
                    })
                })
            })
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            completion(friendData)
        }
    }
    
    func saveFriendInformationToFirebase() {
        let userFriendsRef = Firebase(url: Config.firebaseURL + "/users/\(uid)/friends")
        userFriendsRef.removeValue()
        for friend in friends {
            userFriendsRef.childByAutoId().setValue(friend)
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