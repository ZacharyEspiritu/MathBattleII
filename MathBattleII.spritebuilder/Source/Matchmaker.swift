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
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) { // Check if match doesn't already exist with given name
                let matchData: NSDictionary = [
                    "password": customPassword,
                    "shouldStart": false,
                    "hostPlayer": NSNull(),
                    "opposingPlayer": NSNull()
                ]
                ref.setValue(matchData)
                self.attemptToJoinCustomMatch(matchName: customName, password: customPassword)
            }
        })
    }
    
    func attemptToJoinCustomMatch(matchName matchName: String, password possiblePassword: String) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/" + matchName)
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) { // Check if match exists
                if possiblePassword == snapshot.value.objectForKey("password") as! String {
                    if snapshot.value.objectForKey("hostPlayer") == nil { // Check if match has hostPlayer
                        let userData: NSDictionary = [
                            "uid": UserManager.sharedInstance.getCurrentUser()!.getUID(),
                            "displayName": UserManager.sharedInstance.getCurrentUser()!.getDisplayName(),
                            "isConnected": true,
                            "currentTiles": [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            "currentlySelectedTiles": [],
                            "targetNumber": 0,
                            "score": 0
                        ]
                        ref.childByAppendingPath("hostPlayer").setValue(userData as [NSObject : AnyObject])
                        
                        // "hostPlayer" refers to the Player on the current device.
                        // "opposingPlayer" refers to the player that isn't on the current device.
                        let hostPlayerData = PlayerData(data: userData, isHost: true)
                        
                        self.currentMatchData = MatchData(matchID: matchName, hostPlayer: hostPlayerData, opposingPlayer: nil)
                        self.currentMatchData?.hostPlayer.delegate = self
                        
                        self.attachToPlayerData(atRef: ref.childByAppendingPath("opposingPlayer"))
                        self.listenForMatchStart(atRef: ref)
                    }
                    else if snapshot.value.objectForKey("opposingPlayer") == nil { // Check if match is full
                        let userData: NSDictionary = [
                            "uid": UserManager.sharedInstance.getCurrentUser()!.getUID(),
                            "displayName": UserManager.sharedInstance.getCurrentUser()!.getDisplayName(),
                            "isConnected": true,
                            "currentTiles": [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            "currentlySelectedTiles": [],
                            "targetNumber": 0,
                            "score": 0
                        ]
                        ref.childByAppendingPath("opposingPlayer").setValue(userData as [NSObject : AnyObject])
                        
                        // "hostPlayer" refers to the Player on the current device. 
                        // "opposingPlayer" refers to the player that isn't on the current device.
                        let hostPlayerData = PlayerData(data: userData, isHost: false)
                        let opposingPlayerData = PlayerData(data: snapshot.value.objectForKey("hostPlayer") as! NSDictionary, isHost: true)
                        
                        self.currentMatchData = MatchData(matchID: matchName, hostPlayer: hostPlayerData, opposingPlayer: opposingPlayerData)
                        self.currentMatchData?.hostPlayer.delegate = self
                        
                        self.attachToPlayerData(atRef: ref.childByAppendingPath("hostPlayer"))
                        self.listenForMatchStart(atRef: ref)
                        ref.childByAppendingPath("shouldStart").setValue(true)
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
    
    private func listenForMatchStart(atRef ref: Firebase) {
        ref.childByAppendingPath("shouldStart").observeEventType(.Value,
            withBlock: { snapshot in
                if let localMatchData = self.currentMatchData {
                    if !localMatchData.hasMatchStarted() {
                        if snapshot.value as! Bool {
                            print("match should start")
                            localMatchData.setMatchStarted()
                            self.startCurrentMatch()
                        }
                    }
                }
            }, withCancelBlock: { error in
                print("An error occured when attaching to match data: \(error.description)")
        })
    }
    
    private func attachToPlayerData(atRef ref: Firebase) {
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
    
    private func startCurrentMatch() {
        print("match starting")
        // Play some sort of signal sound that the match has been filled and is now starting
        // OALSimpleAudio.sharedInstance().playEffect("")
        
        // Begin 15 second countdown before match starts
        var countdown: Int = 15
        NSTimer.schedule(repeatInterval: 1) { timer in
            countdown -= 1
            OALSimpleAudio.sharedInstance().playEffect("ding.wav")
            print(countdown)
            
            if countdown <= 0 {
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
}

extension Matchmaker: PlayerDataDelegate {
    func connectionStatusHasUpdated(playerData: PlayerData) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/\(currentMatchData!.matchID)")
        ref.childByAppendingPath(playerData.isHost ? "hostPlayer" : "opposingPlayer")
            .childByAppendingPath("isConnected").setValue(playerData.isConnected)
    }
    
    func scoreHasUpdated(playerData: PlayerData) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/\(currentMatchData!.matchID)")
        ref.childByAppendingPath(playerData.isHost ? "hostPlayer" : "opposingPlayer")
            .childByAppendingPath("score").setValue(playerData.score)
    }
    
    func currentTilesHaveUpdated(playerData: PlayerData) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/\(currentMatchData!.matchID)")
        var rawValues: [Int] = []
        for tile in playerData.currentTiles {
            rawValues.append(tile.rawValue)
        }
        ref.childByAppendingPath(playerData.isHost ? "hostPlayer" : "opposingPlayer")
            .childByAppendingPath("currentTiles").setValue(rawValues)
    }
    
    func targetNumberHasUpdated(playerData: PlayerData) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/\(currentMatchData!.matchID)")
        ref.childByAppendingPath(playerData.isHost ? "hostPlayer" : "opposingPlayer")
            .childByAppendingPath("targetNumber").setValue(playerData.targetNumber)
    }
    
    func currentlySelectedTilesHaveUpdated(playerData: PlayerData) {
        let ref = Firebase(url: Config.firebaseURL + "/matches/custom/\(currentMatchData!.matchID)")
        ref.childByAppendingPath(playerData.isHost ? "hostPlayer" : "opposingPlayer")
            .childByAppendingPath("currentlySelectedTiles").setValue(playerData.currentlySelectedTiles)
    }
}

enum MatchmakerError: ErrorType {
    case CustomMatchRoomDoesNotExist
    case CustomMatchIncorrectPassword
}

enum MatchStatus: String {
    case WaitingForPlayers = "WaitingForPlayers"
    case Gameplay = "Gameplay"
    case Ended = "Ended"
}