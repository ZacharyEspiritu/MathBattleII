//
//  Matchmaker.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 2/22/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Matchmaker {
    
    static let sharedInstance = Matchmaker()
    private init() {}
    
    var currentMatchData: MatchData?
    
    
    func createNewCustomMatch(withCustomName customName: String!, customPassword: String!) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/\(customName)")
        let hostData: NSDictionary = [
            "uid": UserManager.sharedInstance.getCurrentUser()!.getUID(),
            "displayName": UserManager.sharedInstance.getCurrentUser()!.getDisplayName(),
            "isConnected": true,
            "currentTiles": [0, 0, 0, 0, 0, 0, 0, 0, 0],
            "targetNumber": 0,
            "needsToLaunch": false,
            "score": 0
        ]
        let matchData: NSDictionary = [
            "password": customPassword,
            "shouldStart": false,
            "hostPlayer": hostData,
            "opposingPlayer": NSNull()
        ]
        ref.setValue(matchData)
    }
    
    func attemptToJoinCustomMatch(matchName matchName: String, password possiblePassword: String) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/" + matchName)
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) { // Check if match exists
                if snapshot.value.objectForKey("opposingPlayer") is NSNull { // Check if match is full
                    if possiblePassword == snapshot.value.objectForKey("password") as! String { // Check if password is correct
                        let userData: NSDictionary = [
                            "uid": UserManager.sharedInstance.getCurrentUser()!.getUID(),
                            "displayName": UserManager.sharedInstance.getCurrentUser()!.getDisplayName(),
                            "isConnected": true,
                            "currentTiles": [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            "targetNumber": 0,
                            "needsToLaunch": false,
                            "score": 0
                        ]
                        ref.childByAppendingPath("opposingPlayer").setValue(userData as [NSObject : AnyObject])
                        
                        let hostPlayerData = PlayerData(data: snapshot.value.objectForKey("hostPlayer") as! NSDictionary)
                        let opposingPlayerData = PlayerData(data: userData)
                        self.currentMatchData = MatchData(hostPlayer: hostPlayerData, opposingPlayer: opposingPlayerData)
                        
                        self.attachToMatchData(atRef: ref)
                        ref.childByAppendingPath("shouldStart").setValue(true)
                    }
                    else {
                        print("Incorrect password.")
                    }
                }
                else {
                    print("Match is full.")
                }
            }
            else {
                print("Match not found with name \(matchName).")
            }
        })
    }
    
    func attachToMatchData(atRef ref: Firebase) {
        ref.observeEventType(.Value,
            withBlock: { snapshot in
                if let matchData = self.currentMatchData {
                    print("updating data")
                    matchData.updateData(data: snapshot.value as! NSDictionary)
                    
                    if !matchData.hasMatchStarted() {
                        if snapshot.value.objectForKey("shouldStart") as! Bool {
                            matchData.setMatchStarted()
                            self.startCurrentMatch()
                        }
                    }
                }
            }, withCancelBlock: { error in
                print("An error occured when attaching to match data: \(error.description)")
        })
    }
}

class MatchCreate: CCNode {
    
    weak var matchName: CCTextField!
    weak var password: CCTextField!
    
    func create() {
        Matchmaker.sharedInstance.createNewCustomMatch(withCustomName: matchName.string, customPassword: password.string)
    }
    
    func join() {
        Matchmaker.sharedInstance.attemptToJoinCustomMatch(matchName: matchName.string, password: password.string)
    }
}

enum MatchmakerError: ErrorType {
    case CustomMatchRoomDoesNotExist
    case CustomMatchIncorrectPassword
}