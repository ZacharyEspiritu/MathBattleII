//
//  MatchCreate.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 3/26/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class MatchCreate: CCNode {
    
    weak var matchName: CCTextField!
    weak var password: CCTextField!
    
    func create() {
        Matchmaker.sharedInstance.createNewCustomMatch(withCustomName: matchName.string, customPassword: password.string)
    }
    
    func join() {
        Matchmaker.sharedInstance.attemptToJoinCustomMatch(matchName: matchName.string, password: password.string)
    }
}