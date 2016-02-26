//
//  Matchmaker.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 2/22/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class Matchmaker {
    
    func createNewUnrankedMatch() {
        let ref = Firebase(url: Config.firebaseURL + "/matches/unranked")
        let unrankedMatchData: [String : AnyObject?] = [
            "hostPlayer": UserManager.sharedInstance.getCurrentUser()!.getUID(),
            "opposingPlayer": nil
        ]
    }
    
    func createNewUnrankedMatch(withCustomName customName: String!, customPassword: String!) {
        let ref: Firebase
        let matchData: NSDictionary
        if customName != nil && customPassword != nil {
            matchData = [
                "matchName": customName,
                "password": customPassword,
                "hostPlayer": UserManager.sharedInstance.getCurrentUser()!
            ]
            ref = Firebase(url: Config.firebaseURL + "/matches/custom")
        }
        else {
            matchData = [
                "hostPlayer": UserManager.sharedInstance.getCurrentUser()!
            ]
            ref = Firebase(url: Config.firebaseURL + "/matches/unranked")
        }
        ref.childByAppendingPath("").setValue(matchData)
    }
    
    func searchForOpenMatch() {
        
    }
}