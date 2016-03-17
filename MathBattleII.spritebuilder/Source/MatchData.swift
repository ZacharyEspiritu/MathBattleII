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
    
    var delegate: MatchDataDelegate?
    
    private var matchHasStarted: Bool = false
    
    
    init(hostPlayer: PlayerData, opposingPlayer: PlayerData) {
        self.hostPlayer = hostPlayer
        self.opposingPlayer = opposingPlayer
        self.hostPlayer.delegate = self
        self.opposingPlayer.delegate = self
    }
    
    func updateData(data data: NSDictionary) {
        if let hostData = data.objectForKey("hostPlayer") as? NSDictionary {
            hostPlayer.updateData(newData: hostData)
        }
        if let opposingData = data.objectForKey("opposingPlayer") as? NSDictionary {
            opposingPlayer.updateData(newData: opposingData)
        }
    }
    
    func hasMatchStarted() -> Bool {
        return matchHasStarted
    }
    
    func setMatchStarted() {
        matchHasStarted = true
    }
}

extension MatchData: PlayerDataDelegate {
    func playerDataHasUpdated(playerData: PlayerData) {
        delegate?.matchDataHasUpdated(self)
    }
}

protocol MatchDataDelegate {
    func matchDataHasUpdated(matchData: MatchData)
}