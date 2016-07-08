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
    
    
    func createNewCustomMatch(withCustomName customName: String!, customPassword: String!, completionHandler: (Void -> Void), errorHandler: (String -> Void), startHandler: (String, String) -> (Void)) {
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(customName)")
        ref.observeSingleEventOfType(.Value,
            withBlock: { snapshot in
                if let _ = snapshot.value { // Check if match doesn't already exist with given name
                    let matchData: NSDictionary = [
                        "password": customPassword,
                        "shouldStart": false,
                        "hostPlayer": NSNull(),
                        "opposingPlayer": NSNull()
                    ]
                    ref.setValue(matchData)
                    self.attemptToJoinCustomMatch(matchName: customName, password: customPassword, completionHandler: completionHandler, errorHandler: errorHandler, startHandler: startHandler)
                    print("Match created with name \(customName)")
                }
                else {
                    errorHandler("Match already exists with given name.")
                }
            }, withCancelBlock: { error in
                if let errorCode = FIRAuthErrorCode(rawValue: error.code) { // TODO: Handle all ErrorCode cases
                    let errorDescription = FirebaseErrorReader.convertToHumanReadableAlertDescription(errorCode)
                    errorHandler(errorDescription)
                }
        })
    }
    
    func attemptToJoinCustomMatch(matchName matchName: String, password possiblePassword: String, completionHandler: (Void -> Void), errorHandler: (String -> Void), startHandler: (String, String) -> (Void)) {
        guard let _ = UserManager.sharedInstance.getCurrentUser() else {
            errorHandler("User will not logged in!")
            return
        }
        
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(matchName)")
        ref.observeSingleEventOfType(.Value,
            withBlock: { snapshot in
                if let matchInformation = snapshot.value as? NSDictionary { // Check if match exists
                    if possiblePassword == matchInformation.objectForKey("password") as! String {
                        if matchInformation.objectForKey("hostPlayer") == nil { // Check if match has hostPlayer
                            let userData: NSDictionary = self.generateStandardUserData()
                            ref.child("hostPlayer").setValue(userData as [NSObject : AnyObject])
                            
                            // "hostPlayer" refers to the Player on the current device.
                            // "opposingPlayer" refers to the player that isn't on the current device.
                            let hostPlayerData = PlayerData(data: userData, isHost: true)
                            
                            self.currentMatchData = MatchData(matchID: matchName, hostPlayer: hostPlayerData, opposingPlayer: nil, matchType: .Custom)
                            self.currentMatchData?.hostPlayer.delegate = self
                            
                            self.attachToPlayerData(atRef: ref.child("opposingPlayer"))
                            self.listenForMatchStart(atRef: ref, startHandler: startHandler)
                            
                            completionHandler()
                        }
                        else if matchInformation.objectForKey("opposingPlayer") == nil { // Check if match is full
                            let userData: NSDictionary = self.generateStandardUserData()
                            ref.child("opposingPlayer").setValue(userData as [NSObject : AnyObject])
                            
                            // "hostPlayer" refers to the Player on the current device. 
                            // "opposingPlayer" refers to the player that isn't on the current device.
                            let hostPlayerData = PlayerData(data: userData, isHost: false)
                            let opposingPlayerData = PlayerData(data: matchInformation.objectForKey("hostPlayer") as! NSDictionary, isHost: true)
                            
                            self.currentMatchData = MatchData(matchID: matchName, hostPlayer: hostPlayerData, opposingPlayer: opposingPlayerData, matchType: .Custom)
                            self.currentMatchData?.hostPlayer.delegate = self
                            
                            self.attachToPlayerData(atRef: ref.child("hostPlayer"))
                            self.listenForMatchStart(atRef: ref, startHandler: startHandler)
                            ref.child("shouldStart").setValue(true)
                            
                            completionHandler()
                        }
                        else {
                            errorHandler("This match is already full.")
                        }
                    }
                    else {
                        errorHandler("Match password incorrect.")
                    }
                }
                else {
                    errorHandler("Match with given name not found.")
                }
            }, withCancelBlock: { error in
                if let errorCode = FIRAuthErrorCode(rawValue: error.code) { // TODO: Handle all ErrorCode cases
                    let errorDescription = FirebaseErrorReader.convertToHumanReadableAlertDescription(errorCode)
                    errorHandler(errorDescription)
                }
        })
    }
    
    private func listenForMatchStart(atRef ref: FIRDatabaseReference, startHandler: (String, String) -> (Void)) {
        ref.child("shouldStart").observeEventType(.Value,
            withBlock: { snapshot in
                if let localMatchData = self.currentMatchData {
                    if !localMatchData.hasMatchStarted() {
                        if snapshot.value as! Bool {
                            print("match should start")
                            let hostPlayerName = localMatchData.hostPlayer.displayName
                            let opposingPlayerName = localMatchData.opposingPlayer.displayName
                            startHandler(hostPlayerName, opposingPlayerName)
                            self.scheduleAutomaticDataCheck(atRef: ref)
                            localMatchData.setMatchStarted()
                        }
                    }
                }
            }, withCancelBlock: { error in
                print("An error occured when attaching to match data: \(error.description)")
        })
    }
    
    private func attachToPlayerData(atRef ref: FIRDatabaseReference) {
        ref.observeEventType(.Value,
            withBlock: { snapshot in
                if let localMatchData = self.currentMatchData {
                    if let updatedMatchData = snapshot.value as? NSDictionary {
                        if localMatchData.opposingPlayer == nil { // Only run once if the player on the device was the one to create the match
                            localMatchData.opposingPlayer = PlayerData(data: updatedMatchData, isHost: false)
                        }
                        localMatchData.opposingPlayer.updateData(newData: updatedMatchData)
                    }
                }
            }, withCancelBlock: { error in
                print("An error occured when attaching to match data: \(error.description)")
        })
    }
    
    private func scheduleAutomaticDataCheck(atRef ref: FIRDatabaseReference) {
        NSTimer.schedule(repeatInterval: 5, handler: { timer in
            ref.observeSingleEventOfType(.Value,
                withBlock: { snapshot in
                    if let localMatchData = self.currentMatchData {
                        if let updatedMatchData = snapshot.value as? NSDictionary {
                            if localMatchData.opposingPlayer == nil { // Only run once if the player on the device was the one to create the match
                                localMatchData.opposingPlayer = PlayerData(data: updatedMatchData, isHost: false)
                            }
                            if updatedMatchData.objectForKey("isConnected") is Bool {
                                localMatchData.opposingPlayer.updateData(newData: updatedMatchData)
                            }
                        }
                    }
                }, withCancelBlock: { error in
                    print("An error occured when attaching to match data: \(error.description)")
            })
        })
    }
    
    private func generateStandardUserData() -> NSDictionary {
        guard let user = UserManager.sharedInstance.getCurrentUser() else {
            print("generateStandardUserData was called but no user exists!")
            return [:]
        }
        return [
            "uid": user.getUID(),
            "displayName": user.getDisplayName(),
            "isConnected": true,
            "currentTiles": [0, 0, 0, 0, 0, 0, 0, 0, 0],
            "currentlySelectedTiles": [],
            "targetNumber": 0,
            "score": 0
        ]
    }
}

extension Matchmaker: PlayerDataDelegate {
    func connectionStatusHasUpdated(playerData: PlayerData) {
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(currentMatchData!.matchID)")
        ref.child(playerData.isHost ? "hostPlayer" : "opposingPlayer").child("isConnected").setValue(playerData.isConnected)
    }
    
    func scoreHasUpdated(playerData: PlayerData) {
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(currentMatchData!.matchID)")
        ref.child(playerData.isHost ? "hostPlayer" : "opposingPlayer").child("score").setValue(playerData.score)
    }
    
    func currentTilesHaveUpdated(playerData: PlayerData) {
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(currentMatchData!.matchID)")
        var rawValues: [Int] = []
        for tile in playerData.currentTiles {
            rawValues.append(tile.rawValue)
        }
        ref.child(playerData.isHost ? "hostPlayer" : "opposingPlayer").child("currentTiles").setValue(rawValues)
    }
    
    func targetNumberHasUpdated(playerData: PlayerData) {
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(currentMatchData!.matchID)")
        ref.child(playerData.isHost ? "hostPlayer" : "opposingPlayer").child("targetNumber").setValue(playerData.targetNumber)
    }
    
    func currentlySelectedTilesHaveUpdated(playerData: PlayerData) {
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(currentMatchData!.matchID)")
        ref.child(playerData.isHost ? "hostPlayer" : "opposingPlayer").child("currentlySelectedTiles").setValue(playerData.currentlySelectedTiles)
    }
}