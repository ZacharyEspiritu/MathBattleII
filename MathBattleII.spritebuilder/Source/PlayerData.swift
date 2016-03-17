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
    
    var score: Int = 0
    
    var currentTiles: [TileValue] = []
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
        delegate?.playerDataHasUpdated(self)
        
        let rawValuesOfCurrentTiles = data.objectForKey("currentTiles") as! [Int]
        currentTiles.removeAll()
        for rawValue in rawValuesOfCurrentTiles {
            let tileValue = TileValue(rawValue: rawValue) != nil ? TileValue(rawValue: rawValue)! : TileValue.Zero
            currentTiles.append(tileValue)
        }
    }
}

protocol PlayerDataDelegate {
    func playerDataHasUpdated(playerData: PlayerData)
}