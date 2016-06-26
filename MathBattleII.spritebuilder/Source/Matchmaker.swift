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
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(customName)")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let _ = snapshot.value { // Check if match doesn't already exist with given name
                let matchData: NSDictionary = [
                    "password": customPassword,
                    "shouldStart": false,
                    "hostPlayer": NSNull(),
                    "opposingPlayer": NSNull()
                ]
                ref.setValue(matchData)
                self.attemptToJoinCustomMatch(matchName: customName, password: customPassword)
                print("Match created with name \(customName)")
            }
            else {
                print("match already exists with given name")
            }
        })
    }
    
    func attemptToJoinCustomMatch(matchName matchName: String, password possiblePassword: String) {
        let ref = FIRDatabase.database().reference().child("/matches/custom/\(matchName)")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
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
                        self.listenForMatchStart(atRef: ref)
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
                        self.listenForMatchStart(atRef: ref)
                        ref.child("shouldStart").setValue(true)
                    }
                    else {
                        print("Match is full.")
                    }
                }
                else {
                    print("Incorrect password.")
                }
            }
            else {
                print("Match not found with name \(matchName).")
            }
        })
    }
    
    private func listenForMatchStart(atRef ref: FIRDatabaseReference) {
        ref.child("shouldStart").observeEventType(.Value,
            withBlock: { snapshot in
                if let localMatchData = self.currentMatchData {
                    if !localMatchData.hasMatchStarted() {
                        if snapshot.value as! Bool {
                            print("match should start")
                            localMatchData.setMatchStarted()
                            self.startCurrentMatch(atRef: ref)
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
    
    private func startCurrentMatch(atRef ref: FIRDatabaseReference) {
        print("match starting")
        
        // Begin 15 second countdown before match starts
        var countdown: Int = 15
        NSTimer.schedule(repeatInterval: 1) { timer in
            countdown -= 1
            OALSimpleAudio.sharedInstance().playEffect("ding.wav")
            print(countdown)
            
            if countdown <= 0 {
                self.scheduleAutomaticDataCheck(atRef: ref)
                
                // Load scene
                let gameplayScene = CCBReader.load("GameplayScene") as! GameplayScene
                
                let scene = CCScene()
                scene.addChild(gameplayScene)
                
                let transition = CCTransition(fadeWithDuration: 0.5)
                CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
                
                timer.invalidate()
            }
        }
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
        return [
            "uid": UserManager.sharedInstance.getCurrentUser()!.getUID(),
            "displayName": UserManager.sharedInstance.getCurrentUser()!.getDisplayName(),
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