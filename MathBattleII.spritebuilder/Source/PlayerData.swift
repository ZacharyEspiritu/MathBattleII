//
//  PlayerData.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class PlayerData {
    
    private let uid: String
    private let displayName: String
    private var isConnected: Bool = true
    
    private var score: Int = 0
    
    var currentTiles: [TileValue] = [.Zero, .Zero, .Zero, .Zero, .Zero, .Zero, .Zero, .Zero, .Zero]
    var targetNumber: Int = 0
    
    var needsToLaunch: Bool = false
    
    var delegate: PlayerDataDelegate?
    
    
    init(data: NSDictionary) {
        uid = data.objectForKey("uid") as! String
        displayName = data.objectForKey("displayName") as! String
    }
    
    func updateData(newData data: NSDictionary) {
        isConnected = data.objectForKey("isConnected") as! Bool
        score = data.objectForKey("score") as! Int
        targetNumber = data.objectForKey("targetNumber") as! Int
        needsToLaunch = data.objectForKey("needsToLaunch") as! Bool
        
        let rawValuesOfCurrentTiles = data.objectForKey("currentTiles") as! [Int]
        currentTiles.removeAll()
        for rawValue in rawValuesOfCurrentTiles {
            let tileValue = TileValue(rawValue: rawValue) != nil ? TileValue(rawValue: rawValue)! : TileValue.Zero
            currentTiles.append(tileValue)
        }
    }
    
    func getConnectionStatus() -> Bool {
        return isConnected
    }
    
    func getScore() -> Int {
        return score
    }
}

protocol PlayerDataDelegate {
    /**
     Called whenever the Player's connection status changes.
     - parameter playerData:   the `PlayerData` object
     */
    func connectionStatusHasUpdated(playerData: PlayerData)
    
    /**
     Called whenever the Player's score changes.
     - parameter playerData:   the `PlayerData` object
     */
    func scoreHasUpdated(playerData: PlayerData)
    
    /**
     Called whenever the Player's current tile set changes.
     - parameter playerData:   the `PlayerData` object
     */
    func currentTilesHaveUpdated(playerData: PlayerData)
    
    /**
     Called whenever the Player's target number updates.
     - parameter playerData:   the `PlayerData` object
     */
    func targetNumberHasUpdated(playerData: PlayerData)
    
    /**
     Called whenever the Player's puzzle has been solved and the tiles in his set need to be visually launched.
     - parameter playerData:   the `PlayerData` object
     */
    func needsToLaunchTiles(playerData: PlayerData)
}