//
//  PlayerData.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class PlayerData {
    
    var uid: String
    var displayName: String
    var isConnected: Bool = true
    
    var score: Int = 0
    
    var currentTiles: [Int] = []
    var targetNumber: Int = 0
    
    var needsToLaunch: Bool = false
    
    init(data: NSDictionary) {
        uid = data.objectForKey("uid") as! String
        displayName = data.objectForKey("displayName") as! String
    }
    
    func updateData(newData data: NSDictionary) {
        uid = data.objectForKey("uid") as! String
        displayName = data.objectForKey("displayName") as! String
        isConnected = data.objectForKey("isConnected") as! Bool
        score = data.objectForKey("score") as! Int
        currentTiles = data.objectForKey("currentTiles") as! [Int]
        targetNumber = data.objectForKey("targetNumber") as! Int
        needsToLaunch = data.objectForKey("needsToLaunch") as! Bool
    }
}