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
    let displayName: String
    var isConnected: Bool = true {
        didSet {
            delegate?.connectionStatusHasUpdated(self)
        }
    }
    let isHost: Bool
    
    var score: Int = 0 {
        didSet {
            delegate?.scoreHasUpdated(self)
        }
    }
    
    var currentTiles: [TileValue] = [.Zero, .Zero, .Zero, .Zero, .Zero, .Zero, .Zero, .Zero, .Zero] {
        didSet {
            delegate?.currentTilesHaveUpdated(self)
        }
    }
    
    var currentlySelectedTiles: [Int] = [] {
        didSet {
            delegate?.currentlySelectedTilesHaveUpdated(self)
        }
    }
    
    var targetNumber: Int = 0 {
        didSet {
            delegate?.targetNumberHasUpdated(self)
        }
    }
    
    var delegate: PlayerDataDelegate?
    
    
    init(data: NSDictionary, isHost: Bool) {
        uid = data.objectForKey("uid") as! String
        displayName = data.objectForKey("displayName") as! String
        self.isHost = isHost
    }
    
    func updateData(newData data: NSDictionary) {
        if isConnected != data.objectForKey("isConnected") as! Bool {
            isConnected = data.objectForKey("isConnected") as! Bool
        }
        
        if score != data.objectForKey("score") as! Int {
            score = data.objectForKey("score") as! Int
        }
        
        if targetNumber != data.objectForKey("targetNumber") as! Int {
            targetNumber = data.objectForKey("targetNumber") as! Int
        }
        
        if let selectedTiles = data.objectForKey("currentlySelectedTiles") as? [Int] {
            currentlySelectedTiles = selectedTiles
        }
        else {
            if currentlySelectedTiles != [] {
                currentlySelectedTiles = []
            }
        }
        
        if let rawValuesOfCurrentTiles = data.objectForKey("currentTiles") as? [Int] {
            var newTiles: [TileValue] = []
            for rawValue in rawValuesOfCurrentTiles {
                let tileValue = TileValue(rawValue: rawValue) != nil ? TileValue(rawValue: rawValue)! : TileValue.Zero
                newTiles.append(tileValue)
            }
            if currentTiles != newTiles {
                currentTiles = newTiles
            }
        }
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
     Called whenever the Player's target number changes.
     - parameter playerData:   the `PlayerData` object
     */
    func targetNumberHasUpdated(playerData: PlayerData)
    
    /**
     Called whenever the Player's set of currently selected tiles changes.
     - parameter playerData:   the `PlayerData` object
     */
    func currentlySelectedTilesHaveUpdated(playerData: PlayerData)
}