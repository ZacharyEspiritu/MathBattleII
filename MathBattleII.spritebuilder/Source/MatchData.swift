//
//  MatchData.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/6/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MatchData {
    
    let matchID: String
    let hostPlayer: PlayerData
    var opposingPlayer: PlayerData!
    
    let matchType: MatchType
        
    private var matchHasStarted: Bool = false
    
    
    init(matchID: String, hostPlayer: PlayerData, opposingPlayer: PlayerData?, matchType: MatchType) {
        self.matchID = matchID
        self.hostPlayer = hostPlayer
        self.opposingPlayer = opposingPlayer
        self.matchType = matchType
    }
    
    /**
     Updates the `MatchData` object with the supplied data.
     - parameter newData:   an `NSDictionary` of the new data
     */
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