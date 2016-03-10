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
    
    let delegate: MatchDataDelegate? = nil
    
    var matchHasStarted: Bool = false
    
    
    init(hostPlayer: PlayerData, opposingPlayer: PlayerData) {
        self.hostPlayer = hostPlayer
        self.opposingPlayer = opposingPlayer
    }
    
    func updateData(data data: NSDictionary) {
        if let hostData = data.objectForKey("hostPlayer") as? NSDictionary {
            hostPlayer.updateData(newData: hostData)
        }
        if let opposingData = data.objectForKey("opposingPlayer") as? NSDictionary {
            opposingPlayer.updateData(newData: opposingData)
        }
        
        if data.objectForKey("shouldStart") as! Bool {
            if !matchHasStarted {
                startMatch()
            }
        }
    }
    
    private func startMatch() {
        matchHasStarted = true
    }
}

protocol MatchDataDelegate {
    func matchDataHasUpdated(matchData: MatchData)
}