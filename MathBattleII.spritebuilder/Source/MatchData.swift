//
//  MatchData.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MatchData {
    
    let hostPlayer: PlayerData
    let opposingPlayer: PlayerData
    
    init(hostPlayer: PlayerData, opposingPlayer: PlayerData) {
        self.hostPlayer = hostPlayer
        self.opposingPlayer = opposingPlayer
    }
    
    func updateData(data data: NSDictionary) {
        hostPlayer.updateData(newData: data.objectForKey("hostPlayer") as! NSDictionary)
        opposingPlayer.updateData(newData: data.objectForKey("opposingPlayer") as! NSDictionary)
        print("data updated")
    }
}